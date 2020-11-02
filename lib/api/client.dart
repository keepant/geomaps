import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geomaps/api/http.dart' as httpClient;

class FetchException implements Exception {
  final DioError _error;
  final String _message;

  FetchException([this._error, this._message]);

  String toString() {
    return "Error found: $_message.\n${_error.message}";
  }
}

Future<String> getGeoMap() async {
  String data;
  try {
    Response response = await httpClient.getGeoMap();
    data = jsonEncode(response.data);
    print('geoData: $data');

    return data;
  } on DioError catch (err) {
    throw FetchException(err, 'unable to load geo maps data');
  }
}
