import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/core/themes/app_colors.dart';

class AutoTextSlider extends StatefulWidget {
  const AutoTextSlider({super.key});

  @override
  State<AutoTextSlider> createState() => _AutoTextSliderState();
}

class _AutoTextSliderState extends State<AutoTextSlider> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<String> _texts = [
    "Manage your\ndaily Attendance",
    "User Panel for\ntracking attendance",
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      _index = (_index + 1) % _texts.length;

      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _texts.length,
        itemBuilder: (context, index) {
          return Text(
            _texts[index],
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          );
        },
      ),
    );
  }
}