import 'package:flutter/material.dart';
import 'package:talker/src/models/chat_model.dart';
import 'package:talker/src/pages/create_talk_page.dart';
import 'package:talker/src/pages/talk_page.dart';
import 'package:talker/src/services/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:talker/src/widgets/talker_chat.dart';

class TalksPage extends StatefulWidget {
  const TalksPage({super.key});

  @override
  State<TalksPage> createState() => _TalksPageState();
}

class _TalksPageState extends State<TalksPage> {

  Widget getChats(){
    return StreamBuilder<List<ChatModel>>(
      stream: DatabaseFirebase().getMyChats(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}', style: TextStyle(fontSize: 18, color: Colors.white),));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhum chat encontrado', style: TextStyle(fontSize: 18, color: Colors.white),));
        }

        List<ChatModel> chats = snapshot.data!;
        
        return ListView.separated(
                padding: EdgeInsets.only(top: 20),
                itemCount: chats.length,
                itemBuilder: (context, index){
                  ChatModel chat = chats[index];
                  String date = DateFormat("dd/MM/yy - HH:mm").format(chat.createdAt);
                  return TalkerChat(title: chat.title, 
                      tag: chat.tags, 
                      answer: "${chat.messageCount} mensagens",
                      date: date, 
                      onTapFunction: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TalkPage(chatId: chat.id)));
                    },);
              },
              separatorBuilder: (_,_) => SizedBox(height: 14,),
              );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 53, 65, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: getChats(),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTalkPage()));
          }, 
          backgroundColor: Color.fromRGBO(16, 163, 127, 1),
          child: Icon(Icons.add, color: Colors.white,),
        ),
    );
  }
}