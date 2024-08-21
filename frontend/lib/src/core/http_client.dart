// ignore_for_file: deprecated_member_use

import 'dart:convert';
// import 'dart:io';
// import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/src/core/core.dart';
import 'package:frontend/src/core/dio_logging_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HttpNetworkUtil extends EventEmitter {
  // Setup a singleton
  static final HttpNetworkUtil _httpClient = HttpNetworkUtil._internal();
  factory HttpNetworkUtil() {
    return _httpClient;
  }
  HttpNetworkUtil._internal();

  final _logger = Logger();

  static Future<BaseOptions> baseOptions() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return await Future.value(BaseOptions(
      baseUrl: AppConfig.getConfig(packageInfo.packageName).apiUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      followRedirects: true,
      receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
      },
    ));
  }

  // methods
  Future<Response> getRequest(String endpoint) async {
    try {
      Dio dio = await addInterceptors();
      Response response = await dio.get(
        endpoint,
      );
      return response;
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<Response> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      _logger.i(
        "postPayload:\nendpoint: $endpoint\nbody:${json.encode(body)}",
      );
      Dio dio = await addInterceptors();
      Response response = await dio.post(
        endpoint,
        data: json.encode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> putRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    _logger.d(json.encode(body));
    try {
      Dio dio = await addInterceptors();
      Response response = await dio.put(
        endpoint,
        data: json.encode(body),
      );
      return response;
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<Response> deleteRequest(String endpoint) async {
    try {
      Dio dio = await addInterceptors();
      Response response = await dio.delete(
        endpoint,
      );
      return response;
    } catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> multipartUpload(
    String url, {
    required Map<String, dynamic> body,
  }) async {
    final formData = FormData.fromMap({
      'name': body['name'],
      'path': body['path'],
      'access': body['access'],
      'type': body['type'],
      'file': await MultipartFile.fromFile(
        body['file'],
        filename: body['name'],
      )
    });
    Dio dio = await addInterceptors();
    final resp = await dio.post(url, data: formData);

    return resp.data;
  }

  Future<Dio> addInterceptors() async {
    Dio dio = Dio(await baseOptions());
    dio.interceptors.clear();

    dio.interceptors.add(
      DioLoggingInterceptor(
        level: !kDebugMode ? LogLevel.none : LogLevel.basic,
        compact: false,
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          String? token = await SharedPreference().getToken();
          if (token.isNotEmpty) {
            request.headers['Authorization'] = "Bearer $token";
          } else {
            // remove Authorization
            request.headers.remove('Authorization');
          }
          Logger().i('${request.uri}');
          Logger().i(request.data);
          Logger().i(request.headers);
          return handler.next(request);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (err, handler) async {
          Logger().e(err);
          if (err.response?.statusCode == 401) {
            try {
              Logger().e('401 error');

              RequestOptions options = err.response!.requestOptions;
              // final opts = Options(method: options.method);
              Map<String, dynamic>? newResponse = await specialRefresh();

              Logger().i("WE HAVE A NEW BABY");
              Logger().i(newResponse);
              Logger().i("WE HAVE A NEW BABY");

              if (newResponse != null) {
                Logger().i("THE BABY IS BEING SAVED");
                String accessToken = newResponse['accessToken'];
                String refreshToken = newResponse['refreshToken'];
                await SharedPreference().setToken(accessToken);
                await SharedPreference().setRefreshToken(refreshToken);

                options.headers['Authorization'] = "Bearer $accessToken";

                // Repeat the request with the updated header
                final res = await dio.fetch(err.requestOptions);
                // Logger().wtf("WTF BRUhh");
                // Logger().wtf(res);
                // Logger().wtf("WTF BRUhh");
                return handler.resolve(res);
                // Dio dioRecall = Dio();
                // // dioRecall.options.connectionTimeout = 5000;
                // // dioRecall.options.receiveTimeout = 5000;
                // dioRecall.options.headers['Authorization'] =
                //     "Bearer $accessToken";
                // final response = await dioRecall.request(
                //   options.path,
                //   options: opts,
                //   cancelToken: options.cancelToken,
                //   onReceiveProgress: options.onReceiveProgress,
                //   data: options.data,
                //   queryParameters: options.queryParameters,
                // );
                // Logger().wtf("WTF BRUhh");
                // Logger().wtf(response);
                // Logger().wtf("WTF BRUhh");
                // handler.resolve(response);
                // dio.fetch(options).then(
                //   (r) => handler.resolve(r),
                //   onError: (e) {
                //     handler.reject(e);
                //   },
                // );
              } else {
                // Example logic for handling 401 response
                // if (on401 != null) {
                //   // Invoke the callback
                //   on401!();
                // }
                emit('on401');
                return handler.reject(err);
              }
            } catch (e) {
              return handler.reject(err);
            }
          } else {
            return handler.next(err);
          }
        },
      ),
    );
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: !kDebugMode ? LogLevel.none : LogLevel.basic,
        compact: false,
      ),
    );
    return dio;
  }

  Future<Map<String, dynamic>?> specialRefresh() async {
    try {
      String? token = await SharedPreference().getRefreshToken();
      if (token == null) return null;
      final packageInfo = await PackageInfo.fromPlatform();
      Logger().wtf("Refresh token --> $token");
      BaseOptions baseOptions = BaseOptions(
        baseUrl: AppConfig.getConfig(packageInfo.packageName).apiUrl,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        followRedirects: true,
        receiveDataWhenStatusError: true,
        headers: {
          'Accept': 'application/json',
        },
      );

      Dio dio = Dio(baseOptions);
      const endpoint = "/refresh-token";

      Logger().i("Getting new access tokens");
      final payload = {"refreshToken": token};
      Logger().i(payload);
      final response = await dio.post(
        endpoint,
        data: payload,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      Logger().i("🔥 Error 🔥");
      if (e is DioException) {
        Logger().e(e.response?.data);
        Logger().e(e.response?.statusCode);
      }
      _logger.e(e.toString());
      Logger().i("🔥 Error 🔥");
    }
    return null;
  }
}
