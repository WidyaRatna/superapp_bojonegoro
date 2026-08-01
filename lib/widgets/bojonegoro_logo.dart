import 'package:flutter/material.dart';

/// Widget yang menampilkan Logo Resmi Kabupaten Bojonegoro dari Wikimedia
class BojonegoroLogoWidget extends StatelessWidget {
  final double size;

  const BojonegoroLogoWidget({
    super.key,
    this.size = 46,
  });

  static const String logoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/1/18/Logo_Kabupaten_Bojonegoro.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Center(
          child: Image.network(
            logoUrl,
            width: size * 0.78,
            height: size * 0.78,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.shield_rounded,
                color: Color(0xFF0D62F1),
                size: 26,
              );
            },
          ),
        ),
      ),
    );
  }
}
