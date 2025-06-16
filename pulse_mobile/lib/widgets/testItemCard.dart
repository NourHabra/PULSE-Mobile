import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/app_light_mode_colors.dart'; // For better network image handling

class TestItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price; // e.g., "60 SYP"

  const TestItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    // Split price into number and currency for separate styling
    final List<String> priceParts = price.split(' ');
    final String priceNumber = priceParts.isNotEmpty ? priceParts[0] : price;
    final String priceCurrency = priceParts.length > 1 ? ' ${priceParts[1]}' : ''; // Add space before currency

    return SizedBox(
      width: 118,
      height: 170,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // Align all children to the start (left) horizontally
            mainAxisAlignment: MainAxisAlignment.center, // Keep vertical centering of content
            crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
            children: [
              // Image
              Expanded(
                child: Center( // Center the image horizontally within its expanded space
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 10), // Spacing between image and title
              // Title (Name) - Dynamic Font Size based on overflow
              LayoutBuilder(
                builder: (context, constraints) {
                  // Create a TextPainter to measure the text with the initial font size
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: title,
                      style: const TextStyle(
                        fontSize: 12, // Initial font size for measurement
                        fontWeight: FontWeight.bold,
                        color: AppLightModeColors.normalText,
                      ),
                    ),
                    textDirection: TextDirection.ltr, // Required for TextPainter
                    maxLines: 1, // We want to check if it overflows a single line
                  );

                  // Layout the text within the available horizontal constraints
                  textPainter.layout(maxWidth: constraints.maxWidth);

                  // Check if the text actually overflows the single line
                  final bool didOverflow = textPainter.didExceedMaxLines;

                  // Render the Text widget with the adjusted font size
                  return Text(
                    title,
                    textAlign: TextAlign.left, // Explicitly left-align
                    style: TextStyle(
                      fontSize: didOverflow ? 10 : 14, // Use 10 if overflow, else 12
                      fontWeight: FontWeight.bold,
                      color: AppLightModeColors.normalText,
                    ),
                    maxLines: 1, // Still only one line
                    // Removed overflow: TextOverflow.ellipsis as per your request
                  );
                },
              ),
              const SizedBox(height: 5), // Spacing between title and price
              // Price (with separate styles for number and currency)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: priceNumber,
                      style: const TextStyle(
                        fontSize: 20, // Price number font size
                        color: AppLightModeColors.normalText,
                        fontWeight: FontWeight.bold,
                        // Or bold if desired
                      ),
                    ),
                    TextSpan(
                      text: priceCurrency,
                      style: const TextStyle(
                        fontSize: 10, // SYP font size
                        color:AppLightModeColors.normalText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left, // Explicitly left-align
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
