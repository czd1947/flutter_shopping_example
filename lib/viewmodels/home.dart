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
