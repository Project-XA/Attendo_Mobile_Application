
import 'package:mobile_app/core/current_user/data/models/user_model.dart';
import 'package:mobile_app/core/current_user/data/models/user_org_model.dart';
import 'package:mobile_app/features/auth/data/models/register_response_body.dart';

class UserModelMapper {
  UserModelMapper._();

  static UserModel fromRegistration({
    required RegisterResponseBody apiResponse,
    required UserModel localUserData,
  }) {
    final nameParts = apiResponse.userResponse.fullName.split(' ');

    return UserModel(
      isUniversity: apiResponse.userResponse.isUniversity,
      id: apiResponse.userResponse.id,
      email: apiResponse.userResponse.email,
      username: apiResponse.userResponse.username,
      fullName: apiResponse.userResponse.fullName,
      profileImage: localUserData.profileImage,
      organizations: [
        UserOrgModel(
          organizationId: apiResponse.userResponse.organizationId!,
          role: apiResponse.userResponse.role,
          organizationName: apiResponse.userResponse.organizationName,
        ),
      ],
    );
  }
}