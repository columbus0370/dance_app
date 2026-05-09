import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage>
    with
        SingleTickerProviderStateMixin {
  late AnimationController
      _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
              seconds: 2),
    )..forward();

    Future.delayed(
      const Duration(
          seconds: 3),
      () {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget neonPad(
      Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration:
          BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(
                10),
        boxShadow: [
          BoxShadow(
            color:
                color.withOpacity(
                    0.8),
            blurRadius: 18,
          )
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(
              0xFF09090F),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                neonPad(
                    Colors.cyan),
                const SizedBox(
                    width: 10),
                neonPad(
                    Colors.pinkAccent),
              ],
            ),
            const SizedBox(
                height: 10),
            Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                neonPad(
                    Colors.deepPurpleAccent),
                const SizedBox(
                    width: 10),
                neonPad(
                    Colors.greenAccent),
              ],
            ),
            const SizedBox(
                height: 28),
            const Text(
              'GrooveTracks',
              style: TextStyle(
                color:
                    Colors.white,
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(
                height: 8),
            const Text(
              'STREET MODE',
              style: TextStyle(
                color: Colors.cyan,
                letterSpacing: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}