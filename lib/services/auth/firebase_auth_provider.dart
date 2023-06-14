import 'package:ascoop/firebase_options.dart';
import 'package:ascoop/services/auth/auth_user.dart';
import 'package:ascoop/services/auth/auth_provider.dart';
import 'package:ascoop/services/auth/auth_exception.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_user.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthProbider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email,
      required String password,
      required String firstName,
      required String middleName,
      required String lastName,
      required String gender,
      required String mobileNo,
      required DateTime birthDate,
      required String currentAddress}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = currentUser;

      if (user != null) {
        final userInfo = UserInfo(
          userUID: (FirebaseAuth.instance.currentUser!.uid),
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          gender: gender,
          email: email,
          mobileNo: mobileNo,
          birthDate: birthDate,
          currentAddress: currentAddress,
        );
        DataService.database().createUser(user: userInfo);
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification;
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> changePassword(
      {required String code, required String newPassword}) async {
    try {
      FirebaseAuth.instance
          .confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'expired-action-code') {
        throw ExpiredActionCodeAuthException();
      } else if (e.code == 'invalid-action-code') {
        throw InvalidActionCodeAuthException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledAuthException();
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailPasswordResetCode({required String email}) async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'auth/missing-android-pkg-name') {
        throw MissingAndroidPkgNameAuthException();
      } else if (e.code == 'auth/missing-continue-uri') {
        throw MissingContinueUriAuthException();
      } else if (e.code == 'auth/missing-ios-bundle-id') {
        throw MissingIOSBundleIDAuthException();
      } else if (e.code == 'auth/invalid-continue-uri') {
        throw InvalidContinueUriAuthException();
      } else if (e.code == 'auth/unauthorized-continue-uri') {
        throw UnauthorizedContinueUriAuthException();
      } else if (e.code == 'auth/user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      print(e.toString());
      throw GenericAuthException();
    }
  }

  @override
  Future<void> checkActionCode({required String code}) async {
    // TODO: implement checkActionCode
    try {
      FirebaseAuth.instance.checkActionCode(code);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'expired-action-code') {
        throw ExpiredActionCodeAuthException();
      } else if (e.code == 'invalid-action-code') {
        throw InvalidActionCodeAuthException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledAuthException();
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }
}
