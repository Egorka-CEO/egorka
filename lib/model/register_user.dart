class RegisterUserModel {
  String name;
  String mobile;
  String email;
  String password;
  String username;

  RegisterUserModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.password,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Mobile'] = mobile;
    data['Email'] = email;
    data['Password'] = password;
    data['Username'] = username;
    return data;
  }
}
