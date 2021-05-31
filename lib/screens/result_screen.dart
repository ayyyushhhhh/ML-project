import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mlproject/model/response_model.dart';

class ResultScreen extends StatefulWidget {
  final String imageUrl;

  const ResultScreen({Key? key, required this.imageUrl}) : super(key: key);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late D result;

  Future<D> _getMeseasurement({required String imageUrl}) async {
    final String url =
        "https://backend-test-zypher.herokuapp.com/uploadImageforMeasurement";
    Map data = {"imageURL": imageUrl};
    String body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": 'application/json',
        },
        body: body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return D.fromJson(jsonData["d"]);
    } else {
      return D();
    }
  }

  Widget listTileContainer(String title, String resval) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 1.0,
            )
          ],
          border: Border.all(color: Colors.black12)),
      child: ListTile(
        title: Text(title),
        trailing: Text(resval.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: _getMeseasurement(imageUrl: widget.imageUrl),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              result = snapshot.data;
              return ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Take Mesauements Again"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  listTileContainer("Neck", result.neck.toString()),
                  listTileContainer("Height", result.height.toString()),
                  listTileContainer("Weight", result.weight.toString()),
                  listTileContainer("Belly", result.belly.toString()),
                  listTileContainer("Chest", result.chest.toString()),
                  listTileContainer("Wrist", result.wrist.toString()),
                  listTileContainer("armLength", result.armLength.toString()),
                  listTileContainer("Thigh", result.thigh.toString()),
                  listTileContainer("Shoulder", result.shoulder.toString()),
                  listTileContainer("Hips", result.hips.toString()),
                  listTileContainer("Ankle", result.ankle.toString()),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
