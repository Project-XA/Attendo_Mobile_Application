import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/attendance/data/models/get-user-statistics/get_user_statisticts_response_model.dart';
import 'package:mobile_app/features/auth/register/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/register/data/models/register_response_body.dart';

abstract class UserRemoteDataSource {
  Future<RegisterResponseBody> registerUser(RegisterRequestBody request);
  Future<GetUserStatistictsResponseModel> getUserStatistics();
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final NetworkService networkService;

  UserRemoteDataSourceImp(this.networkService);

  @override
  Future<RegisterResponseBody> registerUser(RegisterRequestBody request) async {
    try {
      final response = await networkService.post(
        ApiConst.register,
        request.toJson(),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return RegisterResponseBody.fromJson(data);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

 

  @override
  Future<GetUserStatistictsResponseModel> getUserStatistics() async {
    try {
      final response = await networkService.get(ApiConst.userStatistics);

      final data = response.data['data'] as Map<String, dynamic>;
      return GetUserStatistictsResponseModel.fromJson(data);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }


}
