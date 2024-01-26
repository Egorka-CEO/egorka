class Agent {
  String? id;
  String? type;
  String? title;
  String? email;
  String? phone;

  Agent({
    required this.id,
    required this.type,
    required this.title,
    required this.email,
    required this.phone,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    final id = json['ID'];
    final type = json['Type'];
    final title = json['Title'];
    final email = json['Email'];
    final phone = json['Phone'];
    return Agent(
      id: id,
      type: type,
      title: title,
      email: email,
      phone: phone,
    );
  }
}
