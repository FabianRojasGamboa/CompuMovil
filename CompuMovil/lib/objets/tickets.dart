import 'dart:convert';

List<Ticket> ticketsFromJson(String str) =>
    List<Ticket>.from(json.decode(str).map((x) => Ticket.fromJson(x)));

String ticketsToJson(List<Ticket> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ticket {
  String type;
  String subject;
  String message;
  Category category;
  String token;
  String status;
  DateTime created;
  DateTime updated;

  Ticket({
    required this.type,
    required this.subject,
    required this.message,
    required this.category,
    required this.token,
    required this.status,
    required this.created,
    required this.updated,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        type: json["type"],
        subject: json["subject"],
        message: json["message"],
        category: Category.fromJson(json["category"]),
        token: json["token"],
        status: json["status"],
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "subject": subject,
        "message": message,
        "category": category.toJson(),
        "token": token,
        "status": status,
        "created": created.toIso8601String(),
        "updated": updated.toIso8601String(),
      };
}

class Category {
  String token;
  String name;
  String description;

  Category({
    required this.token,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
