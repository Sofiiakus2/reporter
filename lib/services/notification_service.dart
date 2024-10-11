import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';


class NotificationService{
  static Future<void> initializeANotification() async{
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel',
          channelKey: 'basic_channel',
          channelName: 'Basic Notification',
          channelDescription: 'Notification channel for basic test',
          defaultColor: const Color(0xFFCB395C),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Group 1'),
      ],
      debug: true,
    );

    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint("onNotificationCreatedMethod");
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint("onNotificationDisplayedMethod");
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint("onDismissActionReceivedMethod");
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint("onActionReceivedMethod");
    final payload = receivedAction.payload ?? {};
    // if (payload["navigate"] == "true") {
    //   MainApp.navigatorKey.currentState?.push()
    //}
  }

  static Future<void> cancelNotificationByTripID(String tripID) async {
    List<NotificationModel> notifications =
    await AwesomeNotifications().listScheduledNotifications();

    for (var notification in notifications) {
      if (notification.content!.payload!['tripID'] == tripID) {
        await AwesomeNotifications().cancel(notification.content!.id!);
      }
    }
  }

  static int generateUniqueID() {
    final now = DateTime.now();
    final String idString =
        '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}'
        '${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}'
        '${now.millisecond.toString().padLeft(3, '0')}';
    return idString.hashCode & 0x7FFFFFFF;
  }

  static String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final DateTime? scheduledDateTime,
  }) async {
    assert(!scheduled || (scheduled && scheduledDateTime != null));

    final int uniqueId = generateUniqueID();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: uniqueId,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar.fromDate(date: scheduledDateTime!)
          : null,
    );
  }
}