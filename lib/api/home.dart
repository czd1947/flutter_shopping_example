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

// 获取分类数据
Future<List<CategoryItem>> getCategoryListAPI() async {
  // 返回请求数据
  return ((await DioRequest().get(HttpConstants.CATEGORY_LIST)) as List).map((
    item,
  ) {
    return CategoryItem.fromJSON(item);
  }).toList();
}

// 获取热门商品数据
Future<SpecialOfferDataResult> getSpecialOfferListAPI() async {
  // 返回请求数据
  return SpecialOfferDataResult.fromJSON(
    await DioRequest().get(HttpConstants.HOT_PRODUCT_LIST),
  );
}

// 获取爆款推荐数据
Future<SpecialOfferDataResult> getInvogueListAPI() async {
  // 返回请求数据
  return SpecialOfferDataResult.fromJSON(
    await DioRequest().get(HttpConstants.INVOGUE_LIST),
  );
}

// 获取一站全买数据
Future<SpecialOfferDataResult> getOneStopListAPI() async {
  // 返回请求数据
  return SpecialOfferDataResult.fromJSON(
    await DioRequest().get(HttpConstants.ONE_STOP_LIST),
  );
}

// 获取推荐商品数据
Future<List<RecommendGoodsItem>> getRecommendListAPI(
  Map<String, dynamic> params,
) async {
  // 返回请求数据
  return ((await DioRequest().get(
            HttpConstants.RECOMMEND_LIST,
            queryParameters: params,
          ))
          as List)
      .map((item) {
        return RecommendGoodsItem.fromJSON(item);
      })
      .toList();
}
