import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:talker/main.dart';
import 'package:talker/src/pages/talk_page.dart';
import 'package:talker/src/services/firebase_database.dart';
import 'package:http/http.dart' as http;

class Notify {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  void initNotify() async {

    const initSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification_icon');

    const initSettingsIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos
    );

   await notificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: (NotificationResponse response) async{
    if(response.payload != null){
      Navigator.push(
      navigatorKey.currentState!.context,
      MaterialPageRoute(builder: (context) => TalkPage(chatId: response.payload)),
    );
    }
   });
  }

  NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "new_message_channel_id", 
        "New Message",
        channelDescription: "New message channel",
        importance: Importance.max,
        priority: Priority.high,
        color: Color.fromRGBO(16, 163, 127, 1),
        colorized: true,
      ),
      iOS: DarwinNotificationDetails()
    );
  }

  void showSimpleNotification({int id = 1, required String title, required String body, required String chatId}) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: chatId 
    );
  }

  void getUserToken() async{
    final token = await FirebaseMessaging.instance.getToken();
    DatabaseFirebase().saveToken(token!); 
  }

  void sendNotification({required String body, required String senderName, required String chatId , required String receiverToken}) async{

   final String serverToken = "ya29.a0AeXRPp4x5GDcwH3dpIxuW5OKTGcT2Ruj4F54S4r0jjdCNWTLKRW6z6XFvj3EVCkV462Kp9-O_MItm9dfh310BnKkks4eCq7ZQ6PwW91G2ciM1qXTndSHJa6SFLuaaQGxzNCi-MiQ4cvFsNSsva0QClYye9VRVEGclcwlKNAZaCgYKAccSARISFQHGX2MiNXjTT0w2KTcieIB6mb1Vow0175";
    final String projectId = "talker-83bdf";

    final url = Uri.parse("https://fcm.googleapis.com/v1/projects/$projectId/messages:send");
    
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $serverToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "message": {
          "token": receiverToken,
          "notification": {
            'body': body,
            'title': 'Nova mensagem de: $senderName',
          },
          "data": {
            "chatId": chatId
          },
        }
      }),
    );

    if (response.statusCode == 200) {
      print("Notificação enviada com sucesso!");
    } else {
      print("Erro ao enviar notificação: ${response.body}");
    }
  }
}