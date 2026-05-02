import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_sections/get_all_sections_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_request.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_response.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session_creation_params.dart';

abstract class SessionRepository {
  Future<Session> createSessionHall({
    required SessionCreationParams params,
    required int? hallId,
  });

  Future<Session> createSessionSection({
    required int? sectionId,
    required SessionCreationParams params,
  });

  Future<GetAllSectionsResponse> getAllSections();

  Future<ServerInfo> startSessionServer(int sessionId);

  Future<void> endSession(int sessionId);

  Stream<AttendanceRecord> getAttendanceStream();

  Future<Session?> getCurrentActiveSession();
  Future<SaveAttendanceResponse> saveAttendance(SaveAttendanceRequest request);
  Future<GetAllHallsResponse> getAllHalls();
  Future<void> deleteCurrentSession();
}
