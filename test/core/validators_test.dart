import 'package:clothing_store/core/constants/dummy_credentials.dart';
import 'package:clothing_store/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login Validation Unit Tests', () {
    test('isValidEmail returns true for properly formatted email addresses', () {
      expect(Validators.isValidEmail('karthik@clothing.com'), isTrue);
      expect(Validators.isValidEmail('user.name+tag@domain.co'), isTrue);
      expect(Validators.isValidEmail('dev_test12@store.org'), isTrue);
    });

    test('isValidEmail returns false for invalid email formats', () {
      expect(Validators.isValidEmail('plainaddress'), isFalse);
      expect(Validators.isValidEmail('@missingusername.com'), isFalse);
      expect(Validators.isValidEmail('username@.com'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
      expect(Validators.isValidEmail(null), isFalse);
    });

    test('isValidPassword validates min 6 character length requirement', () {
      expect(Validators.isValidPassword('123456'), isTrue);
      expect(Validators.isValidPassword('password123'), isTrue);
      expect(Validators.isValidPassword('12345'), isFalse);
      expect(Validators.isValidPassword(''), isFalse);
      expect(Validators.isValidPassword(null), isFalse);
    });

    test('DummyCredentials verifies predefined candidate credentials', () {
      expect(
        DummyCredentials.isValid('karthik@clothing.com', 'password123'),
        isTrue,
      );
      expect(
        DummyCredentials.isValid('user@example.com', 'admin123'),
        isTrue,
      );
      expect(
        DummyCredentials.isValid('karthik@clothing.com', 'wrongpassword'),
        isFalse,
      );
      expect(
        DummyCredentials.isValid('unknown@user.com', 'password123'),
        isFalse,
      );
    });
  });
}
