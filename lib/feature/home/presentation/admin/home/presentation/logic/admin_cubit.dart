// feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/get_current_user_use_case.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  User? _currentUser;
  int _selectedTabIndex = 0;

  User? get currentUser => _currentUser;
  int get selectedTabIndex => _selectedTabIndex;

  AdminCubit({required this.getCurrentUserUseCase}) : super(AdminInitial());

  Future<void> loadUser() async {
    try {
      emit(AdminLoading());

      await Future.delayed(const Duration(milliseconds: 500));


      _currentUser = await getCurrentUserUseCase.call();

      emit(AdminUserLoaded(_currentUser!));
    } catch (e) {
      emit(AdminError('Failed to load user: $e'));
    }
  }

  void changeTab(int index) {
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    emit(ToggleTabChanged(index, _currentUser)); 
  }
}
