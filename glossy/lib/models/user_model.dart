class UserModel {
  final String uid;
  final String name;
  final String? iconUrl;

  UserModel({
    required this.uid,
    required this.name,
    this.iconUrl,
  });
}