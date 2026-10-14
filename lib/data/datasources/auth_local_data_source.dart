import '../../core/constants/dummy_credentials.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  UserModel? _currentUser;

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate brief network/storage delay
    await Future.delayed(const Duration(milliseconds: 400));

    if (DummyCredentials.isValid(email, password)) {
      final user = UserModel(
        id: 'usr_001',
        email: email.trim().toLowerCase(),
        name: 'Karthik Maddodi',
      );
      _currentUser = user;
      return user;
    } else {
      throw const AuthException('Invalid email or password combination.');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}
