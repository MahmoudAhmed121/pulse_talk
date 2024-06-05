class MessageModel {
  final String? id;
  final String? toId;
  final String? fromId;
  final String? msg;
  final String? createdAt;
  final String? type;
  final String? read;

  MessageModel({
    required this.id,
    required this.toId,
    required this.fromId,
    required this.msg,
    required this.createdAt,
    required this.type,
    required this.read,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      toId: json['toId'],
      fromId: json['fromId'],
      msg: json['msg'],
      createdAt: json['created_at'],
      type: json['type'],
      read: json['read'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'toId': toId,
      'fromId': fromId,
      'msg': msg,
      'created_at': createdAt,
      'type': type,
      'read': read,
    };
  }

  MessageModel copyWith({
    String? id,
    String? toId,
    String? fromId,
    String? msg,
    String? createdAt,
    String? type,
    String? read,
  }) {
    return MessageModel(
      id: id ?? this.id,
      toId: toId ?? this.toId,
      fromId: fromId ?? this.fromId,
      msg: msg ?? this.msg,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      read: read ?? this.read,
    );
  }
}
