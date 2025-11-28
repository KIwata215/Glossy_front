import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //ipconfig getifaddr en0をしてipを自分のに変更
  static const String baseUrl = "http://ここに自分のIP:3000";

  // サムネ取得
  static Future<dynamic> getThumbnails() async {
    final response = await http.get(Uri.parse("$baseUrl/thumbnails"));
    return jsonDecode(response.body);
  }
}
