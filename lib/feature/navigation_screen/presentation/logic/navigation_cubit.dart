import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/core/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/navigation_screen/presentation/logic/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final UserLocalDataSource localDataSource;

  NavigationCubit({required this.localDataSource}) 
      : super(NavigationInitial());

  Future<void> determineNavigation() async {
    try {
      emit(NavigationLoading());
      
      // ✅ Get user from local storage
      final userModel = await localDataSource.getCurrentUser();
      final user = userModel.toEntity();
      
      // ✅ Check if registered
      if (!user.isRegistered || 
          user.organizations == null || 
          user.organizations!.isEmpty) {
        throw Exception('User is not registered in any organization');
      }
      
      // ✅ Get role
      final role = user.organizations!.first.role;
      
      // ✅ Emit with role string
      emit(NavigationToMainScreen(role));
      
    } catch (e) {
      print('❌ Navigation error: $e');
      emit(NavigationError(e.toString()));
    }
  }
}