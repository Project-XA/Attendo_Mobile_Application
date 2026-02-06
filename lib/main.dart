import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/core/current_user/data/Auth_services/auth_state_model.dart';
import 'package:mobile_app/core/app_boot_strap.dart';
import 'package:mobile_app/core/current_user/data/models/organization_model.dart';
import 'package:mobile_app/core/current_user/data/models/user_org_model.dart';
import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/cache_halls_data.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/hall_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AuthStateModelAdapter());

  Hive.registerAdapter(UserOrgModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(OrganizationModelAdapter());
  Hive.registerAdapter(HallModelAdapter());
  Hive.registerAdapter(CacheHallsDataAdapter());

  runApp(const AppBootstrap());
}
