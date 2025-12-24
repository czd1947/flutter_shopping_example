import 'package:flu_web_pro01/pages/Login/index.dart';
import 'package:flu_web_pro01/pages/Main/index.dart';
import 'package:flutter/material.dart';

// 返回App根级组件
Widget getRootWidget() {
  return MaterialApp(initialRoute: '/', routes: getRootRoutes());
}

// 返回该App 的路由配置
Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {'/': (context) => MainPage(), '/login': (context) => LoginPage()};
}
