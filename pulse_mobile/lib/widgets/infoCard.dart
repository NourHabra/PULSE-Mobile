import 'package:flutter/material.dart';
class InfoCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String content;
  final IconData icon;

  const InfoCard({
    Key? key,
    required this.context,
    required this.title,
    required this.content,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 3.5,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent, // Make the background transparent

      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white,size: 32,),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}
