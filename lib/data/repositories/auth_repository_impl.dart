import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final user = await localDataSource.login(email, password);
      return user;
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw const AuthFailure('Authentication failed. Please verify credentials.');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await localDataSource.getCurrentUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}
