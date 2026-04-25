import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/attendance/data/models/get-user-statistics/get_user_statisticts_response_model.dart';

abstract class UserRemoteDataSource {
  Future<GetUserStatistictsResponseModel> getUserStatistics();
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final NetworkService networkService;

  UserRemoteDataSourceImp(this.networkService);

  @override
  Future<GetUserStatistictsResponseModel> getUserStatistics() async {
    try {
      final response = await networkService.get(ApiConst.userStatistics);

      final data = response.data['data'] as Map<String, dynamic>;

      final stats = GetUserStatistictsResponseModel.fromJson(data);

      return stats;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
