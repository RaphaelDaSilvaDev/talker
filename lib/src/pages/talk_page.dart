import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talker/src/models/message_model.dart';
import 'package:talker/src/services/auth.dart';
import 'package:talker/src/services/firebase_database.dart';
import 'package:talker/src/widgets/action_bar.dart';
import 'package:talker/src/widgets/input_message.dart';
import 'package:talker/src/widgets/my_message.dart';
import 'package:talker/src/widgets/other_message.dart';
import 'package:talker/src/widgets/system_message.dart';
import 'package:talker/src/widgets/talker_chat.dart';
import 'package:intl/intl.dart';

class TalkPage extends StatefulWidget {
  const TalkPage({super.key, required this.chatId});

  final chatId;

  @override
  State<TalkPage> createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  final ScrollController scrollController = ScrollController();
  final textController = TextEditingController(text: "");
  bool loadingButton = false;
  bool firstLoading = true;
  String chatTitle = "";
  List<String> chatTags = [];
  late User user;

  @protected
  @override
  void initState() {
    super.initState();
    getChatInfo();
    getUser();
  }

  void getChatInfo() async{
    print("TalkPage=${widget.chatId}");
    var chat = await DatabaseFirebase().getChatInto(widget.chatId);
    setState(() {
      chatTitle = chat.title;
      chatTags = chat.tags;
    });
  }

  void getUser() async{
    user = (await AuthServer().isAuthenticated())!;
  }

  Widget getAllMessage(){
    return StreamBuilder<List<MessageModel>>(
      stream: DatabaseFirebase().getMessagesByChat(widget.chatId), 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting && firstLoading){
          firstLoading = false;
          return Center(child: CircularProgressIndicator(),);
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Inicie o assunto", style: TextStyle(fontSize: 18, color: Colors.white),),);
        }

        List<MessageModel> messages = snapshot.data!;
        moveScrollToBottom();

        return ListView.separated(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 16),
                  itemCount: messages.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    MessageModel message = messages[index];
                    String date = DateFormat("HH:mm").format(message.createdAt);
                    if(message.createdBy == user.uid){
                      return MyMessage(text: message.text, date: date);
                    } else if(message.createdBy == "system"){
                      return SystemMessage(text: message.text);
                    }else{
                      return OtherMessage(text: message.text, date: date, username: message.user?.username ?? "");
                    }
                  },
                  separatorBuilder: (_, _) => SizedBox(height: 14,),
                );
      }
    );
  }

  void sendMessage() async{
    if(textController.text.trim().isNotEmpty){  
      setState(() {
        loadingButton = true;
      });
      DatabaseFirebase().createMessage(textController.text, widget.chatId);
      moveScrollToBottom();
      textController.text = "";
      setState(() {
        loadingButton = false;
      });
    }
  }

  void moveScrollToBottom(){
    Future.delayed(Duration(milliseconds: 75), () {
        scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 53, 65, 1),
      body: SafeArea(
        child: Column(
          children: [
            ActionBar(withBackButton: true),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TalkerChat(title: chatTitle, tag: chatTags),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: getAllMessage()
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              child: InputMessage(inputController: textController, hintText: "Mensagem", submitted: (){
                sendMessage();
              },),
            )
          ],
        ),
      ),
    );
  }
}