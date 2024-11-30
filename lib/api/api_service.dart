import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();
  final String baseUrl = 'http://10.0.2.2:8080';
}
//192.168.1.73 home
//10.192.208.1 moscow
//10.0.2.2 local for emu