class Contact {
  String? name;
  String? department;
  String? phoneMobile;
  String? phoneOffice;
  String? phoneOfficeAdd;
  String? emailPersonal;
  String? emailOffice;

  Contact(
      {this.name,
      this.department,
      this.phoneMobile,
      this.phoneOffice,
      this.phoneOfficeAdd,
      this.emailPersonal,
      this.emailOffice});

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    department = json['Department'];
    phoneMobile = json['PhoneMobile'];
    phoneOffice = json['PhoneOffice'];
    phoneOfficeAdd = json['PhoneOfficeAdd'];
    emailPersonal = json['EmailPersonal'];
    emailOffice = json['EmailOffice'];
  }

  Map<String, dynamic> toJson() {    
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Department'] = department;
    data['PhoneMobile'] = phoneMobile;
    data['PhoneOffice'] = phoneOffice;
    data['PhoneOfficeAdd'] = phoneOfficeAdd;
    data['EmailPersonal'] = emailPersonal;
    data['EmailOffice'] = emailOffice;
    return data;
  }
}
