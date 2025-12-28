import 'package:flutter/material.dart';

class ToastUtils {
  static void show(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 120, // 宽度,必须配置 behavior: SnackBarBehavior.floating 才能生效
        behavior: SnackBarBehavior.floating, // 浮动模式
        content: Text(msg, textAlign: TextAlign.center),
        duration: Duration(seconds: 3), // 显示时间
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(40), // 圆角形状
        ), // 圆角
      ),
    );
  }
}
