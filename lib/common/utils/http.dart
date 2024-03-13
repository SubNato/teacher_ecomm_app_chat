import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../../global.dart';
import '../values/constants.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() {
    return _instance;
  }

  late Dio dio;

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(

        baseUrl: AppConstants.SERVER_API_URL,
        connectTimeout: 5*6000,
        receiveTimeout: 5*6000,
        headers: {},
        contentType: "application/json: charset=utf-8",
        responseType: ResponseType.json);
    dio = Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }


  Future post(String path,
      {dynamic mydata,
        Map<String, dynamic>? queryParameters,
        Options? options}) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await dio.post(path,
        data: mydata,
        queryParameters: queryParameters,
        options: requestOptions);

    return response.data;
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    var accessToken = Global.storageService.getUserToken();
    if (accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }
}
