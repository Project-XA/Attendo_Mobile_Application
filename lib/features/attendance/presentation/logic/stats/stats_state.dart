import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';

sealed class StatsState {
  const StatsState();
}

final class StatsInitial extends StatsState {
  const StatsInitial();
}

final class StatsLoading extends StatsState {
  const StatsLoading();
}

final class StatsLoaded extends StatsState {
  final AttendanceStats stats;
  final bool hasError;

  const StatsLoaded({required this.stats, this.hasError = false});

  StatsLoaded copyWith({AttendanceStats? stats, bool? hasError}) {
    return StatsLoaded(
      stats: stats ?? this.stats,
      hasError: hasError ?? this.hasError,
    );
  }
}
