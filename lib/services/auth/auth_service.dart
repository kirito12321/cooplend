import 'package:ascoop/services/auth/auth_provider.dart';
import 'package:ascoop/services/auth/auth_user.dart';
import 'package:ascoop/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProbider());

  @override
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
  }) =>
      provider.createUser(
        email: email,
        password: password,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        gender: gender,
        mobileNo: mobileNo,
        birthDate: birthDate,
        currentAddress: currentAddress,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> changePassword(
          {required String code, required String newPassword}) =>
      provider.changePassword(code: code, newPassword: newPassword);

  @override
  Future<void> sendEmailPasswordResetCode({required String email}) =>
      provider.sendEmailPasswordResetCode(email: email);

  @override
  Future<void> checkActionCode({required String code}) =>
      provider.checkActionCode(code: code);
}
