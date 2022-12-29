class Agent {
  String? ID;
  String? Type;
  String? Title;
  String? Email;
  String? Phone;

  Agent({
    required this.ID,
    required this.Type,
    required this.Title,
    required this.Email,
    required this.Phone,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    final id = json['ID'];
    final type = json['Type'];
    final title = json['Title'];
    final email = json['Email'];
    final phone = json['Phone'];
    return Agent(
      ID: id,
      Type: type,
      Title: title,
      Email: email,
      Phone: phone,
    );
  }
}
