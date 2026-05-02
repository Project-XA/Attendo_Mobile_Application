// get_all_sections_use_case.dart
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_sections/get_all_sections_response.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';

class GetAllSectionsUseCase {
  final SessionRepository _repository;

  GetAllSectionsUseCase(this._repository);

  Future<GetAllSectionsResponse> call() async {
    return await _repository.getAllSections();
  }
}