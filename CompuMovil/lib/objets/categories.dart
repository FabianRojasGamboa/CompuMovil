/*String welcomeToJson(List<Categories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));*/

class Categories {
  String token;
  String name;
  String description;

  Categories({
    required this.token,
    required this.name,
    required this.description,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        token: json["token"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "name": name,
        "description": description,
      };
}
