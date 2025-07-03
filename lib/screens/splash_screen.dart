import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  static const String appName = 'Receeptly';
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(appName.length, (i) => AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    ));
    _animations = _controllers.map((controller) =>
      Tween<double>(begin: 0, end: -32)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller)
    ).toList();
    _startAnimation();
    // Navigate after animation
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    });
  }

  void _startAnimation() async {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].forward();
      await Future.delayed(const Duration(milliseconds: 180));
      _controllers[i].reverse();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(appName.length, (i) {
            return AnimatedBuilder(
              animation: _animations[i],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animations[i].value),
                  child: Text(
                    appName[i],
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
} 