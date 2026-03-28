class InfectedModel {
  bool? statue;
  String? text;
  String? videosrc;

  InfectedModel({this.statue, this.text, this.videosrc});

  InfectedModel.fromJson(Map<String, dynamic> json) {
    statue = json["statue"];
    text = json["text"];
    videosrc = json["videosrc"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["statue"] = statue;
    _data["text"] = text;
    _data["videosrc"] = videosrc;
    return _data;
  }
}
