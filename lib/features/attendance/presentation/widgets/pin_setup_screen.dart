import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/UI/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/font_weight_helper.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (!_isConfirming) {
        if (_pin.length < 4) {
          _pin += number;
          if (_pin.length == 4) {
            _isConfirming = true;
          }
        }
      } else {
        if (_confirmPin.length < 4) {
          _confirmPin += number;
          if (_confirmPin.length == 4) {
            _verifyPins();
          }
        }
      }
    });
  }

  void _verifyPins() {
    if (_pin == _confirmPin) {
      // ⭐ استخدم pop مع الـ dialog
      Navigator.of(context, rootNavigator: true).pop(_pin);
    } else {
      // Reset and show error
      setState(() {
        _pin = '';
        _confirmPin = '';
        _isConfirming = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match. Please try again.')),
      );
    }
  }

  void _onDeletePressed() {
    setState(() {
      if (!_isConfirming) {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPin = _isConfirming ? _confirmPin : _pin;

    return Scaffold(
      backgroundColor: AppColors.backGroundColorWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.mainTextColorBlack,
          ),
          // ⭐ استخدم rootNavigator
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(
              _isConfirming ? 'Confirm your PIN' : 'Create your PIN',
              style: TextStyle(
                color: AppColors.mainTextColorBlack,
                fontSize: 20.sp,
                fontWeight: FontWeightHelper.medium,
              ),
            ),
            verticalSpace(40),
            _buildPinDots(currentPin),
            const Spacer(),
            _buildNumberPad(),
            verticalSpace(40),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots(String pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pin.length
                ? AppColors.mainTextColorBlack
                : AppColors.mainTextColorBlack.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        _buildNumberRow(['1', '2', '3']),
        verticalSpace(20),
        _buildNumberRow(['4', '5', '6']),
        verticalSpace(20),
        _buildNumberRow(['7', '8', '9']),
        verticalSpace(20),
        _buildLastRow(),
      ],
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
        SizedBox(width: 80.w),
        _buildNumberButton('0'),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: 80.w,
        height: 80.w,
        alignment: Alignment.center,
        child: Text(
          number,
          style: TextStyle(
            color: AppColors.mainTextColorBlack,
            fontSize: 32.sp,
            fontWeight: FontWeightHelper.light,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: _onDeletePressed,
      child: Container(
        width: 80.w,
        height: 80.w,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_outlined,
          color: AppColors.mainTextColorBlack,
          size: 28.sp,
        ),
      ),
    );
  }
}