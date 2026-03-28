import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hand_mark/features/shared/domain/entities/infected_model.dart';

String voicetext = '';
String voicesource = '';
List alldataofvoice = [];

class VoiceInfectedServices {
  final url = 'https://192.168.101.60:8000/upload_voice/';

  voiceInfectedService(String voicepath) async {
    // Prepare the file
    final video = await http.MultipartFile.fromPath('voiceNote', voicepath);

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
      print('///////////////////////////////*********');
      print(infectedData.text);

      voicetext = infectedData.text ?? 'null';
      voicesource = infectedData.videosrc ?? 'null';

      alldataofvoice = [infectedData.videosrc, infectedData.text];
      print('--------------- true');
      print(responseString);
      print(voicesource);
      print('++++++++++++++++++++++++++++////////////*********');
      print(alldataofvoice);
      return alldataofvoice;
    } else {
      print('++++++++++++++ false');
    }
  }
}
