import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:reporter/firebase_api/token_repository.dart';
import 'package:reporter/services/user_service.dart';

import '../services/notification_service.dart';

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    TokenRepository.saveTokenToUserCollection(fcmToken!);
    FirebaseMessaging.onBackgroundMessage(handler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('MESSAGE');
      // if (message.notification != null){
      //   NotificationService.showNotification(
      //     title: message.notification!.title ?? "No title",
      //     body: message.notification!.body ?? "No body",
      //   );
      // }
    });

    print(fcmToken);
  }
}

Future<void> handler(RemoteMessage message) async{
  // if (message.notification != null){
  //   NotificationService.showNotification(
  //     title: message.notification!.title ?? "No title",
  //     body: message.notification!.body ?? "No body",
  //   );
  //}
}