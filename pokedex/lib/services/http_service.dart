import 'package:dio/dio.dart';

class HttpService {

  HttpService();

  final _dio = Dio();

  Future<Response?> get(String path) async {
    try {
      Response res = await _dio.get(path);
      return res;
    } catch (e) {
      print(e);
    }
      return null;
  }

  Future<Response?> post(String path, {Map<String, dynamic>? data}) async {
    try {
      Response res = await _dio.post(path, data: data);
      return res;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Response?> delete(String path) async {
    try {
      Response res = await _dio.delete(path);
      return res;
    } catch (e) {
      print(e);
    }
    return null;
  }


}