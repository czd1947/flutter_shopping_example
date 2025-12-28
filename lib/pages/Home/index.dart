import 'package:flu_web_pro01/api/home.dart';
import 'package:flu_web_pro01/components/Home/HmMoreList.dart';
import 'package:flu_web_pro01/utils/ToastUtils.dart';
import 'package:flutter/material.dart';
import 'package:flu_web_pro01/components/Home/HmSlider.dart';
import 'package:flu_web_pro01/components/Home/HmCategory.dart';
import 'package:flu_web_pro01/components/Home/HmSuggestion.dart';
import 'package:flu_web_pro01/components/Home/HmHot.dart';
import 'package:flu_web_pro01/viewmodels/home.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<BannerItem> _banners = [];
  List<CategoryItem> _categoryList = [];
  SpecialOfferDataResult _specialOfferModel = SpecialOfferDataResult(
    id: '',
    title: '',
    subTypes: [],
  );

  // 爆款推荐数据
  SpecialOfferDataResult _invogueModel = SpecialOfferDataResult(
    id: '',
    title: '',
    subTypes: [],
  );

  // 一站全买数据
  SpecialOfferDataResult _oneStopModel = SpecialOfferDataResult(
    id: '',
    title: '',
    subTypes: [],
  );

  // 推荐商品数据
  List<RecommendGoodsItem> _recommendList = [];
  // 当前页码
  int _currentPage = 1;
  // 每页加载数量
  int _pageSize = 10;
  // 加载状态
  bool _loading = false; // 是否正在加载数据
  // 是否还有更多
  bool _hasMore = true;

  // 初始化推荐商品数据
  Future<void> _initRecommendList() async {
    // 如果正在加载数据或者没有更多数据，直接返回
    // print("_loading: $_loading");
    // print("_hasMore: $_hasMore");
    if (_loading || !_hasMore) {
      return;
    }
    // 站住位置
    _loading = true;
    // 计算请求的数量
    int requestLimit = _pageSize * _currentPage;
    // 初始化推荐商品数据
    _recommendList = await getRecommendListAPI({"limit": requestLimit});
    _loading = false;

    // 判断是否还有下一页
    _hasMore = _recommendList.length >= requestLimit;
    // 如果没有更多数据，设置为 false
    if (!_hasMore) return;
    _currentPage++;
  }

  // 初始化分类数据
  Future<void> _initCategoryList() async {
    // 初始化分类数据
    _categoryList = await getCategoryListAPI();
  }

  // 初始化轮播图数据
  Future<void> _initBannerList() async {
    // 初始化轮播图数据
    _banners = await getBannerListAPI();
  }

  // 初始化热门商品数据
  Future<void> _initHotProductList() async {
    // 初始化热门商品数据
    _specialOfferModel = await getSpecialOfferListAPI();
  }

  // 初始化爆款推荐数据
  Future<void> _initInvogueList() async {
    // 初始化爆款推荐数据
    _invogueModel = await getInvogueListAPI();
  }

  // 初始化一站全买数据
  Future<void> _initOneStopList() async {
    // 初始化一站全买数据
    _oneStopModel = await getOneStopListAPI();
  }

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
        _initRecommendList();
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // 注册滚动事件监听
    _registerScrollListenerEvent();

    // initState ->  build -> 下拉刷新组件 -> 才可以操作它
    // Future.microtask 是在微任务队列中执行，确保在下拉刷新组件构建完成后执行
    Future.microtask(() {
      _refreshIndicatorHeight = 100;
      // 必须要调用 setState 方法，才能触发刷新组件的高度更新
      setState(() {});

      // 直接调用下拉刷新方法
      _refreshIndicatorKey.currentState?.show();
    });

    /*
    // 初始化轮播图数据
    _initBannerList();

    // 初始化分类数据
    _initCategoryList();

    // 初始化热门商品数据
    _initHotProductList();

    // 初始化爆款推荐数据
    _initInvogueList();

    // 初始化一站全买数据
    _initOneStopList();

    // 初始化推荐商品数据
    _initRecommendList();
*/
  }

  // 封装 CustomScrollView 的 sliver 家族的组件
  List<Widget> _getScrollChildren() {
    return [
      // 包裹普通widget的 sliver 家族的组件
      SliverToBoxAdapter(child: HmSlider(banners: _banners)), // 轮播图组件
      SliverToBoxAdapter(child: SizedBox(height: 10)), // 占位分隔
      // SliverGrid 和 SliverList 只能纵向滚动，不能横向滚动， 所以这里用 SliverToBoxAdapter 包裹
      SliverToBoxAdapter(
        child: HmCategory(categoryList: _categoryList),
      ), // 分类组件
      SliverToBoxAdapter(child: SizedBox(height: 10)), // 占位分隔

      SliverToBoxAdapter(
        child: HmSuggestion(specialOfferDataResult: _specialOfferModel),
      ), // 优惠推荐组件
      SliverToBoxAdapter(child: SizedBox(height: 10)), // 占位分隔
      // 热门组件, 左右各显示一个
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1,
                child: HmHot(
                  specialOfferDataResult: _specialOfferModel,
                  type: 'hot',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: HmHot(
                  specialOfferDataResult: _invogueModel,
                  type: 'invogue',
                ),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)), // 占位分隔
      // 无限滚动
      HmMoreList(recommendList: _recommendList),

      SliverToBoxAdapter(child: SizedBox(height: 20)), // 占位分隔
    ];
  }

  // 下拉刷新的异步方法
  Future<void> _onRefresh() async {
    // 重置 推荐商品数据 参数
    _currentPage = 1;
    _loading = false;
    _hasMore = true;
    _recommendList.clear();

    await _initBannerList(); // 初始化轮播图数据
    await _initCategoryList(); // 初始化分类数据
    await _initHotProductList(); // 初始化热门商品数据
    await _initInvogueList(); // 初始化爆款推荐数据
    await _initOneStopList(); // 初始化一站全买数据
    await _initRecommendList(); // 初始化推荐商品数据

    // 等上面的请求都成功后，显示弹窗
    ToastUtils.show(context, "刷新成功啦啦");

    // 初始化完成后，将下拉刷新组件的高度设置为 0
    _refreshIndicatorHeight = 0;
    setState(() {});
  }

  // GlobalKey 是一个方法， 可以创建一个全局的 Key 绑定到 Widget部件上，可以操作Widget部件
  // RefreshIndicatorState 是 RefreshIndicator 组件的状态类， 可以调用其方法
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  double _refreshIndicatorHeight = 0; // 下拉刷新组件的高度， 初始值为0
  @override
  Widget build(BuildContext context) {
    // 使用 RefreshIndicator 包裹 CustomScrollView 实现下拉刷新
    return RefreshIndicator(
      key: _refreshIndicatorKey, // 绑定 RefreshIndicator 组件的 Key
      onRefresh: _onRefresh,
      // 增加下拉刷新自定义动画
      child: AnimatedContainer(
        // 先自定义 padding， 在初始化的时候设置为 100， 在初始化完成后再设置为 0
        padding: EdgeInsets.only(top: _refreshIndicatorHeight),
        duration: Duration(milliseconds: 300),
        child: CustomScrollView(
          controller: _scrollController, // 绑定滚动控制器
          slivers: _getScrollChildren(),
        ),
      ),
    );
  }
}
