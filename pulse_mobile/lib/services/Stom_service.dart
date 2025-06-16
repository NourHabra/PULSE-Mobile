import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter/material.dart';

import '../models/consent_request.dart';
import 'connections.dart';

class StompService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  StompClient? _stompClient;
  final String _webSocketUrl = 'wss://192.168.210.222:8443/ws/websocket';

  final RxList<ConsentRequest> _consentHistory = <ConsentRequest>[].obs;
  RxList<ConsentRequest> get consentHistory => _consentHistory;

  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }

  Future<void> connect() async {
    if (_stompClient != null && _stompClient!.connected) {
      log('STOMP client already connected.');
      return;
    }

    final token = await _apiService.getToken();
    if (token == null) {
      log('STOMP: Authentication token not found. Cannot connect.');
      Get.snackbar('Error', 'Authentication token not found. Cannot connect to real-time updates.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final stompConnectHeaders = {
      'Authorization': 'Bearer $token',
      'accept-version': '1.2',
    };

    final webSocketConnectHeaders = {
      'Authorization': 'Bearer $token',
    };

    _stompClient = StompClient(
      config: StompConfig(
        url: _webSocketUrl,
        onConnect: _onConnect,
        onWebSocketError: _onWebSocketError,
        onStompError: _onStompError,
        onDisconnect: _onDisconnected,
        stompConnectHeaders: stompConnectHeaders,
        webSocketConnectHeaders: webSocketConnectHeaders,
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    _stompClient?.activate();
    log('STOMP: Attempting to connect to $_webSocketUrl');
  }

  void _onConnect(StompFrame frame) {
    log('STOMP: Connected! Frame headers: ${frame.headers}');
    isConnected.value = true;
    Get.snackbar('Connected', 'Real-time updates enabled.', snackPosition: SnackPosition.BOTTOM);

    _stompClient?.subscribe(
      destination: '/user/queue/patient.consents',
      headers: {'id': 'pq'},
      callback: (frame) {
        log('STOMP: Received message on /user/queue/patient.consents: ${frame.body}');
        if (frame.body != null) {
          try {
            final Map<String, dynamic> consentData = json.decode(frame.body!);
            final String? type = consentData['type'];
            final int? consentId = consentData['consentId'];
            final int? doctorId = consentData['doctorId'];
            final String? status = consentData['status'];

            if (type == 'CONSENT_REQUEST' && doctorId != null && consentId != null && status == 'PENDING') {
              final String displayMessage =
                  'Doctor with ID $doctorId requested your consent to access your medical record.';

              // --- MODIFIED: Capture current time for receivedAt ---
              final newRequest = ConsentRequest(
                id: consentId,
                doctorId: doctorId,
                message: displayMessage, // Or directly use 'Doctor with ID $doctorId requested...'
                status: status!, // 'PENDING'
                receivedAt: DateTime.now(), // *** Captured current time ***
              );
              _consentHistory.insert(0, newRequest); // Add to the beginning of the list

              _showConsentRequestDialog(consentId, doctorId, displayMessage);
            } else {
              log('STOMP: Received non-consent request or non-pending status message: ${frame.body}');
            }
          } catch (e) {
            log('STOMP: Error parsing consent message JSON: $e');
            Get.snackbar('Error', 'Failed to parse consent update.', snackPosition: SnackPosition.BOTTOM);
          }
        }
      },
    );
    log('STOMP: Subscribed to /user/queue/patient.consents');
  }

  void _onWebSocketError(dynamic error) {
    log('STOMP: WebSocket Error: $error');
    isConnected.value = false;
    Get.snackbar('WebSocket Error', 'Real-time connection lost: $error', snackPosition: SnackPosition.BOTTOM);
  }

  void _onStompError(StompFrame frame) {
    log('STOMP: STOMP Error: ${frame.body}');
    Get.snackbar('STOMP Error', 'Real-time protocol error: ${frame.body}', snackPosition: SnackPosition.BOTTOM);
  }

  void _onDisconnected(StompFrame? frame) {
    log('STOMP: Disconnected. Frame: ${frame?.body ?? "N/A"}');
    isConnected.value = false;
    Get.snackbar('Disconnected', 'Real-time updates stopped.', snackPosition: SnackPosition.BOTTOM);
  }

  void disconnect() {
    if (_stompClient != null && _stompClient!.connected) {
      _stompClient?.deactivate();
      _stompClient = null;
      log('STOMP: Client deactivated.');
    }
  }

  void sendMessage(String destination, String body) {
    if (_stompClient != null && _stompClient!.connected) {
      _stompClient?.send(
        destination: destination,
        body: body,
      );
      log('STOMP: Sent message to $destination: $body');
    } else {
      log('STOMP: Not connected, cannot send message.');
      Get.snackbar('Error', 'Not connected to send message.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _showConsentRequestDialog(int consentId, int doctorId, String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Consent Request'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Deny'),
            onPressed: () {
              Get.back();
              _sendConsentResponse(consentId, doctorId, 'DENY');
              log('User DENIED consent for doctor $doctorId (Consent ID: $consentId)');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
          TextButton(
            child: const Text('Allow'),
            onPressed: () {
              Get.back();
              _sendConsentResponse(consentId, doctorId, 'APPROVE');
              log('User GRANTED consent for doctor $doctorId (Consent ID: $consentId)');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _sendConsentResponse(int consentId, int doctorId, String decision) async {
    try {
      await _apiService.updateConsentStatus(consentId, decision);

      final index = _consentHistory.indexWhere((req) => req.id == consentId);
      if (index != -1) {
        _consentHistory[index].status = decision;
        _consentHistory.refresh();
      }

      Get.snackbar(
        'Success',
        'Consent $decision for doctor $doctorId successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      log('Error sending consent response: $e');
      Get.snackbar(
        'Error',
        'Failed to $decision consent for doctor $doctorId: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}