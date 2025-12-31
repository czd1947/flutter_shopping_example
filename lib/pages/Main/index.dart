import 'package:flu_web_pro01/api/user.dart';
import 'package:flu_web_pro01/stores/TokenManager.dart';
import 'package:flu_web_pro01/stores/UserController.dart';
import 'package:flu_web_pro01/viewmodels/user.dart';
import 'package:flutter/material.dart';
import 'package:flu_web_pro01/pages/Cart/index.dart';
import 'package:flu_web_pro01/pages/Category/index.dart';
import 'package:flu_web_pro01/pages/Home/index.dart';
import 'package:flu_web_pro01/pages/My/index.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 当前选中的导航栏索引
  int _currentIndex = 0;

  // 初始化状态的时候 获取请求参数
  @override
  void initState() {
    super.initState();

    // 在异步任务中 获取请求参数
    Future.microtask(() {
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      // 如果有参数，更新当前选中的导航栏索引
      if (args != null && args.containsKey("_currentIndex")) {
        setState(() {
          _currentIndex = args["_currentIndex"];
        });
      }
    });

    // 初始化用户信息
    _initUserInfo();
  }

  final UsersController usersController = Get.put(UsersController());
  Future<void> _initUserInfo() async {
    String token = await TokenManager().getToken();

    // 1. 判断Token 是否存在
    if (token != '') {
      // 2. 获取用户信息
      final UserModel userInfo = await getUserInfo();
      // 3. 更新用户信息到全局状态管理
      usersController.updateUser(userInfo);
    }
  }

  // 应用程序导航栏数据
  final List<Map<String, String>> _tabList = [
    {
      "icon": "lib/assets/images/tabbar_index.png",
      "active_icon": "lib/assets/images/tabbar_index_active.png",
      "title": "首页",
    },
    {
      "icon": "lib/assets/images/tabbar_category.png",
      "active_icon": "lib/assets/images/tabbar_category_active.png",
      "title": "分类",
    },
    {
      "icon": "lib/assets/images/tabbar_cart.png",
      "active_icon": "lib/assets/images/tabbar_cart_active.png",
      "title": "购物车",
    },
    {
      "icon": "lib/assets/images/tabbar_my.png",
      "active_icon": "lib/assets/images/tabbar_my_active.png",
      "title": "我的",
    },
  ];

  // 获取应用程序导航栏组件 (根据 BottomNavigationBar.items 的类型创建)
  List<BottomNavigationBarItem> _getTabBarWidget() {
    return List.generate(_tabList.length, (index) {
      return BottomNavigationBarItem(
        // 正常显示图标
        icon: Image.asset(_tabList[index]["icon"]!, width: 30, height: 30),
        // 选中时显示图标
        activeIcon: Image.asset(
          _tabList[index]["active_icon"]!,
          width: 30,
          height: 30,
        ),
        // 导航栏文字
        label: _tabList[index]["title"]!,
      );
    });
  }

  // 获取应用程序导航栏子组件
  // navTab
  List<Widget> _getChildren() {
    return [HomeView(), CategoryView(), CartView(), MyView()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea 避开安全区的组件
      body: SafeArea(
        // IndexedStack 堆叠组件，根据索引显示对应组件
        child: IndexedStack(
          // 索引栈，根据索引显示对应的子组件
          index: _currentIndex,
          // 子组件列表
          children: _getChildren(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 当前选中的导航栏索引
        currentIndex: _currentIndex,
        // 导航栏点击事件
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // 显示未选中的导航栏文字
        showUnselectedLabels: true,
        // 导航栏选中时的颜色
        selectedItemColor: Colors.black,
        // 导航栏未选中时的颜色
        unselectedItemColor: Colors.black,
        items: _getTabBarWidget(),
      ),
    );
  }
}
