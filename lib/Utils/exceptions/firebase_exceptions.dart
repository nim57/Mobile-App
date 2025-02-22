/// Custom exceptions class to handle Firebase authentication-related errors.
class EFirebaseException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructs that taken an error code.
  EFirebaseException(this.code);

  /// Get the corresponding error message base on the error code.
  String get message {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'The password is invalid.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials.';
      case 'invalid-credential':
        return 'The credential is invalid or expired.';
      case 'invalid-email-verified':
        return 'The email address is not verified.';
      case 'invalid-phone-number':
        return 'The phone number is not valid.';
      case 'missing-phone-number':
        return 'The phone number is missing.';
      case 'quota-exceeded':
        return 'The SMS quota for this project has been exceeded.';
      case 'session-expired':
        return 'The SMS code has expired.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.';
      case 'provider-already-linked':
        return 'This provider is already linked to this account.';
      case 'no-such-provider':
        return 'This provider is not linked to this account.';
      case 'invalid-user-token':
        return 'The user\'s credential is no longer valid. The user must sign in again.';
      case 'network-request-failed':
        return 'A network error occurred. Please try again.';
      default:
        return 'An unknown error occurred.';
    }
  }
}
