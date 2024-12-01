import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();
  final String baseUrl = 'http://192.168.1.73:8080';
}
//192.168.1.73
//10.0.2.2