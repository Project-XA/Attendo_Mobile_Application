import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/data/models/register_response_body.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session_request_model.dart';

abstract class UserRemoteDataSource {
  Future<ApiResult<RegisterResponseBody>> registerUser(
    RegisterRequestBody request,
  );

  Future<ApiResult<void>> createSession(
    CreateSessionRequestModel createSessionRequest,
  );
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final NetworkService networkService;

  UserRemoteDataSourceImp(this.networkService);

  @override
  Future<ApiResult<RegisterResponseBody>> registerUser(
    RegisterRequestBody request,
  ) async {
    try {
      final response = await networkService.post(
        ApiConst.register,
        request.toJson(),
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final apiResponse = RegisterResponseBody.fromJson(data);
        return ApiResult.success(apiResponse);
      }
      return ApiResult.error(response);
    } catch (e) {
      return ApiResult.error(e);
    }
  }

  @override
  Future<ApiResult<void>> createSession(
    CreateSessionRequestModel createSessionRequest,
  ) async {
    try {
      final response = await networkService.post(
        ApiConst.createSession,
        createSessionRequest.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult.success(null);
      }

      return ApiResult.error(response);
    } catch (e) {
      return ApiError(e);
    }
  }
}
