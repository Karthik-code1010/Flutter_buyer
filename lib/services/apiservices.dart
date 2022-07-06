import 'dart:convert';
import 'package:http/http.dart' as http;

class apiProvider {
  Future getData() async {
    var res2 = await http.post(
      Uri.parse(
          'http://192.168.1.2:8000/api/service/filterProducts?limit=&offset=&categoryId=&search='),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (res2.statusCode == 200) {
      final body = res2.body;
      final res = json.decode(body);
      return res;
    } else {
      return json.decode(res2.body);
    }
  }
}
