import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/data/models/register_response_body.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {
  late AuthRemoteDataSource authRemoteDataSource;
  late MockNetworkService networkService;

  setUp(() {
    networkService = MockNetworkService();

    authRemoteDataSource = AuthRemoteDataSourceImpl(networkService);
  });

  test('Register will be success', () async {
    final request = RegisterRequestBody(
      organizationCode: 8882,
      email: "adel@gmail.com",
      password: "Test@1234",
    );

    final user = RegisterResponseBody(
      userResponse: UserResponse(
        id: "abcd-abcd-abcd",
        fullName: "Adel Saeed",
        userName: "dols",
        email: "adel@gmail.com",
        isUniversity: true,
        role: "Admin",
        createdAt: "2-2-2024",
        updatedAt: "2-2-2024",
      ),
      loginToken: "fasfasfasdfasdfsaf",
    );

    final response = Response(
      requestOptions: RequestOptions(path: ApiConst.register),
      statusCode: 200,
      data: {
        'data': {
          'userResponse': user.userResponse.toJson(),
          'loginToken': user.loginToken,
        },
      },
    );

    when(networkService.post(any, any)).thenAnswer((_) async => response);


    final result = await authRemoteDataSource.registerUser(request: request);

    expect(result.toJson(), {
      'userResponse': user.userResponse.toJson(),
      'loginToken': user.loginToken,
    });
  });
}
