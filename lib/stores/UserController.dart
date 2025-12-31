import 'package:get/get.dart';
import 'package:flu_web_pro01/viewmodels/user.dart';

// 需要共享的对象，要有一些共享的属性，属性需要响应式更新
class UsersController extends GetxController {
  // 定义一个变量，用于存储用户信息
  // 说明，var 可以替换为 Rx<UserModel>
  var user = UserModel.fromJSON({}).obs; // user对象被监听了
  // 想要取值的话，需要 user.value

  // 定义一个方法，用于更新用户信息
  void updateUser(UserModel newUser) {
    user.value = newUser;
    print("更新后的用户信息：${user.value}");
  }
}
