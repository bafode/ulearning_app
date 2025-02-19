import '../api/user_api.dart';
import '../entities/user/user.dart';

class UserRepository {
  final UserApi _userApi;

  UserRepository(this._userApi);

  Future<User?> toggleUserFollow(String followId) async {
    try {
      final response = await _userApi.toggleUserFollow(followId);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
