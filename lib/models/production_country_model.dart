import 'dart:convert';

ProductionCountry productionCountryFromJson(String str) =>
    ProductionCountry.fromJson(json.decode(str));

String productionCountryToJson(ProductionCountry data) =>
    json.encode(data.toMap());

class ProductionCountry {
  ProductionCountry({
    this.iso31661,
    this.name,
  });

  final String iso31661;
  final String name;

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(
        iso31661: json["iso_3166_1"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "iso_3166_1": iso31661,
        "name": name,
      };
}
