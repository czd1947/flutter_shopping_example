import 'package:flu_web_pro01/viewmodels/home.dart';
import 'package:flutter/material.dart';

class HmCategory extends StatefulWidget {
  final List<CategoryItem> categoryList;
  HmCategory({Key? key, required this.categoryList}) : super(key: key);

  @override
  _HmCategoryState createState() => _HmCategoryState();
}

class _HmCategoryState extends State<HmCategory> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categoryList.length,
        itemBuilder: (context, index) {
          final categoryItem = widget.categoryList[index];

          return Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 228, 230),
              borderRadius: BorderRadius.circular(40),
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
              children: [
                Image.network(categoryItem.picture, width: 50, height: 50),
                Text(
                  categoryItem.name,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
