import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/features/profile/presentation/widgets/info_card.dart';

class FirstNameCard extends StatelessWidget {
  final String firstNameAr;

  const FirstNameCard({super.key, required this.firstNameAr});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.person,
      label: 'First Name',
      value: firstNameAr,
      onEdit: null,
      //showEditDialog(
      //   context,
      //   'First Name',
      //   firstNameAr,
      //   (newValue) => context.read<UserProfileCubit>().updateUser(
      //         firstNameAr: newValue,
      //       ),
      // ),
    );
  }
}

class FullNameCard extends StatelessWidget {
  final String fullName;

  const FullNameCard({super.key, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.person,
      label: 'profile.field_full_name'.tr(),
      value: fullName,
      onEdit: null,
      //showEditDialog(
      //   context,
      //   'First Name',
      //   firstNameAr,
      //   (newValue) => context.read<UserProfileCubit>().updateUser(
      //         firstNameAr: newValue,
      //       ),
      // ),
    );
  }
}

class OrganizationNameCard extends StatelessWidget {
  final String organizationName;

  const OrganizationNameCard({super.key, required this.organizationName});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.business,
      label: 'profile.field_organization'.tr(),
      value: organizationName,
      onEdit: null,
    );
  }
}

class CollageCardId extends StatelessWidget {
  final String collageCardId;

  const CollageCardId({super.key, required this.collageCardId});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.badge,
      label: 'profile.field_college_card_id'.tr(),
      value: collageCardId,
      onEdit: null,
    );
  }
}

class LastNameCard extends StatelessWidget {
  final String lastNameAr;

  const LastNameCard({super.key, required this.lastNameAr});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.person_outline,
      label: 'Last Name',
      value: lastNameAr,
      onEdit: null,
      // () => showEditDialog(
      //   context,
      //   'Last Name',
      //   lastNameAr,
      //   (newValue) =>
      //       context.read<UserProfileCubit>().updateUser(lastNameAr: newValue),
      // ),
    );
  }
}

class EmailCard extends StatelessWidget {
  final String email;

  const EmailCard({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.email,
      label: 'profile.field_email'.tr(),
      value: email,
      onEdit: null,
      // () => showEditDialog(
      //   context,
      //   'Email',
      //   email,
      //   (newValue) =>
      //       context.read<UserProfileCubit>().updateUser(email: newValue),
      // ),
    );
  }
}

class NationalIdCard extends StatelessWidget {
  final String nationalId;

  const NationalIdCard({super.key, required this.nationalId});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      icon: Icons.badge,
      label: 'National ID',
      value: nationalId,
      onEdit: null,
    );
  }
}
