import 'package:flutter/material.dart';

// 返回App根级组件
Widget getRootWidget() {
  return MaterialApp(
    routes: {},
    home: Scaffold(
      appBar: AppBar(title: const Text('Flutter Web Pro01')),
      body: const Center(child: Text('Hello Flutter Web Pro01!')),
    ),
  );
}

// 返回该App 的路由配置
Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {};
}
