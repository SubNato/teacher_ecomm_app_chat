import 'dart:convert';

import 'package:learn_teacher_bloc/common/values/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_teacher_bloc/common/entities/entities.dart';

class StorageService {
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  List<String> getList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  String getUserToken() {
    return _prefs.getString(AppConstants.STORAGE_USER_TOKEN_KEY) ?? "";
  }
  bool getDeviceFirstOpen() {
    return _prefs.getBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME) ?? false;
  }
  bool getIsLogin() {
    return _prefs.getString(AppConstants.STORAGE_USER_TOKEN_KEY)==null?false:true;
  }
  UserItem getUserProfile() {
    var profileOffline = _prefs.getString(AppConstants.STORAGE_USER_PROFILE_KEY)??"";
    if(profileOffline.isNotEmpty) {
      return UserItem.fromJson(jsonDecode(profileOffline));
    }
    return UserItem();
  }



}
