import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session/create_hall_session_request_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session/create_section_session_request_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_sections/get_all_sections_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_request.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_response.dart';

abstract class RemoteSessionDataSource {
  Future<GetAllHallsResponse> getAllHalls(int organizationId);
  Future<GetAllSectionsResponse> getAllSections(int organizationId);

  Future<SaveAttendanceResponse> saveAttendance(SaveAttendanceRequest request);
  Future<int> createSessionHall(CreateHallSessionRequestModel createSessionRequest);
  Future<int> createSessionSection(
    CreateSectionSessionRequestModel createSessionRequest,
  );
}

class RemoteSessionDataSourceImpl extends RemoteSessionDataSource {
  final NetworkService networkService;

  RemoteSessionDataSourceImpl({required this.networkService});

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

  @override
  Future<GetAllSectionsResponse> getAllSections(int organizationId) async {
    try {
      final response = await networkService.get(
        ApiConst.getAllSections(organizationId),
      );
      final sectionsList = (response.data['data'] as List<dynamic>)
          .map((json) => SectionInfo.fromJson(json as Map<String, dynamic>))
          .toList();
      return GetAllSectionsResponse(sections: sectionsList);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<int> createSessionHall(
    CreateHallSessionRequestModel createSessionRequest,
  ) async {
    try {
      final response = await networkService.post(
        ApiConst.createSession,
        createSessionRequest.toJson(),
      );

      final sessionId = response.data['data']['sessionId'] as int;
      return sessionId;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<int> createSessionSection(
    CreateSectionSessionRequestModel createSessionRequest,
  ) async {
    try {
      final response = await networkService.post(
        ApiConst.createSession,
        createSessionRequest.toJson(),
      );

      final sessionId = response.data['data']['sessionId'] as int;
      return sessionId;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<SaveAttendanceResponse> saveAttendance(
    SaveAttendanceRequest request,
  ) async {
    try {
      final response = await networkService.post(
        ApiConst.saveAttendance,
        request,
      );

      final data = response.data as Map<String, dynamic>;
      return SaveAttendanceResponse.fromJson(data);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
