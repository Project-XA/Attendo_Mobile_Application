abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationLoading extends NavigationState {}

class NavigationToMainScreen extends NavigationState {
  final String role; // ← Changed from User to String
  
  NavigationToMainScreen(this.role);
}

class NavigationError extends NavigationState {
  final String message;
  
  NavigationError(this.message);
}