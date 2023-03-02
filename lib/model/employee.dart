class Employee {
  String? id;
  String? name;
  String? surname;
  String? patronimic;
  String? username;
  String? email;
  String? phoneOffice;
  String? phoneMobile;
  bool? superUser;
  bool? status;

  Employee({
    required this.id,
    required this.name,
    required this.surname,
    required this.patronimic,
    required this.username,
    required this.email,
    required this.phoneOffice,
    required this.phoneMobile,
    required this.superUser,
    required this.status,
  });

  factory Employee.fromJson(Map<String, dynamic> data) {
    String? id = data['ID'];
    String? name = data['Name'];
    String? surname = data['Surname'];
    String? patronimic = data['Patronymic'];
    String? username = data['Username'];
    String? email = data['Email'];
    String? phoneOffice = data['PhoneOffice'];
    String? phoneMobile = data['PhoneMobile'];
    bool? superUser = data['Superuser'];
    bool? status = data['Password'];
    return Employee(
      id: id,
      name: name,
      surname: surname,
      username: username,
      patronimic: patronimic,
      email: email,
      phoneOffice: phoneOffice,
      phoneMobile: phoneMobile,
      superUser: superUser,
      status: status,
    );
  }

  // Map<String, dynamic> toJson() {
  //   Map<String, dynamic> data = {};
  //   data['Name'] = name;
  //   data['Surname'] = surname;
  //   data['Patronymic'] = patronimic;
  //   data['Mobile'] = phone;
  //   data['Email'] = email;
  //   data['Username'] = username;
  //   data['Password'] = password;
  //   return data;
  // }
}
