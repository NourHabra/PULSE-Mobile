import 'dart:io';
import 'dart:typed_data'; // For BytesBuilder

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';

import '../../theme/app_light_mode_colors.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({Key? key, required this.pdfUrl, this.title = 'Document'}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String? errorMessage;
  double _downloadProgress = 0.0; // New: To track download progress
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      _downloadProgress = 0.0; // Reset progress
    });

    try {
      final request = http.Request('GET', Uri.parse(widget.pdfUrl));
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final contentLength = response.contentLength; // Get total file size
        int downloadedBytes = 0;
        List<int> bytes = [];

        // Listen to the stream for progress updates
        await for (var chunk in response.stream) {
          bytes.addAll(chunk);
          downloadedBytes += chunk.length;
          setState(() {
            _downloadProgress = contentLength != null && contentLength > 0
                ? downloadedBytes / contentLength
                : 0.0; // Calculate progress
          });
        }

        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File(filePath);
        await file.writeAsBytes(Uint8List.fromList(bytes)); // Write all downloaded bytes to file

        setState(() {
          localPath = filePath;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to download PDF: Status ${response.statusCode}';
          isLoading = false;
        });
        Get.snackbar(
          'Download Error',
          'Failed to download PDF. Status code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error downloading PDF: ${e.toString()}';
        isLoading = false;
      });
      Get.snackbar(
        'Download Error',
        'An error occurred while downloading the PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: widget.title),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(), // You can use CircularProgressIndicator
            const SizedBox(height: 16),
            Text(
              'Downloading PDF... (${(_downloadProgress * 100).toStringAsFixed(0)}%)',
              style: const TextStyle(fontSize: 16,color:  AppLightModeColors.normalText),

            ),
            const SizedBox(height: 16),
            // Optional: A linear progress indicator for more visual feedback
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7, // 70% of screen width
              child: LinearProgressIndicator(
                value: _downloadProgress,
                backgroundColor: Colors.grey[200],
                color: AppLightModeColors.mainColor,
              ),
            ),
          ],
        ),
      )
          : errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _downloadPdf, // Call _downloadPdf to retry
                child: const Text('Retry Download'),
              ),
            ],
          ),
        ),
      )
          : localPath != null
          ? PDFView(
        filePath: localPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: false,
        onRender: (_pages) {
          print("PDF Rendered with $_pages pages.");
        },
        onError: (error) {
          setState(() {
            errorMessage = 'Error rendering PDF: ${error.toString()}';
          });
          Get.snackbar(
            'PDF Render Error',
            'Could not render PDF: ${error.toString()}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        },
        onPageError: (page, error) {
          setState(() {
            errorMessage = 'Error on page $page: ${error.toString()}';
          });
          Get.snackbar(
            'Page Render Error',
            'Error on page $page: ${error.toString()}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _pdfViewController = pdfViewController;
        },
        onPageChanged: (int? page, int? total) {
          print('Page changed: $page/$total');
        },
      )
          : const Center(child: Text('No PDF to display.')),
    );
  }

  @override
  void dispose() {
    if (localPath != null && File(localPath!).existsSync()) {
      File(localPath!).delete();
    }
    super.dispose();
  }
}