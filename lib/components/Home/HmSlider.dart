import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flu_web_pro01/viewmodels/home.dart';

class HmSlider extends StatefulWidget {
  // 接收 - 轮播图数据
  final List<BannerItem> banners;

  HmSlider({Key? key, required this.banners}) : super(key: key);

  @override
  _HmSliderState createState() => _HmSliderState();
}

class _HmSliderState extends State<HmSlider> {
  // 定义当前轮播图索引
  int _currentIndex = 0;
  // 定义轮播图控制器
  CarouselSliderController _carouselController = CarouselSliderController();

  // 定义轮播图组件
  Widget _getSlider() {
    // print("轮播图数据： ${widget.banners}");
    // 遍历轮播图数据，打印每个item的imageUrl
    // widget.banners.forEach((item) {
    //   print("轮播图图片地址: ${item.imageUrl}");
    // });

    // 在 Flutter 中获取屏幕宽度的方法
    final double screenWidth = MediaQuery.of(context).size.width;

    // 录播图组件
    return CarouselSlider(
      carouselController: _carouselController, // 轮播图控制器
      items: List.generate(widget.banners.length, (int index) {
        return Image.network(
          widget.banners[index].imageUrl,
          fit: BoxFit.cover,
          width: screenWidth,
        );
      }),
      options: CarouselOptions(
        viewportFraction: 1.0, // 每个item占满viewport
        height: 300, // 高度
        autoPlay: true, // 自动播放
        autoPlayInterval: Duration(seconds: 3), // 自动播放间隔
        autoPlayAnimationDuration: Duration(milliseconds: 800), // 自动播放动画时间
        autoPlayCurve: Curves.fastOutSlowIn, // 自动播放动画曲线
        pauseAutoPlayOnTouch: true, // 触摸暂停自动播放
        pauseAutoPlayInFiniteScroll: true, // 有限滚动时暂停自动播放
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // 定义搜索组件
  Widget _getSearch() {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            "搜索...",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  // 定义导航条组件
  Widget _getDots() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      height: 60,
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
          children: List.generate(widget.banners.length, (int index) {
            return GestureDetector(
              onTap: () {
                // 点击导航条切换轮播图
                _carouselController.animateToPage(index);
                _currentIndex = index;
                setState(() {});
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 6,
                width: index == _currentIndex ? 20 : 6,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? Colors.white
                      : Color.fromRGBO(0, 0, 0, 0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_getSlider(), _getSearch(), _getDots()]);
  }
}
