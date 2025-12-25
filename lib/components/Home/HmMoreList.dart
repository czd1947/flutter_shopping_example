import 'package:flutter/material.dart';

class HmMoreList extends StatefulWidget {
  final double horizontalPadding; // 水平边距参数

  HmMoreList({Key? key, this.horizontalPadding = 10}) : super(key: key);

  @override
  _HmMoreListState createState() => _HmMoreListState();
}

class _HmMoreListState extends State<HmMoreList> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
      ), // 使用可配置的边距
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          return Container(
            height: 120,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "更多${index + 1}",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
