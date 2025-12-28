// 定义轮播图数据类型
class BannerItem {
  String id;
  String imageUrl;

  BannerItem({required this.id, required this.imageUrl});

  // 拓展一个工厂函数，一般用factory 来声明，用来创建实例对象
  factory BannerItem.fromJSON(Map<String, dynamic> json) {
    // 必须返回一个 BannerItem 实例对象
    return BannerItem(id: json['id'] ?? '', imageUrl: json['imgUrl'] ?? '');
  }
}

/*
[
		{
			"id": "1181622001",
			"name": "气质女装",
			"picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c1/qznz.png",
			"children": [
				{
					"id": "1191110001",
					"name": "半裙",
					"picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_bq.png?quality=95&imageView",
					"children": [
            {
              "id": "1191110002",
              "name": "衬衫",
              "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_cs.png?quality=95&imageView",
              "children": [
                {
                  "id": "1191110022",
                  "name": "T恤",
                  "picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_tx.png?quality=95&imageView",
                  "children": null,
                  "goods": null
                },
              ],
              "goods": null
            }
          ],
					"goods": null
				},
				{
					"id": "1191110002",
					"name": "衬衫",
					"picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_cs.png?quality=95&imageView",
					"children": null,
					"goods": null
				},
				{
					"id": "1191110022",
					"name": "T恤",
					"picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_tx.png?quality=95&imageView",
					"children": null,
					"goods": null
				},
				{
					"id": "1191110023",
					"name": "针织衫",
					"picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_zzs.png?quality=95&imageView",
					"children": null,
					"goods": null
				},
				{
					"id": "1191110024",
					"name": "夹克",
					"picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_jk.png?quality=95&imageView",
					"children": null,
					"goods": null
				},
				{
					"id": "1191110025",
					"name": "卫衣",
					"picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_wy.png?quality=95&imageView",
					"children": null,
					"goods": null
				},
				{
					"id": "1191110028",
					"name": "背心",
					"picture": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_bx.png?quality=95&imageView",
					"children": null,
					"goods": null
				}
			],
			"goods": null
		},
*/

// 根据上面的json 定义分类数据类型
class CategoryItem {
  String id;
  String name;
  String picture;
  List<CategoryItem>? children;

  CategoryItem({
    required this.id,
    required this.name,
    required this.picture,
    this.children,
  });

  // 拓展一个工厂函数，一般用factory 来声明，用来创建实例对象
  factory CategoryItem.fromJSON(Map<String, dynamic> json) {
    // 必须返回一个 CategoryItem 实例对象
    return CategoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      children: json['children'] != null
          ? (json['children'] as List)
                .map((item) => CategoryItem.fromJSON(item))
                .toList()
          : null,
    );
  }
}

// 特惠推荐对象模型
class SpecialOfferDataResult {
  String id;
  String title;
  List<SpecialOfferSubType> subTypes;

  SpecialOfferDataResult({
    required this.id,
    required this.title,
    required this.subTypes,
  });

  factory SpecialOfferDataResult.fromJSON(Map<String, dynamic> json) {
    return SpecialOfferDataResult(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subTypes:
          (json['subTypes'] as List?)
              ?.map((item) => SpecialOfferSubType.fromJSON(item))
              .toList() ??
          [],
    );
  }
}

class SpecialOfferSubType {
  String id;
  String title;
  SpecialOfferGoodsItems goodsItems;

  SpecialOfferSubType({
    required this.id,
    required this.title,
    required this.goodsItems,
  });

  factory SpecialOfferSubType.fromJSON(Map<String, dynamic> json) {
    return SpecialOfferSubType(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      goodsItems: SpecialOfferGoodsItems.fromJSON(json['goodsItems'] ?? {}),
    );
  }
}

class SpecialOfferGoodsItems {
  int counts;
  int pageSize;
  int pages;
  int page;
  List<SpecialOfferGoodsItem> items;

  SpecialOfferGoodsItems({
    required this.counts,
    required this.pageSize,
    required this.pages,
    required this.page,
    required this.items,
  });

  factory SpecialOfferGoodsItems.fromJSON(Map<String, dynamic> json) {
    return SpecialOfferGoodsItems(
      counts: json['counts'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      pages: json['pages'] ?? 0,
      page: json['page'] ?? 0,
      items:
          (json['items'] as List?)
              ?.map((item) => SpecialOfferGoodsItem.fromJSON(item))
              .toList() ??
          [],
    );
  }
}

class SpecialOfferGoodsItem {
  String id;
  String name;
  String? desc;
  String price;
  String picture;
  int orderNum;

  SpecialOfferGoodsItem({
    required this.id,
    required this.name,
    this.desc,
    required this.price,
    required this.picture,
    required this.orderNum,
  });

  factory SpecialOfferGoodsItem.fromJSON(Map<String, dynamic> json) {
    return SpecialOfferGoodsItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'],
      price: json['price'] ?? '',
      picture: json['picture'] ?? '',
      orderNum: json['orderNum'] ?? 0,
    );
  }
}

/*
[
		{
			"id": "4033959",
			"name": "3秒快速拆琴轻松保养odin奥丁12半音阶口琴",
			"price": 329,
			"picture": "https://yanxuan-item.nosdn.127.net/937a8e46a9284e8f7e00e13911ecfbe7.png",
			"payCount": 0
		},
		{
			"id": "4027998",
			"name": "亮碟多效合一洗涤块495g",
			"price": 69.9,
			"picture": "https://yanxuan-item.nosdn.127.net/e07c2b63765cf9f4a46d489c6e09c1c1.jpg",
			"payCount": 0
		},
]
*/
// 根据上面的json 定义推荐商品数据类型
class RecommendGoodsItem {
  String id;
  String name;
  double price;
  String picture;
  int payCount;

  RecommendGoodsItem({
    required this.id,
    required this.name,
    required this.price,
    required this.picture,
    required this.payCount,
  });

  factory RecommendGoodsItem.fromJSON(Map<String, dynamic> json) {
    return RecommendGoodsItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0.0,
      picture: json['picture'] ?? '',
      payCount: json['payCount'] ?? 0,
    );
  }
}
