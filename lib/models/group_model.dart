class GroupModel {
  final String? id;
  final String? name;
  final List<dynamic>? members;
  final List<dynamic>? admins;
  final String? image;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? createdAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.admins,
    required this.image,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      name: json['name'],
      members: json['members'] ?? [],
      admins: json['admins'] ?? [],
      image: json['image'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'admins': admins,
      'image': image,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'created_at': createdAt,
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    List<String>? members,
    List<String>? admins,
    String? image,
    String? lastMessage,
    String? lastMessageTime,
    String? createdAt,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      admins: admins ?? this.admins,
      image: image ?? this.image,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
