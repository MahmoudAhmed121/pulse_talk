class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? about;
  final String? createdAt;
  final String? pushToken;
  final String? imageUrl;
  final String? lastSeen;
  final bool? online;
  final List? myUsers;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.createdAt,
    required this.pushToken,
    required this.imageUrl,
    required this.lastSeen,
    required this.online,
    required this.myUsers,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        about: json['about'],
        createdAt: json['created_at'],
        pushToken: json['push_token'],
        imageUrl: json['image_url'],
        lastSeen: json['last_seen'],
        online: json['online'],
        myUsers: json['my_users']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'about': about,
      'created_at': createdAt,
      'push_token': pushToken,
      'image_url': imageUrl,
      'last_seen': lastSeen,
      'online': online,
      'my_users': myUsers,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? about,
    String? createdAt,
    String? pushToken,
    String? imageUrl,
    String? lastSeen,
    bool? online,
    List? myUsers,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
      createdAt: createdAt ?? this.createdAt,
      pushToken: pushToken ?? this.pushToken,
      imageUrl: imageUrl ?? this.imageUrl,
      lastSeen: lastSeen ?? this.lastSeen,
      online: online ?? this.online,
      myUsers: myUsers ?? this.myUsers,
    );
  }
}
