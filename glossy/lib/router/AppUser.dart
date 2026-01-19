class AppUser {
  final String userId;
  final String name;
  final String email;
  final String bio;
  final bool genderCd;
  final String hairType;
  final String iconUrl;
  final bool role;

  AppUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.bio,
    required this.genderCd,
    required this.hairType,
    required this.iconUrl,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'bio': bio,
      'gender_cd': genderCd,
      'hair_type': hairType,
      'icon_url': iconUrl,
      'role': role,
    };
  }
}