import 'package:dio/dio.dart';
import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/api_error_factory.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/core/networking/network_service.dart';

abstract class PsRemoteDataSource {
  Future<ApiResult<void>> deactivateAccount(String password);
  Future<ApiResult<void>> deleteAccount(String password);
  Future<ApiResult<void>> changePassword(
    String currentPassword,
    String newPassword,
  );
}

class PsRemoteDataSourceImpl implements PsRemoteDataSource {
  final NetworkService networkService;
  PsRemoteDataSourceImpl({required this.networkService});

  @override
  Future<ApiResult<void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final body = {
        'current_password': currentPassword,
        'new_password': newPassword,
      };
      await networkService.patch(ApiConst.deactivateAccount, body);
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.error(ApiErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.error(ApiErrorFactory.defaultError);
    }
  }

  @override
  Future<ApiResult<void>> deactivateAccount(String password) async {
    try {
      final body = {'password': password};
      await networkService.post(ApiConst.deactivateAccount, body);
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.error(ApiErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.error(ApiErrorFactory.defaultError);
    }
  }

  @override
  Future<ApiResult<void>> deleteAccount(String password) async {
    try {
      final body = {'password': password};
      await networkService.post(ApiConst.deleteAccountDELETE, body);
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.error(ApiErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.error(ApiErrorFactory.defaultError);
    }
  }
}
