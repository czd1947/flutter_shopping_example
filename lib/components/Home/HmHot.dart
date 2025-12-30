import 'package:flu_web_pro01/viewmodels/home.dart';
import 'package:flutter/material.dart';

class HmHot extends StatefulWidget {
  final SpecialOfferDataResult specialOfferDataResult;
  // 类型，爆款推荐 hot / 一站全买 step
  final String type;

  HmHot({Key? key, required this.specialOfferDataResult, required this.type})
    : super(key: key);

  @override
  _HmHotState createState() => _HmHotState();
}

class _HmHotState extends State<HmHot> {
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
          widget.type == 'hot' ? "最受欢迎" : "精心优选",
          style: TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 124, 63, 58),
          ),
        ),
      ],
    );
  }

  Widget _buildBottom() {
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
      // 只取前2个
      tempList = tempList.sublist(0, 2);

      return ClipRect(
        child: Row(
          spacing: 10, // 间距
          children: List.generate(tempList.length, (int index) {
            return Expanded(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      tempList[index].picture,
                      // width: itemWidth,
                      // height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          // width: itemWidth,
                          // height: 140,
                          color: Colors.grey,
                          child: Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 5),
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
          }),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.type == 'hot'
              ? Color.fromARGB(255, 249, 247, 219)
              : Color.fromARGB(255, 211, 228, 240),
        ),
        child: Column(
          children: [_buildHeader(), SizedBox(height: 10), _buildBottom()],
        ),
      ),
    );
  }
}
