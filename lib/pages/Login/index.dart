import 'package:dio/dio.dart';
import 'package:flu_web_pro01/api/user.dart';
import 'package:flu_web_pro01/stores/TokenManager.dart';
import 'package:flu_web_pro01/stores/UserController.dart';
import 'package:flu_web_pro01/utils/LoadingDialog.dart';
import 'package:flu_web_pro01/utils/ToastUtils.dart';
import 'package:flu_web_pro01/viewmodels/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // 登录表单
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 定义设置 共享用户数据的控制器
  final UsersController _usersController = Get.put(UsersController());

  // 登录头标题
  Widget _buildHeader() {
    return Container(
      child: Text(
        "账号密码登录",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }

  // 账号
  Widget _buildAccountField() {
    return TextFormField(
      // 账号输入框
      controller: _accountController,
      // 验证器
      validator: (String? value) {
        // 如果返回 null ，则表示验证通过，返回字符串则表示验证失败
        if (value == null || value.isEmpty) {
          return "请输入账号";
        }
        // 手机号正则表达式
        if (!RegExp(r"^1[3-9]\d{9}$").hasMatch(value)) {
          return "请输入正确的手机号";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "账号",
        hintText: "请输入账号",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // 密码
  Widget _buildPasswordField() {
    return TextFormField(
      // 密码输入框
      controller: _passwordController,
      // 验证器
      validator: (String? value) {
        // 如果返回 null ，则表示验证通过，返回字符串则表示验证失败
        if (value == null || value.isEmpty) {
          return "请输入密码";
        }
        // 密码长度不能小于6位
        if (value.length < 6) {
          return "密码长度不能小于6位";
        }
        // 密码长度不能大于20位
        if (value.length > 20) {
          return "密码长度不能大于20位";
        }
        // // 密码必须包含字母和数字
        // if (!RegExp(r"[a-zA-Z]").hasMatch(value)) {
        //   return "密码必须包含字母";
        // }
        // if (!RegExp(r"\d").hasMatch(value)) {
        //   return "密码必须包含数字";
        // }
        return null;
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "密码",
        hintText: "请输入密码",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // 同意协议
  Widget _buildAgreeCheckbox() {
    return Row(
      children: [
        Checkbox(
          // 圆角处理
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          value: _isChecked,
          onChanged: (bool? value) {
            _isChecked = value ?? false;
            setState(() {
              // 处理选中状态变化
            });
          },
        ),
        // 文字：查看并同意 隐私条款 和 用户协议 ， 其中 隐私条款和用户协议 为超链接
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "查看并同意 ",
                style: TextStyle(color: Colors.black),
              ),
              // 可点击链接
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    // 处理点击事件，例如打开隐私条款页面
                  },
                  child: Text("隐私条款", style: TextStyle(color: Colors.blue)),
                ),
              ),
              TextSpan(
                text: " 和 ",
                style: TextStyle(color: Colors.black),
              ),
              // 可点击链接
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    // 处理点击事件，例如打开用户协议页面
                  },
                  child: Text("用户协议", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 登录按钮
  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.black,
        ),
        onPressed: () async {
          // 登录逻辑
          if (_formKey.currentState?.validate() == true) {
            // 校验是否同意协议
            if (!_isChecked) {
              // 未同意协议，提示用户
              ToastUtils.show(context, "请先同意协议");
              return;
            }

            try {
              LoadingDialog.show(context, message: "正在努力登录中...");

              // 调用登录接口
              UserModel userInfo = await login(
                account: _accountController.text,
                password: _passwordController.text,
              );
              // print("用户信息：$userInfo");
              // 更新共享用户数据
              _usersController.updateUser(userInfo);
              // 持久化储存用户token数据 (会将token 存储到本地)
              TokenManager().setToken(userInfo.token);
              // 隐藏loading弹窗
              LoadingDialog.hide(context);

              // 登录成功，提示用户
              ToastUtils.show(context, "登录成功");
              Future.delayed(Duration(seconds: 2), () {
                // 登录成功后，跳转到首页
                Navigator.pushReplacementNamed(
                  context,
                  "/",
                  arguments: {"_currentIndex": 3},
                );
              });
            } catch (e) {
              // 隐藏loading弹窗
              LoadingDialog.hide(context);
              // 登录失败，提示用户
              ToastUtils.show(context, (e as DioException).message ?? "登录失败");
              return;
            }
          }
        },
        child: Text("登录", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "惠多美登录",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        // 登录表单
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(30),
          color: Colors.white,
          width: double.infinity,
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildHeader(),

              SizedBox(height: 30),
              // 账号
              _buildAccountField(),

              SizedBox(height: 20),
              // 密码
              _buildPasswordField(),

              // 左边单选框 ，右边是 查看并同意 隐私条款 和 用户协议 ， 其中 隐私条款和用户协议 为超链接
              SizedBox(height: 20),

              // 同意协议
              _buildAgreeCheckbox(),
              SizedBox(height: 20),

              // 登录按钮
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
