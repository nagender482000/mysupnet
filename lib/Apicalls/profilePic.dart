import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

profilepic(file) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token').toString();
  var headers = {'Authorization': 'Bearer ' + token.toString()};

  var request = http.MultipartRequest(
      'POST', Uri.parse("https://apis.mysupnet.org/api/v1/user/image"));
  request.files
      .add(await http.MultipartFile.fromPath('image', file));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    Fluttertoast.showToast(msg: "Uploaded.");
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
