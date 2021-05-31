// import 'dart:convert';

// import 'package:mlproject/model/response_model.dart';
// import 'package:http/http.dart' as http;

// Future<D> getMeseasurement({required String imageUrl}) async {
//   final String url =
//       "https://backend-test-zypher.herokuapp.com/uploadImageforMeasurement";
//   Map data = {"imageURL": imageUrl};
//   String body = json.encode(data);
//   var response = await http.post(Uri.parse(url),
//       headers: {
//         "Content-Type": 'application/json',
//       },
//       body: body);
//   if (response.statusCode == 200) {
//     Map<String, dynamic> jsonData = jsonDecode(response.body);
//     return D.fromJson(jsonData["d"]);
//   } else {
//     return D();
//   }
// }
