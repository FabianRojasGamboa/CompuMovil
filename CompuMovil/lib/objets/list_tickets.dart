class Ticket {
  final String type;
  final String subject;
  final String message;
  final Category category;
  final String token;
  final String status;
  final String response;
  final List<String> attachedTokens;
  final DateTime created;
  final DateTime updated;

  Ticket({
    required this.type,
    required this.subject,
    required this.message,
    required this.category,
    required this.token,
    required this.status,
    required this.response,
    required this.attachedTokens,
    required this.created,
    required this.updated,
  });

  // Método para convertir un JSON a un objeto Ticket
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      type: json['type'],
      subject: json['subject'],
      message: json['message'],
      category: Category.fromJson(json['category']),
      token: json['token'],
      status: json['status'],
      response: json['response'],
      attachedTokens: List<String>.from(json['attachedTokens']),
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  // Método para convertir un objeto Ticket a JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'subject': subject,
      'message': message,
      'category': category.toJson(),
      'token': token,
      'status': status,
      'response': response,
      'attachedTokens': attachedTokens,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }
}

class Category {
  final String token;
  final String name;
  final String description;

  Category({
    required this.token,
    required this.name,
    required this.description,
  });

  // Método para convertir un JSON a un objeto Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      token: json['token'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Método para convertir un objeto Category a JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'name': name,
      'description': description,
    };
  }
}
