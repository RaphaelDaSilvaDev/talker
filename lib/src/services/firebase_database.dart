import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:talker/src/models/chat_model.dart';
import 'package:talker/src/models/message_model.dart';
import 'package:talker/src/models/user_model.dart';
import 'package:talker/src/services/auth.dart';
import 'package:talker/src/services/notify.dart';

class DatabaseFirebase {
  final _database = FirebaseDatabase.instance;
  final _firestore = FirebaseFirestore.instance;
  final user = AuthServer().getUser();

  Future<void> createUser(String username, String email, String id) async{
    DatabaseReference ref = _database.ref("users/$id");

    UserModel user = UserModel(email, username, "");

    await ref.set(user.toMap());
    Notify().getUserToken();
  }

  Future<UserModel?> getUserById(String userId) async{
    DataSnapshot ref = await _database.ref("users/$userId").get();
    var user;
    if(ref.exists){
      user = UserModel.fromMap(Map<String, dynamic>.from(ref.value as Map));
    }

    return user;
  }

  Future<void> saveToken(String token) async{
    await _database.ref("users/${user?.uid}").update({'token': token});
  }

  Future<String> createChat(String title, List<String>tags) async{
    var user = await AuthServer().isAuthenticated();
    ChatModel chat = ChatModel(title, user?.uid ?? "", tags, 0);
    var chatRef = await _firestore.collection('chatroom').add(chat.toMap());
    MessageModel message = MessageModel(createdBy: "system" , text:  "Bem vindo ao $title", createdAt: DateTime.now());
    await _firestore.collection('chatroom').doc(chatRef.id).collection("messages").add(message.toMap());
    
    return chatRef.id;
  }

  Future<ChatModel> getChatInto(String chatId) async{
    print("firebase=$chatId");
    var getChat = await _firestore.collection("chatroom").doc(chatId).get();
    ChatModel chat = ChatModel.fromMap(Map<String, dynamic>.from(getChat.data()!));
    return chat;
  }

  Stream<List<ChatModel>> getAllChat(){
    return _firestore.collection("chatroom").snapshots().map((snapshot) {
      return snapshot.docs.map((doc){
        final chatDoc = doc.data();
        final chatId = doc.id;
        ChatModel chat = ChatModel.fromMap(Map<String, dynamic>.from(chatDoc));
        chat.id = chatId;
        return chat;
      }).toList();
    });
  }

  Stream<List<ChatModel>> getMyChats() async* {
  List<String> chatsItens = [];
   DatabaseReference databaseRef = _database.ref().child('chat_user');
  
  DatabaseEvent event = await databaseRef.once();
  if (event.snapshot.exists) {
    Map<dynamic, dynamic> chats = event.snapshot.value as Map<dynamic, dynamic>;
    
    chats.forEach((chatId, chatData) {
      Map<dynamic, dynamic> usersInChat = Map.from(chatData);
      
      if (usersInChat.containsValue(user?.uid)) {
        chatsItens.add(chatId);
      }
    });
  }

  yield* _firestore.collection("chatroom")
      .where(FieldPath.documentId, whereIn: chatsItens)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final chatDoc = doc.data();
          final chatId = doc.id;
          ChatModel chat = ChatModel.fromMap(Map<String, dynamic>.from(chatDoc));
          chat.id = chatId;
          return chat;
        }).toList();
      });
  }

  void createMessage(String text, String chatId) async{
    var user = await AuthServer().isAuthenticated();

    await _firestore.collection("chatroom").doc(chatId).update({
      "messageCount": FieldValue.increment(1) 
    });

    MessageModel message = MessageModel(createdBy: user?.uid ?? "", text:  text, createdAt: DateTime.now());
    await _firestore.collection('chatroom')
                    .doc(chatId).collection("messages")
                    .add(message.toMap());
    
    addUserToChatIfNotExists(chatId, user?.uid ?? "");
    getUsersToNotificate(chatId, text);
  }

  Future<void> addUserToChatIfNotExists(String chatId, String userId) async {
    DatabaseReference database = _database.ref();

    // Busca se o usuário já está presente no chat
    DatabaseEvent event = await database.child("chat_user/$chatId")
        .orderByValue()
        .equalTo(userId)
        .once();

    if (!event.snapshot.exists) {
      await database.child("chat_user/$chatId").push().set(userId);
    }
  }

  Stream<List<MessageModel>> getMessagesByChat(String chatId){
    return _firestore.collection("chatroom").doc(chatId).collection("messages").orderBy("createdAt", descending: false).snapshots().asyncMap((snapshot){
      return Future.wait(snapshot.docs.map((doc) async{
        final messageDoc = doc.data();
        final userId = messageDoc["createdBy"];

        final UserModel? user = await getUserById(userId);

        MessageModel message = MessageModel.fromMap(Map<String, dynamic>.from(messageDoc));
        message.user = user;
        return message;
      }).toList());
    });
  }

  void getUsersToNotificate(String chatId, String message) async{
    var usersIds = [];
    
    DatabaseReference databaseRef = _database.ref();
    DataSnapshot snapshot = await databaseRef.child("chat_user/$chatId").get();
    if(snapshot.exists){
      usersIds.addAll(snapshot.children.map((child){
        return child.value.toString();
      }));
    }

    var senderUser = await getUserById(user?.uid ?? "");

    for(String userId in usersIds){
      var userToNotify = await getUserById(userId);
      if(userId != user?.uid){
        Notify().sendNotification(body: message, senderName: senderUser?.username ?? "", chatId: chatId, receiverToken: userToNotify?.token ?? "");
      }
    }

  }
}