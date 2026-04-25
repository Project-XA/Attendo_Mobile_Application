import 'package:flutter/material.dart';

class ThemeTransitionOverlay extends StatefulWidget {
  final bool isDark;
  final VoidCallback onComplete;

  const ThemeTransitionOverlay({
    super.key,
    required this.isDark,
    required this.onComplete,
  });

  @override
  State<ThemeTransitionOverlay> createState() =>
      _ThemeTransitionOverlayState();
}

class _ThemeTransitionOverlayState extends State<ThemeTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _rippleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _fadeAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    _rippleAnim = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.6),
          ),
        );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black;
    final rippleColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: _fadeAnim.value,
          child: Container(
            color: bgColor,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple rings
                  ...List.generate(3, (i) {
                    final delay = i * 0.15;
                    final progress =
                        (_rippleAnim.value - delay).clamp(0.0, 1.0);
                    return Transform.scale(
                      scale: 1.0 + progress * (2.5 + i * 0.8),
                      child: Opacity(
                        opacity: (1.0 - progress) * 0.5,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: rippleColor,
                          ),
                        ),
                      ),
                    );
                  }),

                  // Icon
                  Transform.scale(
                    scale: _scaleAnim.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.06),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: iconColor,
                        size: 38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}