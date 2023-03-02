class RegisterCompanyModel {
  String id;
  String company;
  String companyPhone;
  String companyEmail;
  String userMobile;
  String userEmail;
  String userPassword;

  RegisterCompanyModel({
    required this.id,
    required this.company,
    required this.companyPhone,
    required this.companyEmail,
    required this.userMobile,
    required this.userEmail,
    required this.userPassword,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['Company'] = company;
    data['CompanyPhone'] = companyPhone;
    data['CompanyEmail'] = companyEmail;
    data['UserMobile'] = userMobile;
    data['UserEmail'] = userEmail;
    data['UserPassword'] = userPassword;
    return data;
  }
}
