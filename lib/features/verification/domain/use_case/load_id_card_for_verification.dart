import 'package:mobile_app/features/verification/domain/repo/verify_repo.dart';

class LoadIdCardForVerification{
  final VerifyRepo verifyRepo;
  LoadIdCardForVerification({required this.verifyRepo});

  Future<String> call() async {
    return await verifyRepo.getIdCardImagePath();
  }


}