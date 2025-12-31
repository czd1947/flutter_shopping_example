import 'package:flutter/material.dart';

class ToastUtils {
  // 使用单例模式管理状态
  static final ToastUtils _instance = ToastUtils._internal();
  factory ToastUtils() => _instance;
  ToastUtils._internal();

  // 存储当前显示的时间戳，避免重复显示
  static DateTime? _lastShowTime;
  static const Duration _minInterval = Duration(milliseconds: 500); // 最小间隔
  static const Duration _maxDuration = Duration(seconds: 3);

  static void show(
    BuildContext context,
    String msg, {
    Duration? duration,
    bool showLonger = false,
  }) {
    final now = DateTime.now();

    // 检查是否在最小间隔内
    if (_lastShowTime != null &&
        now.difference(_lastShowTime!) < _minInterval) {
      return;
    }

    _lastShowTime = now;

    // 清除之前的 SnackBar
    ScaffoldMessenger.of(context).clearSnackBars();

    final displayDuration =
        duration ?? (showLonger ? Duration(seconds: 5) : _maxDuration);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 120,
        behavior: SnackBarBehavior.floating,
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        duration: displayDuration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // 添加背景色
        backgroundColor: Colors.black87,
        // 添加边距，避免遮挡重要内容
        // margin: EdgeInsets.only(
        //   bottom: MediaQuery.of(context).size.height * 0.1,
        // ),
      ),
    );

    // 自动重置状态
    Future.delayed(displayDuration + _minInterval, () {
      _lastShowTime = null;
    });
  }

  // 成功提示
  static void success(BuildContext context, String msg) {
    show(
      context,
      msg,
      // 可以添加成功图标等
    );
  }

  // 错误提示
  static void error(BuildContext context, String msg) {
    show(
      context,
      msg,
      duration: Duration(seconds: 4), // 错误提示稍长
    );
  }

  // 警告提示
  static void warning(BuildContext context, String msg) {
    show(context, msg);
  }

  // 关闭所有提示
  static void dismiss(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    _lastShowTime = null;
  }
}
