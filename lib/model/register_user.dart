class RegisterUserModel {
  String name;
  String mobile;
  String email;
  String password;

  RegisterUserModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Mobile'] = mobile;
    data['Email'] = email;
    data['Password'] = password;
    return data;
  }
}
