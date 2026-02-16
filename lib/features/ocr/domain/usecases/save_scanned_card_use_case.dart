import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/features/ocr/domain/entities/extracted_id_card_data.dart';

class SaveScannedCardUseCase {
  final UserLocalDataSource _dataSource;
  SaveScannedCardUseCase(this._dataSource);

  Future<void> execute(ExtractedIdCardData data) async {  // ✅ typed بدل Map
    final userModel = UserModel(
      nationalId: data.nationalId?.isNotEmpty == true
          ? data.nationalId!
          : 'UNKNOWN_${DateTime.now().millisecondsSinceEpoch}',
      firstNameAr: data.firstName,
      lastNameAr: data.lastName,
      address: data.address ?? 'Helwan',
      birthDate: data.birthDate ?? '0102/21',
      idCardImage: data.photoPath,
      email: null,
      firstNameEn: null,
      lastNameEn: null,
      organizations: null,
      profileImage: null,
    );
    await _dataSource.saveLocalUserData(userModel);
  }
}