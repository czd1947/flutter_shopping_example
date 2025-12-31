import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context, {String? message = "加载中..."}) {
    showDialog(
      context: context,
      // 点击弹窗外部是否可以关闭弹窗
      barrierDismissible: false,
      // builder 用于构建弹窗的内容
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            // 主轴方向上的大小为最小
            mainAxisSize: MainAxisSize.min,
            children: [
              // 转圈的组件
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text(message ?? "加载中..."),
            ],
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
