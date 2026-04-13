class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String vehicleNumber;
  final String emergencyContact;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl = '',
    this.vehicleNumber = '',
    this.emergencyContact = '',
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'vehicleNumber': vehicleNumber,
      'emergencyContact': emergencyContact,
    };
  }
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? vehicleNumber,
    String? emergencyContact,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }
  static UserModel getMockUser() {
    return UserModel(
      id: 'usr_001',
      name: 'Rahul Sharma',
      email: 'rahul.sharma@email.com',
      phone: '+91 98765 43210',
      profileImageUrl: '',
      vehicleNumber: 'MH 12 AB 1234',
      emergencyContact: '+91 91234 56789',
    );
  }
}