import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:talker/main.dart';
import 'package:talker/src/pages/all_talks_page.dart';
import 'package:talker/src/pages/talk_page.dart';
import 'package:talker/src/pages/talks_page.dart';
import 'package:talker/src/pages/top_talks_page.dart';
import 'package:talker/src/services/notify.dart';
import 'package:talker/src/widgets/action_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  late TabController _tabController;
  
  @override
  void initState(){
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if(message != null){
        _navigateToPage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      _navigateToPage(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      Notify().showSimpleNotification(title: message.notification!.title ?? "", body: message.notification!.body ?? "", chatId: message.data['chatId']);
    });

    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToPage(RemoteMessage message) {
    Navigator.push(
      navigatorKey.currentState!.context,
      MaterialPageRoute(builder: (context) => TalkPage(chatId: message.data['chatId'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromRGBO(52, 53, 65, 1),
      body: SafeArea(
        child: Column(
          children: [
            ActionBar(),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                    _tabController.animateTo(value);
                },
                children: [
                  TalksPage(),
                  AllTalksPage(),
                  TopTalksPage()
                ],
              ),
            ),
        ]
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(32, 33, 35, 1),
        child: TabBar(
          controller: _tabController,
          onTap: (value) {
            pageController.animateToPage(value, duration: Duration(milliseconds: 320), curve: Curves.decelerate);
          },
          indicator: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            color: Color.fromRGBO(255, 255, 255, 0.1)
          ),
          dividerColor: Color.fromRGBO(32, 33, 35, 1),
          splashFactory: NoSplash.splashFactory,
          tabs: [
            Tab(
              child: 
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Icon(Icons.chat, color: Colors.white,),
                      Text("Conversas", style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
            ),
            Tab(
              child: 
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Icon(Icons.question_answer, color: Colors.white,),
                      Text("Todos", style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
            ),
           Tab(
              child: 
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Icon(Icons.trending_up, color: Colors.white,),
                      Text("Top", style: TextStyle(color: Colors.white),)
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