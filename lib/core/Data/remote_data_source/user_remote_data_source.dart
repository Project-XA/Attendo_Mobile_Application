import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/register/data/models/register_request_body.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(RegisterRequestBody request); 
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final NetworkService networkService;
  
  UserRemoteDataSourceImp(this.networkService);
  
  @override
  Future<UserModel> getUser(RegisterRequestBody request) async {
    print('🌐 [UserRemoteDataSource] getUser() started');
    print('🔗 API endpoint: ${ApiConst.register}');
    print('📦 Request data: ${request.toJson()}');
    
    try {
      print('📡 [UserRemoteDataSource] Sending POST request...');
      
      final response = await networkService.post(
        ApiConst.register,
        request.toJson(),
      );
      
      print('📨 [UserRemoteDataSource] Response received');
      print('📊 Status code: ${response.statusCode}');
      print('📄 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        print('✅ [UserRemoteDataSource] Status 200 - SUCCESS');
        final data = response.data['data'];
        print('📦 User data from response: $data');
        
        final userModel = UserModel.fromJson(data);
        print('👤 [UserRemoteDataSource] UserModel created: ${userModel.toJson()}');
        
        return userModel;
      } else if (response.statusCode == 400) {
        print('❌ [UserRemoteDataSource] Status 400 - Bad Request');
        throw Exception('Invalid credentials or user not a member');
      } else if (response.statusCode == 404) {
        print('❌ [UserRemoteDataSource] Status 404 - Not Found');
        throw Exception('Organization not found');
      } else {
        print('❌ [UserRemoteDataSource] Status ${response.statusCode} - Unknown Error');
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 [UserRemoteDataSource] EXCEPTION caught');
      print('⚠️ Error type: ${e.runtimeType}');
      print('⚠️ Error message: ${e.toString()}');
      
      rethrow;
    }
  }
}