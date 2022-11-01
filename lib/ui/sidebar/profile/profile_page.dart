import 'package:egorka/ui/sidebar/profile/profile_company.dart';
import 'package:egorka/ui/sidebar/profile/profile_delivery.dart';
import 'package:flutter/material.dart';

enum TypeUser { delivery, company }

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const type = TypeUser.delivery;

  @override
  Widget build(BuildContext context) {
    return type == TypeUser.delivery
        ? const DeliveryProfilePage()
        : const CompanyProfilePage();
  }
}
