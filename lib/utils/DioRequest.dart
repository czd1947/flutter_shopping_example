import 'package:dio/dio.dart';
import 'package:flu_web_pro01/constants/index.dart';
import 'package:flu_web_pro01/stores/TokenManager.dart';

class DioRequest {
  // Dio 实例对象，用于发起HTTP请求
  final Dio _dio = Dio();

  DioRequest() {
    // 配置Dio实例
    _dio.options
      ..baseUrl = GlobalConstants
          .BASE_URL // API服务器基础URL
      ..connectTimeout =
          Duration(seconds: GlobalConstants.TIME_OUT) // 连接超时时间
      ..receiveTimeout =
          Duration(seconds: GlobalConstants.TIME_OUT) // 接收超时时间
      ..sendTimeout = Duration(seconds: GlobalConstants.TIME_OUT); // 发送超时时间

    // 添加拦截器
    _addInterceptors();
  }

  // 添加拦截器
  void _addInterceptors() {
    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        // 请求拦截器：在请求发送前执行
        // 主要功能：自动注入 JWT Token 到请求头
        onRequest: (request, handler) async {
          // 检查是否存在有效Token， 存在则自动添加到请求头
          String token = await TokenManager().getToken();
          if (token != '') {
            // 存在有效Token，添加到请求头
            request.headers['Authorization'] = 'Bearer $token';
          }

          // 继续请求流程
          return handler.next(request);
        },
        // 响应拦截器：在响应返回后执行
        // 主要功能：验证HTTP状态码，过滤非2xx响应
        onResponse: (response, handler) {
          // 检查HTTP状态码是否为2xx
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            // 状态码为2xx，继续处理响应
            return handler.next(response);
          }

          // 状态码非2xx，拒绝响应, 并返回错误信息
          return handler.reject(
            DioException(requestOptions: response.requestOptions),
          );
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          // 在请求错误时执行
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              message: error.response?.data['msg'] ?? '网络请求失败，请稍后重试',
            ),
          );
        },
      ),
    );
  }

  /// 封装get请求
  /// @param path 请求路径
  /// @param queryParameters 查询参数
  /// @param options 请求选项
  /// @param cancelToken 取消令牌
  /// @param onReceiveProgress 接收进度回调
  /// @return 响应数据
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleResponse(
      _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// 封装post请求
  /// @param path 请求路径
  /// @param data 请求数据
  /// @param queryParameters 查询参数
  /// @param options 请求选项
  /// @param cancelToken 取消令牌
  /// @param onSendProgress 发送进度回调
  /// @param onReceiveProgress 接收进度回调
  /// @return 响应数据
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _handleResponse(
      _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  // 统一处理 HTTP 响应和业务状态
  Future<dynamic> _handleResponse(Future<Response<dynamic>> task) async {
    try {
      // 等待请求完成，获取完整响应
      final Response<dynamic> response = await task;

      // 提取响应数据并转换为Map格式
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;

      // 检查业务状态码是否为成功
      if (response.data['code'] == GlobalConstants.SUCCESS_CODE) {
        // 业务状态码为成功，返回数据
        return response.data['result'];
      }
      // 业务状态码非成功，抛出异常
      throw DioException(
        requestOptions: response.requestOptions,
        message: response.data['msg'] ?? '业务处理失败，请稍后重试',
      );
    } on DioException catch (e) {
      // 保持原始异常类型，不进行包装，便于调用方法精确处理
      rethrow;
    }
  }
}
