import 'package:dio/dio.dart';

final baseUrl = "https://dashboard-adwil.kemendagri.go.id/";

Dio dioClient() {
  BaseOptions options = new BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Accept': 'application/json',
    },
  );

  Dio dio = new Dio(options);

  return dio;
}

Dio httpClient = dioClient();

Future<Response> getGeoMap() {
  return httpClient.get('assets/data/pelayanan/kotamin.json');
}
