// 获取轮播图数据
import 'package:flu_web_pro01/constants/index.dart';
import 'package:flu_web_pro01/utils/DioRequest.dart';
import 'package:flu_web_pro01/viewmodels/home.dart';

// 封装一个API 目的是返回业务侧要的数据
Future<List<BannerItem>> getBannerListAPI() async {
  // 返回请求数据
  // Future<List<BannerItem>> 是一个异步操作，它将在未来某个时间点返回一个 List<BannerItem>
  // 所以可以使用 as List 操作
  return ((await DioRequest().get(HttpConstants.BANNER_LIST)) as List).map((
    item,
  ) {
    return BannerItem.fromJSON(item);
  }).toList();
}
