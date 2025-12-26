// class UserModel {
//   final String id;
//   final String email;
//   final String fullName;  // Your table has 'fullName' not 'full_name'
//   final String? profileImage;
//   final DateTime createdAt;
//
//   UserModel({
//     required this.id,
//     required this.email,
//     required this.fullName,
//     this.profileImage,
//     required this.createdAt,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] as String,
//       email: json['email'] as String,
//       fullName: json['fullName'] as String,  // Changed from 'full_name'
//       profileImage: json['profileImage'] as String?,
//       createdAt: DateTime.parse(json['createdAt'] as String),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'fullName': fullName,  // Changed from 'full_name'
//       'profileImage': profileImage,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }
// }
class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? profileImage;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.profileImage,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      profileImage: json['profileImage'] as String?,
      // Try both 'createdAt' and 'created_at' to handle both cases
      createdAt: DateTime.parse(
        (json['createdAt'] ?? json['created_at']) as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'profileImage': profileImage,
      'created_at': createdAt.toIso8601String(), // Use 'created_at' with underscore
    };
  }
}