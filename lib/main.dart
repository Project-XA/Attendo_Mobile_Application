import 'package:flutter/material.dart';
import 'package:mobile_app/attendency_app.dart';
import 'package:mobile_app/core/routing/app_route.dart';
import 'package:mobile_app/core/routing/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AttendencyApp(appRouter: AppRoute(), initialRoute: Routes.startPage));
}
