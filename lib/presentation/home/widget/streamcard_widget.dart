import 'package:flutter/material.dart';
import 'package:streamed_mobile/app/theme/text_theme.dart';
import 'package:streamed_mobile/app/utils/capitalize_text.dart';



class StreamcardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String posterUrl;
  final Function() onTap;

  const StreamcardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              posterUrl,
              height: 100,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  width: 200,
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, size: 40, color: Colors.grey)
                );
              },
    
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 100,
                  width: 200,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: AppTextTheme.darkTextTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Text(CapitalizeText().capitalize(description)),
        ],
      ),
    );
  }
}
