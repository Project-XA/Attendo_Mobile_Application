import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/features/session_mangement/data/data_source/local_session_data_source.dart';
import 'package:mobile_app/features/session_mangement/data/data_source/remote_session_data_source.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/hall_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/local_models/section_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_halls/get_all_halls_response.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/get_all_sections/get_all_sections_response.dart';

class SessionCacheHelper {
  final LocalSessionDataSource _local;
  final RemoteSessionDataSource _remote;

  SessionCacheHelper({
    required LocalSessionDataSource local,
    required RemoteSessionDataSource remote,
  })  : _local = local,
        _remote = remote;


  Future<GetAllHallsResponse> getHalls(int organizationId) async {
    final cached = await _local.getCachedHalls();

    if (cached != null && !cached.shouldRefresh()) {
      return GetAllHallsResponse(
        halls: cached.halls.map((h) => h.toHallInfo()).toList(),
      );
    }

    try {
      final response = await _remote.getAllHalls(organizationId);

      await _local.cacheHalls(
        response.halls.map(HallModel.fromHallInfo).toList(),
      );

      return response;
    } on ApiErrorModel catch (error) {
      if (error.isNetworkError && cached != null) {
        return GetAllHallsResponse(
          halls: cached.halls.map((h) => h.toHallInfo()).toList(),
        );
      }
      rethrow;
    } catch (_) {
      if (cached != null) {
        return GetAllHallsResponse(
          halls: cached.halls.map((h) => h.toHallInfo()).toList(),
        );
      }
      rethrow;
    }
  }

  // ─── Sections ────────────────────────────────────────────

  Future<GetAllSectionsResponse> getSections(int organizationId) async {
    final cached = await _local.getCachedSections();

    if (cached != null && !cached.shouldRefresh()) {
      return GetAllSectionsResponse(
        sections: cached.sections.map((s) => s.toSectionInfo()).toList(),
      );
    }

    try {
      final response = await _remote.getAllSections(organizationId);

      await _local.cacheSections(
        response.sections.map(SectionModel.fromSectionInfo).toList(),
      );

      return response;
    } on ApiErrorModel catch (error) {
      if (error.isNetworkError && cached != null) {
        return GetAllSectionsResponse(
          sections: cached.sections.map((s) => s.toSectionInfo()).toList(),
        );
      }
      rethrow;
    } catch (_) {
      if (cached != null) {
        return GetAllSectionsResponse(
          sections: cached.sections.map((s) => s.toSectionInfo()).toList(),
        );
      }
      rethrow;
    }
  }
}