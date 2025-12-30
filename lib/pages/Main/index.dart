import 'package:flutter/material.dart';
import 'package:flu_web_pro01/pages/Cart/index.dart';
import 'package:flu_web_pro01/pages/Category/index.dart';
import 'package:flu_web_pro01/pages/Home/index.dart';
import 'package:flu_web_pro01/pages/My/index.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 当前选中的导航栏索引
  int _currentIndex = 0;

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
