import 'package:flutter/material.dart';

abstract class AuthStrategy {
  Future<bool> tryAuthenticate(BuildContext context);
}