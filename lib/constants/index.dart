class GlobalConstants {
  // dio 的部分常量
  static const String BASE_URL = 'https://meikou-api.itheima.net'; // 基础URL
  static const String SUCCESS_CODE = '1'; // 成功状态码
  static const int TIME_OUT = 10; // 超时时间 s单位
}

class HttpConstants {
  // 首页banner列表
  static const String BANNER_LIST = '/home/banner';
  // 分类列表
  static const String CATEGORY_LIST = '/home/category/head';
  // 热门商品列表
  static const String HOT_PRODUCT_LIST = '/hot/preference';
  // 爆款推荐
  static const String INVOGUE_LIST = '/hot/inVogue';
  // 一站全买
  static const String ONE_STOP_LIST = '/hot/oneStop';
  // 推荐列表
  static const String RECOMMEND_LIST = '/home/recommend';
  // 猜你喜欢
  static const String GUESS_LIKE_LIST = '/home/goods/guessLike';
}
