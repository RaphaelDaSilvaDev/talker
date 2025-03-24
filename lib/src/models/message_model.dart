import 'package:talker/src/models/user_model.dart';

class MessageModel {
  String id = "";
  final String text;
  final String createdBy;
  DateTime createdAt;
  UserModel? user;

  MessageModel({
    required this.createdBy,
    required this.text,
    required this.createdAt,
    this.user
    }
  );

  Map<String, dynamic> toMap(){
    return{
      'text': text,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map){
    return MessageModel(
      createdBy: map['createdBy'],
      text: map['text'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}