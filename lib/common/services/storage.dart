import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beehive/common/entities/auth/token/tokens.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/utils/constants.dart';

class StorageService {
  late final SharedPreferences _pref;

  Future<StorageService> init() async {
    _pref = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _pref.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _pref.setBool(key, value);
  }

  String getString(String key) {
    return _pref.getString(key) ?? "";
  }

  Future<bool> resetStorage() async {
    final isCleared = await _pref.clear();
    return isCleared;
  }

  bool getDeviceFirstOpen() {
    return _pref.getBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_KEY) ?? false;
  }

  bool getIsCallVocie() {
    return _pref.getBool(AppConstants.isCallVocie) ?? false;
  }

  bool isLoggedIn() {
    return _pref.getString(AppConstants.STORAGE_USER_PROFILE_KEY) != null
        ? true
        : false;
  }

  User getUserProfile() {
    var profile = _pref.getString(AppConstants.STORAGE_USER_PROFILE_KEY) ?? "";
    var profileJson = jsonDecode(profile);
    var userProfile = User.fromJson(profileJson);
    return userProfile;
  }

  Tokens? getTokens() {
    var tokensString = _pref.getString(AppConstants.STORAGE_USER_TOKEN_KEY);
    if (tokensString != null && tokensString.isNotEmpty) {
      var tokenJson = jsonDecode(tokensString);
      return Tokens.fromJson(tokenJson);
    } else {
      return null;
    }
  }
}
