import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';

class NearbySessionModel {
  final String sessionId;
  final String name;
  final String location;
  final String connectionMethod;
  final DateTime startTime;
  final int durationMinutes;
  final String ipAddress;
  final int port;
  final int attendeeCount;
  final bool isActive;
  final int organizationId; 

  NearbySessionModel({
    required this.sessionId,
    required this.name,
    required this.location,
    required this.connectionMethod,
    required this.startTime,
    required this.durationMinutes,
    required this.ipAddress,
    required this.port,
    required this.organizationId, 
    this.attendeeCount = 0,
    this.isActive = true,
  });

// في nearby_session_model.dart
factory NearbySessionModel.fromJson(Map<String, dynamic> json, String host, int port) {
  return NearbySessionModel(
    sessionId: json['sessionId']?.toString() ?? '',
    name: json['name'] ?? '',
    location: json['location'] ?? '',
    connectionMethod: json['connectionMethod'] ?? '',
    startTime: DateTime.tryParse(json['startTime'] ?? '') ?? DateTime.now(),
    durationMinutes: json['durationMinutes'] as int? ?? 0,
    attendeeCount: json['attendeeCount'] as int? ?? 0,
    ipAddress: host,
    port: port,
    organizationId: json['organizationId'] is int 
        ? json['organizationId'] as int
        : int.tryParse(json['organizationId']?.toString() ?? '0') ?? 0,
  );
}

  NearbySession toEntity() {
    return NearbySession(
      sessionId: sessionId,
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: startTime,
      durationMinutes: durationMinutes,
      ipAddress: ipAddress,
      port: port,
      organizationId: organizationId, 
      attendeeCount: attendeeCount,
      isActive: isActive,
    );
  }
}