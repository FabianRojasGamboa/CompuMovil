class ListTickets {
  String type;
  String title;
  int status;
  String detail;
  String instance;

  ListTickets({
    required this.type,
    required this.title,
    required this.status,
    required this.detail,
    required this.instance,
  });

  factory ListTickets.fromJson(Map<String, dynamic> json) => ListTickets(
        type: json["type"],
        title: json["title"],
        status: json["status"],
        detail: json["detail"],
        instance: json["instance"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "status": status,
        "detail": detail,
        "instance": instance,
      };
}
