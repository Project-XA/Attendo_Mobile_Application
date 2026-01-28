class GetUserStatistictsResponseModel {
  final int totalSessions;
  final int attendedSessions;
  final int missedSessions;
  final double attendancePercentage;

  GetUserStatistictsResponseModel({
    required this.totalSessions,
    required this.attendedSessions,
    required this.missedSessions,
    required this.attendancePercentage,
  });

  factory GetUserStatistictsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetUserStatistictsResponseModel(
      totalSessions: json['totalSessions'] as int,
      attendedSessions: json['attendedSessions'] as int,
      missedSessions: json['missedSessions'] as int,
      attendancePercentage: json['attendancePercentage'] as double,
    );
  }
}