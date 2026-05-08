import 'package:flutter/material.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session_target.dart';

class CreateAndStartSessoinParams {
  final String name;
  final String location;
  final String connectionMethod;
  final TimeOfDay startTime;
  final int durationMinutes;
  final double allowedRadius;
  final CreateSessionTarget target;

  CreateAndStartSessoinParams({
    required this.name,
    required this.location,
    required this.connectionMethod,
    required this.startTime,
    required this.durationMinutes,
    required this.allowedRadius,
    required this.target,
  });
}
