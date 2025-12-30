import 'package:flu_web_pro01/viewmodels/home.dart';
import 'package:flutter/material.dart';

class HmMoreList extends StatefulWidget {
  final double horizontalPadding; // 水平边距参数
  final List<RecommendGoodsItem> recommendList; // 推荐商品数据

  HmMoreList({
    Key? key,
    this.horizontalPadding = 10,
    required this.recommendList,
  }) : super(key: key);

  @override
  _HmMoreListState createState() => _HmMoreListState();
}

class _HmMoreListState extends State<HmMoreList> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75, // 调整宽高比，非常重要！
        ),
        itemCount: widget.recommendList.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.white,
            // 移除固定高度，让网格控制
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 图片部分 - 使用 Expanded 自适应高度
                Expanded(
                  // ClipRRect 包裹图片，确保圆角
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // 包裹 AspectRatio，确保图片 按aspectRatio 设置的比例 展示
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.network(
                        widget.recommendList[index].picture,
                        // width: double.infinity,
                        // height: double.infinity, // 使用父容器高度
                        fit: BoxFit.cover, // 裁剪图片以适应容器
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[200],
                            child: Icon(Icons.error, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 5),

                // 商品名称
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    widget.recommendList[index].name,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 4),

                // 价格和付款人数
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '￥${widget.recommendList[index].price}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.recommendList[index].payCount}人付款', // 修复：去掉大括号
                        style: TextStyle(
                          fontSize: 10,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
