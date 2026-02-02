import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';

class LoadingState extends StatelessWidget {
  final String message;

  const LoadingState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          verticalSpace(16),
          Text(
            message,
            style: TextStyle(fontSize: 16.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
