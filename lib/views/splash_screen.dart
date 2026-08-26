import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Default startup as Guest user
    AuthService().loginAsGuest();

    // Automatically navigate to Home Screen after 2.5 seconds
    _timer = Timer(const Duration(milliseconds: 2500), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          isDarkMode: widget.isDarkMode,
          onToggleDarkMode: widget.onToggleDarkMode,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Layer 1: Seamless Vertical Sky-to-Ice Blue Gradient Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE5F1FF), // Soft sky blue top
                      Color(0xFFF3F8FF),
                      Colors.white,      // Pure white center
                      Color(0xFFF0F7FF),
                      Color(0xFFDCEEFF), // Ice blue bottom
                    ],
                    stops: [0.0, 0.22, 0.50, 0.78, 1.0],
                  ),
                ),
              ),
            ),

            // Layer 2: Top Sky Arc Waves (Translucent curves sweeping from top-left)
            Positioned.fill(
              child: CustomPaint(
                painter: TopWavesPainter(),
              ),
            ),

            // Layer 3: Bottom Ice-Blue Flowing Wave Ribbons
            Positioned.fill(
              child: CustomPaint(
                painter: BottomWavesPainter(),
              ),
            ),

            // Layer 4: Seamless Integrated Graphic Asset (Transparent & Softly Blended Edges)
            SafeArea(
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'assets/images/super image.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/bupati_wakil.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => Container(
                          color: const Color(0xFF0F172A),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance_rounded,
                                  size: 64,
                                  color: Color(0xFF0D62F1),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'SuperApp Bojonegoro',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for top-left sky blue translucent arc waves
class TopWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Soft top-left gradient fill
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromRGBO(199, 226, 254, 0.45),
          Color.fromRGBO(224, 240, 254, 0.20),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.35));

    final pathFill = Path();
    pathFill.moveTo(0, 0);
    pathFill.lineTo(size.width, 0);
    pathFill.cubicTo(
      size.width * 0.8, size.height * 0.18,
      size.width * 0.3, size.height * 0.22,
      0, size.height * 0.12,
    );
    pathFill.close();
    canvas.drawPath(pathFill, fillPaint);

    // Glowing arc line 1
    final strokePaint1 = Paint()
      ..color = const Color.fromRGBO(124, 182, 248, 0.35)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final pathLine1 = Path();
    pathLine1.moveTo(0, size.height * 0.16);
    pathLine1.cubicTo(
      size.width * 0.35, size.height * 0.24,
      size.width * 0.75, size.height * 0.15,
      size.width, size.height * 0.05,
    );
    canvas.drawPath(pathLine1, strokePaint1);

    // Glowing arc line 2 (white highlight)
    final strokePaint2 = Paint()
      ..color = const Color.fromRGBO(255, 255, 255, 0.65)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final pathLine2 = Path();
    pathLine2.moveTo(0, size.height * 0.11);
    pathLine2.cubicTo(
      size.width * 0.40, size.height * 0.19,
      size.width * 0.80, size.height * 0.10,
      size.width, size.height * 0.02,
    );
    canvas.drawPath(pathLine2, strokePaint2);

    // Glowing arc line 3 (outer soft blue)
    final strokePaint3 = Paint()
      ..color = const Color.fromRGBO(176, 215, 255, 0.30)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final pathLine3 = Path();
    pathLine3.moveTo(0, size.height * 0.22);
    pathLine3.cubicTo(
      size.width * 0.30, size.height * 0.28,
      size.width * 0.70, size.height * 0.20,
      size.width, size.height * 0.10,
    );
    canvas.drawPath(pathLine3, strokePaint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for bottom ice-blue flowing wave ribbons
class BottomWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    // Layer 1: Base wave fill at bottom
    final fillPaint1 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color.fromRGBO(191, 222, 254, 0.55),
          Color.fromRGBO(220, 239, 254, 0.35),
          Color.fromRGBO(240, 247, 255, 0.10),
        ],
      ).createShader(Rect.fromLTWH(0, height * 0.65, width, height * 0.35));

    final wavePath1 = Path();
    wavePath1.moveTo(0, height * 0.76);
    wavePath1.cubicTo(
      width * 0.25, height * 0.86,
      width * 0.65, height * 0.95,
      width, height * 0.82,
    );
    wavePath1.lineTo(width, height);
    wavePath1.lineTo(0, height);
    wavePath1.close();
    canvas.drawPath(wavePath1, fillPaint1);

    // Layer 2: Secondary wave fill
    final fillPaint2 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color.fromRGBO(147, 197, 253, 0.35),
          Color.fromRGBO(199, 226, 254, 0.25),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, height * 0.70, width, height * 0.30));

    final wavePath2 = Path();
    wavePath2.moveTo(0, height * 0.84);
    wavePath2.cubicTo(
      width * 0.35, height * 0.78,
      width * 0.75, height * 0.90,
      width, height * 0.86,
    );
    wavePath2.lineTo(width, height);
    wavePath2.lineTo(0, height);
    wavePath2.close();
    canvas.drawPath(wavePath2, fillPaint2);

    // Wave stroke lines (flowing ribbons)
    final lineColors = [
      const Color.fromRGBO(96, 165, 250, 0.45),
      const Color.fromRGBO(255, 255, 255, 0.75),
      const Color.fromRGBO(147, 197, 253, 0.55),
      const Color.fromRGBO(191, 222, 254, 0.65),
    ];

    const strokeWidths = [2.5, 1.8, 3.0, 1.5];

    // Wave curve 1
    final strokePath1 = Path();
    strokePath1.moveTo(0, height * 0.75);
    strokePath1.cubicTo(
      width * 0.30, height * 0.85,
      width * 0.70, height * 0.93,
      width, height * 0.80,
    );
    canvas.drawPath(
      strokePath1,
      Paint()
        ..color = lineColors[0]
        ..strokeWidth = strokeWidths[0]
        ..style = PaintingStyle.stroke,
    );

    // Wave curve 2 (White highlight curve)
    final strokePath2 = Path();
    strokePath2.moveTo(0, height * 0.78);
    strokePath2.cubicTo(
      width * 0.28, height * 0.87,
      width * 0.68, height * 0.94,
      width, height * 0.83,
    );
    canvas.drawPath(
      strokePath2,
      Paint()
        ..color = lineColors[1]
        ..strokeWidth = strokeWidths[1]
        ..style = PaintingStyle.stroke,
    );

    // Wave curve 3
    final strokePath3 = Path();
    strokePath3.moveTo(0, height * 0.82);
    strokePath3.cubicTo(
      width * 0.35, height * 0.89,
      width * 0.75, height * 0.96,
      width, height * 0.87,
    );
    canvas.drawPath(
      strokePath3,
      Paint()
        ..color = lineColors[2]
        ..strokeWidth = strokeWidths[2]
        ..style = PaintingStyle.stroke,
    );

    // Wave curve 4
    final strokePath4 = Path();
    strokePath4.moveTo(0, height * 0.87);
    strokePath4.cubicTo(
      width * 0.40, height * 0.92,
      width * 0.80, height * 0.98,
      width, height * 0.92,
    );
    canvas.drawPath(
      strokePath4,
      Paint()
        ..color = lineColors[3]
        ..strokeWidth = strokeWidths[3]
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
