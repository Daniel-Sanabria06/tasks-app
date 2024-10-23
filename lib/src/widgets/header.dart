import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HeaderWaveGradient extends StatelessWidget {
  const HeaderWaveGradient({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 1,
      width: size.width * 1,
      child: CustomPaint(
        painter: _HeaderWaveGradientPainter(),
      ),
    );
  }
}

class _HeaderWaveGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(center: Offset(0.0, 55.0), radius: 180);

    final Gradient gradiente = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Colors.blue.shade900,
          Colors.blue.shade600,
          Colors.blue.shade300,
        ],
        stops: [
          0.2,
          0.5,
          1.0,
        ]);

    final lapiz = Paint()..shader = gradiente.createShader(rect);

    // Propiedades
    // lapiz.color = Color(0xff615AAB);
    // lapiz.color = Colors.red;
    lapiz.style = PaintingStyle.fill; // .fill .stroke
    lapiz.strokeWidth = 20;

    final path = Path();

    // Dibujar con el path y el lapiz
    path.lineTo(0, size.height * 0.25);

// Reduzco la altura del primer punto de control para hacer la curva menos pronunciada
    path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.28, // Cambié de 0.30 a 0.28 para suavizar
        size.width * 0.5,
        size.height * 0.25); // Bajé de 0.25 a 0.24

// Reduzco también la altura del segundo punto de control
    path.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.22, // Cambié de 0.20 a 0.22
        size.width,
        size.height * 0.25); // Bajé el punto final de 0.25 a 0.24

    path.lineTo(size.width, 0);

    canvas.drawPath(path, lapiz);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
