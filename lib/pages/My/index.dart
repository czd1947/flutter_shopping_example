import 'package:flu_web_pro01/api/home.dart';
import 'package:flu_web_pro01/components/Home/HmMoreList.dart';
import 'package:flu_web_pro01/components/Main/HmGuess.dart';
import 'package:flu_web_pro01/stores/TokenManager.dart';
import 'package:flu_web_pro01/stores/UserController.dart';
import 'package:flu_web_pro01/viewmodels/home.dart';
import 'package:flu_web_pro01/viewmodels/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyView extends StatefulWidget {
  MyView({Key? key}) : super(key: key);

  @override
  _MyViewState createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  // 引入用户控制器 , 初期可为空
  UsersController? _usersController;

  List<RecommendGoodsItem> _guessLikeList = [];
  final Map<String, dynamic> _guessLikeParams = {"page": 1, "pageSize": 10};
  // 加载状态
  bool _loading = false; // 是否正在加载数据
  // 是否还有更多
  bool _hasMore = true;
  // ScrollController 用于监听滚动事件
  final ScrollController _scrollController = ScrollController();
  // 添加一个监听滚动事件的方法
  void _registerScrollListenerEvent() {
    // _scrollController.position.maxScrollExtent 是滚动到底部的最大距离
    // _scrollController.position.pixels 是当前滚动的距离
    _scrollController.addListener(() {
      // 当滚动到距离底部 50 像素时，加载更多数据
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        // print("滚动到距离底部 50 像素时，加载更多数据");

        // 加载更多数据
        if (!_hasMore) return;
        _guessLikeParams["page"]++;
        _getGuessLikeList();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // 尝试获取控制器，如果不存在则创建并注册
    try {
      _usersController = Get.find<UsersController>();
    } catch (e) {
      print("Controller not found, creating new instance");
      _usersController = Get.put(UsersController());
    }

    // 调用猜你喜欢商品数据接口
    _getGuessLikeList();

    // 注册滚动事件监听
    _registerScrollListenerEvent();
  }

  // 获取猜你喜欢商品数据
  Future<void> _getGuessLikeList() async {
    // 如果正在加载数据或者没有更多数据，直接返回
    // print("_loading: $_loading");
    // print("_hasMore: $_hasMore");
    if (_loading || !_hasMore) {
      return;
    }
    // 站住位置
    _loading = true;

    // 调用接口
    RecommendDetailGoodsItem res = await getGuessLikeListAPI(_guessLikeParams);
    _loading = false;

    _guessLikeList.addAll(res.items);
    // 更新状态
    setState(() {});

    // 判断是否还有下一页
    _hasMore = res.pages > _guessLikeParams["page"];
    // 如果没有更多数据，设置为 false
    if (!_hasMore) return;
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(15),
      height: 140,
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        // 实现背景渐变色
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(222, 184, 135, 1.00),
            Color.fromRGBO(255, 235, 205, 1.00),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // 使用 Obx
          Obx(() {
            final user =
                _usersController?.user.value ?? UserModel.fromJSON({}); // 默认值

            // 左侧图像
            return CircleAvatar(
              radius: 26,
              backgroundImage: user.avatar != ''
                  ? NetworkImage(user.avatar)
                  : AssetImage("lib/assets/images/my_avatardefault.png")
                        as ImageProvider<Object>?,
            );
          }),
          // 增加一个 SizedBox 组件，用于分隔 图像和文字
          SizedBox(width: 10),
          // 同样使用 Obx 包裹需要使用到 共享数据的内容
          Obx(() {
            final user =
                _usersController?.user.value ?? UserModel.fromJSON({}); // 默认值

            return // 右侧立即登录
            GestureDetector(
              onTap: () {
                if (user.id == '') {
                  // 跳转到登录页面
                  Navigator.pushNamed(context, '/login');
                }
              },
              child: Text(
                user.id == '' ? "立即登录" : user.id,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          }),
          // 占用其他位置
          Expanded(child: Text("")),

          // 右侧 退出登录
          Obx(() {
            final user =
                _usersController?.user.value ?? UserModel.fromJSON({}); // 默认值

            return // 右侧 退出登录
            GestureDetector(
              onTap: () async {
                if (user.id == '') {
                  // 未登录，直接返回
                  return;
                }

                // 使用 ShowDialog 组件
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("提示"),
                    content: Text("确认退出登录吗？"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("取消"),
                      ),
                      TextButton(
                        onPressed: () async {
                          // 1. 调用退出登录接口
                          await TokenManager().removeToken();
                          // 2. 更新用户信息到全局状态管理
                          _usersController?.updateUser(UserModel.fromJSON({}));
                          // 3. 关闭弹窗
                          Navigator.pop(context);
                        },
                        child: Text("确认"),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                user.id == '' ? "" : "退出登录",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOpenVip() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        // height: 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 150, 122, 1.00),
          // 实现上左和上右 的圆角
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 升级vip图标 + 升级的文字
            Row(
              children: [
                // 升级vip图标
                Image.asset(
                  "lib/assets/images/my_vip.png",
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 5),
                // 升级的文字
                Text(
                  "升级美好商城会员，尊享无限免邮",
                  style: TextStyle(
                    color: Color.fromRGBO(165, 42, 42, 1.00),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            // 立刻开通的按钮
            TextButton(
              onPressed: () {
                // 跳转到升级vip页面
                Navigator.pushNamed(context, '/upgrade_vip');
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromRGBO(165, 42, 42, 1.00),
              ),
              child: Text(
                "立刻开通",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherMenu() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 我的收藏
            Column(
              children: [
                // 收藏图标
                Image.asset(
                  "lib/assets/images/my_favoritesstaroutline.png",
                  width: 30,
                  height: 30,
                ),
                SizedBox(height: 5),
                // 收藏的文字
                Text(
                  "我的收藏",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            // 我的足迹
            Column(
              children: [
                // 足迹图标
                Image.asset(
                  "lib/assets/images/my_search.png",
                  width: 30,
                  height: 30,
                ),
                // 足迹的文字
                Text(
                  "我的足迹",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
            // 我的客服
            Column(
              children: [
                // 客服图标
                Image.asset(
                  "lib/assets/images/my_chat.png",
                  width: 30,
                  height: 30,
                ),
                // 客服的文字
                Text(
                  "我的客服",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderMeu() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 我的订单 文字
            Text("我的订单", style: TextStyle(color: Colors.black, fontSize: 16)),
            SizedBox(height: 10),
            // 订单分类：使用Flex 布局，上面是图标下面是文字，分别是 全部订单，待付款，待发货，待收货，待评价
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 全部订单
                Column(
                  children: [
                    // 全部订单图标
                    Image.asset(
                      "lib/assets/images/my_all.png",
                      width: 30,
                      height: 30,
                    ),
                    // 全部订单的文字
                    Text(
                      "全部订单",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
                // 待付款
                Column(
                  children: [
                    // 待付款图标
                    Image.asset(
                      "lib/assets/images/my_dfk.png",
                      width: 30,
                      height: 30,
                    ),
                    // 待付款的文字
                    Text(
                      "待付款",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
                // 待发货
                Column(
                  children: [
                    // 待发货图标
                    Image.asset(
                      "lib/assets/images/my_dfh.png",
                      width: 30,
                      height: 30,
                    ),
                    // 待发货的文字
                    Text(
                      "待发货",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
                // 待收货
                Column(
                  children: [
                    // 待收货图标
                    Image.asset(
                      "lib/assets/images/my_dsh.png",
                      width: 30,
                      height: 30,
                    ),
                    // 待收货的文字
                    Text(
                      "待收货",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
                // 待评价
                Column(
                  children: [
                    // 待评价图标
                    Image.asset(
                      "lib/assets/images/my_chat.png",
                      width: 30,
                      height: 30,
                    ),
                    // 待评价的文字
                    Text(
                      "待评价",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(245, 245, 220, 1.00),
      child: CustomScrollView(
        controller: _scrollController, // 添加滚动控制器
        slivers: [
          // 我的页面顶部头像, 使用Row 布局，左侧图像，右侧立即登录
          SliverToBoxAdapter(child: _buildHeader()),
          // Column 组件， 上面部分使用 Row组件，左侧 又分 升级vip图标+升级的文字，右侧是 立刻开通的按钮
          SliverToBoxAdapter(child: _buildOpenVip()),
          // Row 组件，分别是 我的收藏，我的足迹，我的客服， 每个都是上面是图片，下面是文字的排版
          SliverToBoxAdapter(child: _buildOtherMenu()),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          // 我的订单
          SliverToBoxAdapter(child: _buildOrderMeu()),

          SliverToBoxAdapter(child: SizedBox(height: 10)),
          // 猜你喜欢标题 使用 SliverPersistentHeader
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "猜你喜欢",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          // 猜你喜欢商品列表
          HmMoreList(recommendList: _guessLikeList, horizontalPadding: 15),
        ],
      ),
    );
  }
}
