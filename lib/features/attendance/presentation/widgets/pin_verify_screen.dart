import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class PinVerifyScreen extends StatefulWidget {
  const PinVerifyScreen({super.key});

  @override
  State<PinVerifyScreen> createState() => _PinVerifyScreenState();
}

class _PinVerifyScreenState extends State<PinVerifyScreen> {
  String _pin = '';

  void _onNumberPressed(String number) {
    if (_pin.length < 4) {
      setState(() {
        _pin += number;
      });

      if (_pin.length == 4) {
        Navigator.pop(context, _pin);
      }
    }
  }

  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.backGroundColorWhite,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Enter your PIN',
              style: TextStyle(
                color: AppColors.backGroundColorWhite,
                fontSize: 24.sp,
                fontWeight: FontWeightHelper.semiBold,
              ),
            ),
            verticalSpace(8),
            Text(
              'Enter your 4-digit PIN to check in',
              style: TextStyle(
                color: AppColors.backGroundColorWhite.withOpacity(0.7),
                fontSize: 14.sp,
                fontWeight: FontWeightHelper.regular,
              ),
            ),
            verticalSpace(40),
            _buildPinDots(),
            const Spacer(),
            _buildNumberPad(),
            verticalSpace(40),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _pin.length
                ? AppColors.backGroundColorWhite
                : AppColors.backGroundColorWhite.withOpacity(0.3),
            border: Border.all(
              color: AppColors.backGroundColorWhite.withOpacity(0.5),
              width: 1,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          _buildNumberRow(['1', '2', '3']),
          verticalSpace(20),
          _buildNumberRow(['4', '5', '6']),
          verticalSpace(20),
          _buildNumberRow(['7', '8', '9']),
          verticalSpace(20),
          _buildLastRow(),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _buildNumberButton(number)).toList(),
    );
  }

  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 70.w, height: 70.w),
        _buildNumberButton('0'),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _onNumberPressed(number),
      borderRadius: BorderRadius.circular(35.r),
      child: Container(
        width: 70.w,
        height: 70.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.backGroundColorWhite.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          number,
          style: TextStyle(
            color: AppColors.backGroundColorWhite,
            fontSize: 28.sp,
            fontWeight: FontWeightHelper.regular,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: _onDeletePressed,
      borderRadius: BorderRadius.circular(35.r),
      child: Container(
        width: 70.w,
        height: 70.w,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_outlined,
          color: AppColors.backGroundColorWhite,
          size: 24.sp,
        ),
      ),
    );
  }
}