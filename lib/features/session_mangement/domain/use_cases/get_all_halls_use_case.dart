import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';

class GetAllHallsUseCase {
  final SessionRepository _repository;

  GetAllHallsUseCase(this._repository);

  Future<GetAllHallsResponse> call() async {
    return await _repository.getAllHalls();
  }
}