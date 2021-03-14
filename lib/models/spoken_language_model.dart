import 'dart:convert';

SpokenLanguage spokenLanguageFromJson(String str) =>
    SpokenLanguage.fromJson(json.decode(str));

String spokenLanguageToJson(SpokenLanguage data) => json.encode(data.toMap());

class SpokenLanguage {
  SpokenLanguage({
    this.iso6391,
    this.name,
  });

  final String iso6391;
  final String name;

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
        iso6391: json["iso_639_1"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "iso_639_1": iso6391,
        "name": name,
      };
}
