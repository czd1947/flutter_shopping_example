import 'package:flu_web_pro01/constants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  String _token = ""; //内存中的token

  Future<SharedPreferences> _getSharedInstance() {
    return SharedPreferences.getInstance();
  }

  // 初始化 token
  Future<void> init() async {
    final SharedPreferences prefs = await _getSharedInstance();
    _token = prefs.getString(GlobalConstants.TOKEN_KEY) ?? "";
  }

  Future<void> setToken(String token) async {
    // 1. 获取持久化实例
    final SharedPreferences prefs = await _getSharedInstance();
    // 2. 持久化存储 token
    await prefs.setString(GlobalConstants.TOKEN_KEY, token);
    // 3. 更新内存中的 token
    _token = token;
  }

  Future<String> getToken() async {
    // 1. 初始化 token
    await init();
    // 2. 返回 token
    return _token;
  }

  Future<void> removeToken() async {
    // 1. 获取持久化实例
    final SharedPreferences prefs = await _getSharedInstance();
    await prefs.remove(GlobalConstants.TOKEN_KEY);
    _token = "";
  }
}
