import 'package:equatable/equatable.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';

sealed class UserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileLoading extends UserProfileState {}

final class UserProfileLoaded extends UserProfileState {
  final User user;
  
  UserProfileLoaded(this.user);
  
  @override
  List<Object?> get props => [user];
}

final class UserProfileFailure extends UserProfileState {
  final String message;
  
  UserProfileFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}

final class ProfileImageUpdating extends UserProfileState {}

final class ProfileImageUpdated extends UserProfileState {
  final String imagePath;
  
  ProfileImageUpdated(this.imagePath);
  
  @override
  List<Object?> get props => [imagePath];
}

final class ProfileUpdating extends UserProfileState {}

final class ProfileUpdated extends UserProfileState {
  final User user;
  
  ProfileUpdated(this.user);
  
  @override
  List<Object?> get props => [user];
}