class DummyCredentials {
  DummyCredentials._();

  static const String validEmail = 'karthik@clothing.com';
  static const String validPassword = 'password123';

  // Secondary demo account for convenience
  static const String secondaryEmail = 'user@example.com';
  static const String secondaryPassword = 'admin123';

  static bool isValid(String email, String password) {
    final cleanEmail = email.trim().toLowerCase();
    return (cleanEmail == validEmail && password == validPassword) ||
        (cleanEmail == secondaryEmail && password == secondaryPassword);
  }
}
