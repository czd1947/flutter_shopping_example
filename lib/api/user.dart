// 登录接口
import 'package:flu_web_pro01/constants/index.dart';
import 'package:flu_web_pro01/utils/DioRequest.dart';
import 'package:flu_web_pro01/viewmodels/user.dart';

Future<UserModel> login({
  required String account,
  required String password,
}) async {
  return UserModel.fromJSON(
    await DioRequest().post(
      HttpConstants.LOGIN,
      data: {'account': account, 'password': password},
    ),
  );
}

// 获取用户信息
Future<UserModel> getUserInfo() async {
  return UserModel.fromJSON(await DioRequest().get(HttpConstants.USER_INFO));
}
