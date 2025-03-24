import 'package:flutter/material.dart';
import 'package:talker/src/pages/talk_page.dart';
import 'package:talker/src/services/firebase_database.dart';
import 'package:talker/src/widgets/action_bar.dart';
import 'package:talker/src/widgets/button_simple.dart';
import 'package:talker/src/widgets/input_text.dart';

class CreateTalkPage extends StatefulWidget {
  const CreateTalkPage({super.key});

  @override
  State<CreateTalkPage> createState() => _CreateTalkPageState();
}

class _CreateTalkPageState extends State<CreateTalkPage> {
  final titleController = TextEditingController(text: "");
  final tagController = TextEditingController(text: "");

  void createChat() async{
    await DatabaseFirebase().createChat(titleController.text, [tagController.text]).then((String chatUid){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TalkPage(chatId: chatUid)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(52, 53, 65, 1),
      body: SafeArea(
        child: Column(
          children: [
            const ActionBar(withBackButton: true,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  children: [
                    InputText(inputController: titleController, hintText: "Título do Post"),
                    SizedBox(
                      height: 20,
                    ),
                    InputText(inputController: tagController, hintText: "Tags do Post"),
                    Spacer(),
                    ButtonSimple(text: "Criar Post", onPressed: createChat),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}