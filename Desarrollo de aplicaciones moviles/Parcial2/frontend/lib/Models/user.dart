class UserModel {
  String email;
  String name;
  String phoneNumber;
  String position;
  String photoUrl;
  String password;

  UserModel({
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.position,
    required this.photoUrl,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      position: json['position'],
      photoUrl: json['photoUrl'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'phoneNumber': phoneNumber,
        'position': position,
        'photoUrl': photoUrl,
        'password': password,
      };
}

class ProfileUserModel extends UserModel {
  ProfileUserModel({
    required String email,
    required String name,
    required String phoneNumber,
    required String position,
    required String photoUrl,
  }) : super(
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          position: position,
          photoUrl: photoUrl,
          password: '',
        );

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      position: json['position'],
      photoUrl: json['photoUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'phoneNumber': phoneNumber,
        'position': position,
        'photoUrl': photoUrl,
        'password': password,
      };
}

class LoginUserModel extends UserModel {
  LoginUserModel({
    required String email,
    required String password,
  }) : super(
          email: email,
          name: '',
          phoneNumber: '',
          position: '',
          photoUrl: '',
          password: password,
        );

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(email: json['email'], password: json['password']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
