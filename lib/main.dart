// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'new_session_page.dart';
import 'past_sessions_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOOZEN',
      theme: ThemeData(
        fontFamily: 'FunnelDisplay',
        primarySwatch: Colors.purple, // Set the primary swatch to purple
        brightness: Brightness.dark, // Set the theme to dark
        scaffoldBackgroundColor: Colors.black, // Set the scaffold background color to black
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Set default text color to white
          bodyMedium: TextStyle(color: Colors.white), // Set default text color to white
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const int circleCount = 6;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duration of the animation
    )..forward(); // Play the animation once

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Decelerating curve
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Set AppBar background color to black
      ),
      body: Stack(
        children: [
          // Animated circles
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: CirclesPainter(
                  animationValue: _animation.value,
                  circleCount: circleCount,
                ),
                child: Container(),
              );
            },
          ),
          // UI elements
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome to\nSOOZEN',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white), // Set text color to white
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewSessionPage()),
                    );
                  },
                  child: const Text(
                    'New Session',
                    style: TextStyle(fontSize: 24, color: Colors.black), // Set button text color to black
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Set button background color to white
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PastSessionsPage()),
                    );
                  },
                  child: const Text(
                    'View Previous Sessions',
                    style: TextStyle(fontSize: 18, color: Colors.white), // Set text color to white
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CirclesPainter extends CustomPainter {
  final double animationValue;
  final int circleCount;

  CirclesPainter({required this.animationValue, required this.circleCount});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double baseCenterY = size.height * 1.3;
    final double movement = size.height * 0.1; // Increased movement
    final double centerY = baseCenterY - (animationValue * movement);
    final double minRadius = size.height / 3;
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0; // Increased stroke width

    for (int i = 0; i < circleCount; i++) {
      final double radius = minRadius + (i * minRadius * 0.2);
      final double opacity = (1 - (i / circleCount)) * 0.05; // Increased opacity
      paint.color = Colors.blue.withOpacity(opacity * animationValue * 3);
      canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CirclesPainter oldDelegate) => true;
}