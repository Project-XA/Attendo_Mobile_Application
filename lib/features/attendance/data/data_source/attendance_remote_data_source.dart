import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';
import 'package:mobile_app/features/attendance/data/models/nearby_session_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<NearbySession?> getSessionDetails(String baseUrl);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  static const Duration _requestTimeout = Duration(seconds: 3);

  @override
  Future<NearbySession?> getSessionDetails(String baseUrl) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/session-info'))
          .timeout(_requestTimeout);

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final uri = Uri.parse(baseUrl);
      return NearbySessionModel.fromJson(data, uri.host, uri.port).toEntity();
    } catch (_) {
      return null;
    }
  }
}