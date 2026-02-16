class ExtractedIdCardData {
  final String firstName;
  final String lastName;
  final String? nationalId;
  final String? address;
  final String? birthDate;
  final String? photoPath;

  const ExtractedIdCardData({
    required this.firstName,
    required this.lastName,
    this.nationalId,
    this.address,
    this.birthDate,
    this.photoPath,
  });

  factory ExtractedIdCardData.fromMap(Map<String, String> map) {
    return ExtractedIdCardData(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      nationalId: map['nid'],
      address: map['address'],
      birthDate: map['dob'],
      photoPath: map['photo'],
    );
  }

  bool get hasValidName => firstName.isNotEmpty && lastName.isNotEmpty;
}