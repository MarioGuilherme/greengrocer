import "package:dio/dio.dart";

abstract class HttpMethods {
  static const String post = "POST";
  static const String get = "PUT";
  static const String put = "GET";
  static const String patch = "PATCH";
  static const String delete = "DELETE";
}

class HttpManager {
  Future<Map<dynamic, dynamic>> restRequest({
    required String endpoint,
    required String method,
    Map<String, String>? headers,
    Map<String, Object>? body
  }) async {
    final Map<String, String> defaultHeaders = headers?.cast<String, String>() ?? <String, String>{}
      ..addAll(<String, String>{
        "content-type": "application/json",
        "accept": "application/json",
        "X-Parse-Application-Id": "wK7GcEjr2V4br5q5mlR1kybQ5dvxMFDX0qtE1d6Y",
        "X-Parse-REST-API-Key": "2kahi62fkWePLWAwC7k8aMrtQkobogcgkruMxbeB",
      });
    Dio dio = Dio();
    try {
      Response<dynamic> response = await dio.request(
        endpoint,
        options: Options(
          method: method,
          headers: defaultHeaders
        ),
        data: body
      );
      return response.data;
    } on DioError catch (error) {
      return error.response?.data ?? <String, String>{};
    } catch (error) {
      return <String, String>{};
    }
  }
}