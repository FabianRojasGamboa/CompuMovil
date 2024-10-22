import 'dart:convert';

/*List<Welcome> welcomeFromJson(String str) =>
    List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
*/
class Access {
  String ip;
  String userAgent;
  String requestUri;
  DateTime created;

  Access({
    required this.ip,
    required this.userAgent,
    required this.requestUri,
    required this.created,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        ip: json["ip"],
        userAgent: json["userAgent"],
        requestUri: json["requestUri"],
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "ip": ip,
        "userAgent": userAgent,
        "requestUri": requestUri,
        "created": created.toIso8601String(),
      };
}
