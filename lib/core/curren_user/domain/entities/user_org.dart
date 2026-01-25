class UserOrg {
  final int organizationId;
  final String role;
  final String ? organizationName;

  UserOrg({
    required this.organizationId,
    required this.role, this.organizationName,
  });
}