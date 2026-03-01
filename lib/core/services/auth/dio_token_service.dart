// جديد
import 'package:mobile_app/core/networking/dio_factory.dart';

abstract class ITokenService {
  Future<void> clearTokens();
}

class DioTokenService implements ITokenService {
  @override
  Future<void> clearTokens() async {
    await DioFactory.clearTokens(); 
  }
}