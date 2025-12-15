import 'package:mobile_app/core/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/Data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/home/data/models/user_org_model.dart';
import 'package:mobile_app/feature/register/data/models/register_request_body.dart';
import 'package:mobile_app/feature/register/domain/repos/register_repo.dart';

class RegisterRepoImp implements RegisterRepo {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource localDataSource;
  
  RegisterRepoImp({
    required this.userRemoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<ApiResult<UserModel>> registerUser({
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  }) async {
    print('🟢 [RegisterRepoImp] registerUser() started');
    print('📧 Email: $email');
    print('🏢 OrgId: $orgId');
    
    try {
      // تحويل orgId من String إلى int
      final orgIdInt = int.tryParse(orgId);
      
      if (orgIdInt == null) {
        print('❌ [RegisterRepoImp] Invalid orgId - cannot parse to int');
        throw Exception('Invalid organization ID: $orgId');
      }
      
      print('🔄 [RegisterRepoImp] Converted orgId: "$orgId" → $orgIdInt');
      
      final request = RegisterRequestBody(
        organizationCode: orgIdInt,
        email: email,
        password: password,
      );
      
      print('📤 [RegisterRepoImp] Sending request to remote data source...');
      print('📦 Request body: ${request.toJson()}');
      
      final remoteUser = await userRemoteDataSource.getUser(request);
      
      print('📥 [RegisterRepoImp] Received remote user');
      print('📧 Remote user email: ${remoteUser.email}');
      print('🏢 Remote user organizations: ${remoteUser.organizations?.map((o) => o.toJson()).toList()}');
      
      // Merge local info if needed
      remoteUser.organizations ??= [];
      print('🔄 [RegisterRepoImp] Organizations initialized: ${remoteUser.organizations!.length} orgs');
      
      final newOrg = UserOrgModel(
        orgId: orgId, 
        role: remoteUser.organizations!.isEmpty ? 'User' : remoteUser.organizations!.first.role
      );
      
      print('➕ [RegisterRepoImp] Adding new organization: ${newOrg.toJson()}');
      remoteUser.organizations!.add(newOrg);
      
      print('🔄 [RegisterRepoImp] Updating email from "${remoteUser.email}" to "$email"');
      remoteUser.email = email;
      
      print('💾 [RegisterRepoImp] Saving user to local storage...');
      await localDataSource.saveUserLogin(remoteUser);
      print('✅ [RegisterRepoImp] User saved successfully');
      
      print('🎯 [RegisterRepoImp] Final user data: ${remoteUser.toJson()}');
      
      return ApiResult.success(remoteUser);
    } catch (e) {
      print('❌ [RegisterRepoImp] ERROR occurred');
      print('⚠️ Error type: ${e.runtimeType}');
      print('⚠️ Error message: ${e.toString()}');
      print('📍 Stack trace: ${StackTrace.current}');
      
      return ApiResult.error(e);
    }
  }
}