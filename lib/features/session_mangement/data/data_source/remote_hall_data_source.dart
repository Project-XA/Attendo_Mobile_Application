import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';

abstract class RemoteHallDataSource {
  Future<GetAllHallsResponse> getAllHalls(int organizationId);
}

class RemoteHallDataSourceImpl extends RemoteHallDataSource {
  final NetworkService networkService;

  RemoteHallDataSourceImpl({required this.networkService});

  @override
  Future<GetAllHallsResponse> getAllHalls(int organizationId) async {
    try {
      final response = await networkService.get(
        ApiConst.getAllHalls(organizationId),
      );

      final hallsList = (response.data['data'] as List<dynamic>)
          .map((json) => HallInfo.fromJson(json as Map<String, dynamic>))
          .toList();

      return GetAllHallsResponse(halls: hallsList);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
