class UserModel {
  final String uId;
  final String username;
  final String email;
  final String phone;
  final String userImg;
  final String? userAddress;


  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.phone,
    required this.userImg,
    this.userAddress,
  });









  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'userImg': userImg,
      'userAddress': userAddress,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userImg: json['userImg'] ?? '',
      userAddress: json['userAddress'],
    );
  }

  UserModel copyWith({
    String? uId,
    String? username,
    String? email,
    String? phone,
    String? userAddress,
    String? userImg,
  }) {
    return UserModel(
      uId: uId ?? "",
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userAddress: userAddress ?? this.userAddress,
      userImg: userImg ?? this.userImg,
    );
  }
}



