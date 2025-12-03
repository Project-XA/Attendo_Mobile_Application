import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/routing/app_route.dart';

class AttendencyApp extends StatelessWidget {
  const AttendencyApp({super.key, required this.appRouter, required this.initialRoute});
final AppRoute appRouter;
  final String initialRoute;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(debugShowCheckedModeBanner: false,
      
        initialRoute: initialRoute,
        onGenerateRoute: appRouter.generateRoute,
       
       ),
    );
  }
}
