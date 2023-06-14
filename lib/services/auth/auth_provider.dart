import 'package:ascoop/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;

  Future<AuthUser> login({required String email, required String password});

  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String firstName,
    required String middleName,
    required String lastName,
    required String gender,
    required String mobileNo,
    required DateTime birthDate,
    required String currentAddress,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> sendEmailPasswordResetCode({required String email});

  Future<void> changePassword(
      {required String code, required String newPassword});

  Future<void> checkActionCode({required String code});
}
