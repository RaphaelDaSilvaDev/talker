class ChatModel {
  String id = "";
  final String title;
  final List<String> tags;
  final String createdBy;
  final DateTime createdAt = DateTime.now();
  int messageCount;

  ChatModel(
    this.title,
    this.createdBy,
    this.tags,
    this.messageCount
  );  

  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'tags': tags,
      'messageCount': messageCount,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map){
    return ChatModel(
      map['title'],
      map['createdBy'],
      List<String>.from(map['tags']),
      map['messageCount']
    );
  }
}