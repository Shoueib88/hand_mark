import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hand_mark/features/shared/domain/entities/infected_model.dart';

String valuetext = '';
String textsource = '';
List alldataoftext = [];

class TextInfectedServices {
  final String url = 'https://192.168.101.60:8000/upload_text/';

  textInfectedService(String text) async {
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $text');
    // final Map<String, String> body = {'text_input': text};
    try {
      print('mbcdfcbbbbbbbbbbbbbbb');
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({'text_input': 'شعيب'});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        print(await response.stream.bytesToString());
        final jsondecode = jsonDecode(responseString);
        final infectedData = InfectedModel.fromJson(jsondecode);
        print('///////////////////////////////*********');
        print(infectedData.text);

        valuetext = infectedData.text ?? 'null';
        textsource = infectedData.videosrc ?? 'null';

        alldataoftext = [infectedData.videosrc, infectedData.text];
        return alldataoftext;
      } else {
        print(response.reasonPhrase);
        print('//////////////////////////////////////////');
        return null;
      }
    } catch (e) {
      print('++++++++++++++++++++++++++++++++ $e');
      return null;
    }
  }
}
