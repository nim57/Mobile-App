/// Custom exceptions class to handle Firebase authentication-related errors.
class EException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructs that taken an error code.
  EException(this.code);

  /// Get the corresponding error message base on the error code.
  String get message {
    switch (code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-not-found':
        return 'There is no user record corresponding to this identifier. The user may have been deleted.';
      case 'wrong-password':
        return 'The password is invalid or the user does not have a password.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'The password must be 6 characters long or more.';
      case 'too-many-requests':
        return 'We have blocked all requests from this device due to unusual activity. Try again later.';
      case 'operation-not-allowed':
        return 'Password sign-in is disabled for this project.';
      case 'network-request-failed':
        return 'A network error (such as timeout, interrupted connection, or unreachable host) has occurred.';
      default:
        return 'An error occurred while processing the request.';
    }
  }
}
