
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class CombinedMessage extends types.Message {
  final types.TextMessage text;
  final types.ImageMessage image;
  final String? numOrder;

  CombinedMessage({
    required String messageId,
    required types.User authorId,
    required types.MessageType type,
    required this.text,
    required this.image,
    this.numOrder,
    required DateTime createdAt,
    bool isFromCurrentUser = false,
  }) : super(
          id:messageId,
          author: authorId,
          type: type,
        );


  @override
  types.Message copyWith({types.User? author, int? createdAt, String? id, Map<String, dynamic>? metadata, String? remoteId, types.Message? repliedMessage, String? roomId, bool? showStatus, types.Status? status, int? updatedAt}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }}