class UpdateUserRequestModel {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? profileImageUrl;

  const UpdateUserRequestModel({
    this.firstName,
    this.lastName,
    this.phone,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
    };
  }
}
