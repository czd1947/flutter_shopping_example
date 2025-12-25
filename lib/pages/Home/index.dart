import 'package:flu_web_pro01/components/Home/HmMoreList.dart';
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
  final List<BannerItem> banners = [
    BannerItem(
      id: "1",
      imageUrl:
          "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meituan/1.jpg",
    ),
    BannerItem(
      id: "2",
      imageUrl:
          "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meituan/2.png",
    ),
    BannerItem(
      id: "3",
      imageUrl:
          "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meituan/3.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 包裹普通widget的 sliver 家族的组件
        SliverToBoxAdapter(child: HmSlider(banners: banners)), // 轮播图组件
        SliverToBoxAdapter(child: SizedBox(height: 10)), // 占位分隔
        // SliverGrid 和 SliverList 只能纵向滚动，不能横向滚动， 所以这里用 SliverToBoxAdapter 包裹
        SliverToBoxAdapter(child: HmCategory()), // 分类组件
        SliverToBoxAdapter(child: SizedBox(height: 10)), // 占位分隔

        SliverToBoxAdapter(child: HmSuggestion()), // 推荐组件
        SliverToBoxAdapter(child: SizedBox(height: 10)), // 占位分隔
        // 热门组件, 左右各显示一个
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(flex: 1, child: HmHot()),
                SizedBox(width: 10),
                Expanded(flex: 1, child: HmHot()),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 10)), // 占位分隔
        // 无限滚动
        HmMoreList(),
      ],
    );
  }
}
