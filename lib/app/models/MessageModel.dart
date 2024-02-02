import 'dart:typed_data';

class MessageModel{

  final int? id;
  final int senderId;
  final int receiverId;
  final String? type;
  final String? media;
  final String? text;
  final String? video;
  final String? document;
  final String? numOrder;
  final int? conversationId;
  int? size;


  MessageModel({
    this.id,
    required this.senderId, 
    required this.receiverId, 
    this.type, 
    this.media, 
    this.text, 
    this.video, 
    this.document, 
    this.numOrder, 
    this.conversationId,
    this.size,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int?,
      senderId: json['sender_id'] as int,
      receiverId: json['receiver_id'] as int,
      type: json['type'] as String,
      media: json['media'] as String?,
      text: json['text'] as String?,
      document: json['document'] as String?,
      numOrder: json['numOrder'] as String?,
      conversationId: json['conversation_id'] as int?,
    );
  }

  
}