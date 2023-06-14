//  Login Exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//  Register Exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//  Generic Exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class ExpiredActionCodeAuthException implements Exception {}

class InvalidActionCodeAuthException implements Exception {}

class UserDisabledAuthException implements Exception {}

class MissingAndroidPkgNameAuthException implements Exception {}

class MissingContinueUriAuthException implements Exception {}

class MissingIOSBundleIDAuthException implements Exception {}

class InvalidContinueUriAuthException implements Exception {}

class UnauthorizedContinueUriAuthException implements Exception {}
