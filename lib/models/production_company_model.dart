import 'dart:convert';

ProductionCompany productionCompanyFromJson(String str) =>
    ProductionCompany.fromJson(json.decode(str));

String productionCompanyToJson(ProductionCompany data) =>
    json.encode(data.toMap());

class ProductionCompany {
  ProductionCompany({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  final int id;
  final String logoPath;
  final String name;
  final String originCountry;

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      ProductionCompany(
        id: json["id"],
        logoPath: json["logo_path"] == null ? null : json['logo_path'],
        name: json["name"],
        originCountry: json["origin_country"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "logo_path": logoPath,
        "name": name,
        "origin_country": originCountry,
      };
}
