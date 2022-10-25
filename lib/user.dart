class User {
  final String id;
  final String email;
  final String first_name;
  final String last_name;
  final String avatar;
  User(
      {required this.id,
      required this.email,
      required this.avatar,
      required this.first_name,
      required this.last_name});

  User fromJson(json) => User(
        first_name: json['first_name'],
        last_name: json['last_name'],
        avatar: json['avatar'],
        id: json['id'],
        email: json['email'],
      );
}
