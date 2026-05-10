import 'package:flutter/material.dart';

class LevelUpDialog extends StatefulWidget {
  final int newLevel;
  final String emoji;
  final String levelName;

  const LevelUpDialog({
    required this.newLevel,
    required this.emoji,
    required this.levelName,
    super.key,
  });

  @override
  State<LevelUpDialog> createState() =>
      _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController
      _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent:
            _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {
    return Dialog(
      backgroundColor:
          Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration:
              BoxDecoration(
            gradient:
                const LinearGradient(
              colors: [
                Color(0xFF1E1B4B),
                Color(0xFF111827),
              ],
              begin: Alignment
                  .topLeft,
              end: Alignment
                  .bottomRight,
            ),
            borderRadius:
                BorderRadius
                    .circular(24),
            border: Border.all(
              color: Colors.cyan,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan
                    .withOpacity(
                        0.5),
                blurRadius: 32,
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets
                    .all(32),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Text(
                  'LEVEL UP!',
                  style: TextStyle(
                    color:
                        Colors.cyan,
                    fontSize: 28,
                    fontWeight:
                        FontWeight
                            .bold,
                    letterSpacing:
                        2,
                  ),
                ),
                const SizedBox(
                    height: 16),
                Text(
                  widget.emoji,
                  style: const TextStyle(
                    fontSize: 72,
                  ),
                ),
                const SizedBox(
                    height: 16),
                Text(
                  'Lv. ${widget.newLevel}',
                  style:
                      const TextStyle(
                    color: Colors
                        .white,
                    fontSize: 32,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),
                const SizedBox(
                    height: 8),
                Text(
                  widget.levelName,
                  style:
                      const TextStyle(
                    color: Colors
                        .white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
