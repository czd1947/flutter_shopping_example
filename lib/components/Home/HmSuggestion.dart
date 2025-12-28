import 'package:flu_web_pro01/viewmodels/home.dart';
import 'package:flutter/material.dart';

class HmSuggestion extends StatefulWidget {
  final SpecialOfferDataResult specialOfferDataResult;
  HmSuggestion({Key? key, required this.specialOfferDataResult})
    : super(key: key);

  @override
  _HmSuggestionState createState() => _HmSuggestionState();
}

class _HmSuggestionState extends State<HmSuggestion> {
  // 计算每个item的宽度，这里假设每个item的宽度为100，加上间距
  final double itemWidth = 100;
  final double itemHeight = 180;

  // 顶部内容
  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          widget.specialOfferDataResult.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 86, 24, 20),
          ),
        ),
        SizedBox(width: 10),
        Text(
          "精选省攻略",
          style: TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 124, 63, 58),
          ),
        ),
      ],
    );
  }

  // 底部左侧 固定图片
  Widget _buildLeft() {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage('lib/assets/images/suggest_left.webp'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRight() {
    if (widget.specialOfferDataResult.subTypes.isNotEmpty) {
      // 定义一个临时变量来 widget.specialOfferDataResult  中的 SpecialOfferGoodsItem 项
      List<SpecialOfferGoodsItem> tempList = [];

      // 为什么 要 widget.specialOfferDataResult.subTypes 要 toList():
      // 因为 widget.specialOfferDataResult.subTypes 是一个 Iterable<SpecialOfferSubType> 类型
      // 而 forEach 方法只能用于 List 类型
      // 所以要先将 Iterable<SpecialOfferSubType> 转换为 List<SpecialOfferSubType> 类型
      widget.specialOfferDataResult.subTypes.toList().forEach((item) {
        if (item.goodsItems.items.isNotEmpty) {
          tempList.addAll(item.goodsItems.items);
        }
      });

      return Container(
        height: itemHeight, // 给一个固定高度，包括图片和文字
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tempList.length,
          itemBuilder: (context, index) {
            return Container(
              width: itemWidth, // 每个item的宽度
              margin: EdgeInsets.only(right: 10), // 右边距
              child: Column(
                children: [
                  // 上面图片， ClipRRect 圆角处理
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      tempList[index].picture,
                      width: itemWidth,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: itemWidth,
                          height: 140,
                          color: Colors.grey,
                          child: Icon(Icons.error),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 5),
                  // 下面文字
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '￥${tempList[index].price}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return Container(
      height: itemHeight, // 与有数据时的高度一致
      child: Center(child: Text("暂无数据")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        // 背景图设置
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('lib/assets/images/suggest_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeft(),

                SizedBox(width: 10),

                // 占满剩余空间
                Expanded(child: _buildRight()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
