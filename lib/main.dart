import 'package:flutter/material.dart';

void main() {
  runApp(const BreathingApp());
}

class BreathingApp extends StatelessWidget {
  const BreathingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calm Breathing',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo.shade50,
      ),
      home: const BreathingGuideScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BreathingGuideScreen extends StatefulWidget {
  const BreathingGuideScreen({super.key});

  @override
  State<BreathingGuideScreen> createState() => _BreathingGuideScreenState();
}

class _BreathingGuideScreenState extends State<BreathingGuideScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> _phases = ["Inhale", "Hold", "Exhale", "Hold"];
  int _currentPhaseIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..addListener(() {
      final value = _controller.value;

      setState(() {
        if (value < 0.25) {
          _currentPhaseIndex = 0; // Inhale
        } else if (value < 0.5) {
          _currentPhaseIndex = 1; // Hold
        } else if (value < 0.75) {
          _currentPhaseIndex = 2; // Exhale
        } else {
          _currentPhaseIndex = 3; // Hold
        }
      });
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getCircleSize(double value) {
    if (value < 0.25) {
      return 100 + 100 * (value / 0.25); // Grow
    } else if (value < 0.5) {
      return 200; // Hold (expanded)
    } else if (value < 0.75) {
      return 200 - 100 * ((value - 0.5) / 0.25); // Shrink
    } else {
      return 100; // Hold (small)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calm Breathing'), centerTitle: true),
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1000),
          builder: (context, value, child) {
            final size = _getCircleSize(_controller.value);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _phases[_currentPhaseIndex],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo.withOpacity(0.4),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
