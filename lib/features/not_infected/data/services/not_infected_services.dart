import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hand_mark/features/shared/domain/entities/infected_model.dart';

String text = '';
String vediosource = '';
List alldata = [];

class InfectedServices {
  final url = 'https://192.168.101.60:8000/upload/';

  infectedService(String vediosource) async {
    // Prepare the file
    final video = await http.MultipartFile.fromPath('video', vediosource);

    // Create the multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add the file
    request.files.add(video);

    // Send the request
    final response = await request.send();
    // Process the response

    if (response.statusCode == 200) {
      final responseString =
          await response.stream.transform(utf8.decoder).join();
      final jsondecode = jsonDecode(responseString);
      final infectedData = InfectedModel.fromJson(jsondecode);
      print('++++++++++++++++++++++++++++////////////*********');
      print(infectedData.text);

      text = infectedData.text ?? 'null';
      vediosource = infectedData.videosrc ?? 'null';

      alldata = [infectedData.videosrc, infectedData.text];
      print('--------------- true');

      return alldata;
    } else {
      print('++++++++++++++ false');
    }
  }
}
