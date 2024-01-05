// import 'package:onesignal_flutter/onesignal_flutter.dart';

// const oneSignalAppId = "0ab1065f-00b7-42fa-a238-cfd3821bc3bf";

// Future<void> initOneSignal() async {

//   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//   OneSignal.Debug.setAlertLevel(OSLogLevel.none);

//   OneSignal.initialize(oneSignalAppId);

//   // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   OneSignal.Notifications.requestPermission(true);
// }

// void registerOneSignalEventListener({
//   required Function(OSNotificationClickEvent  ) onOpened,
//   required Function(OSNotificationWillDisplayEvent) onReceivedInForeground,
// }) {

//   OneSignal.Notifications.addClickListener(onOpened);

//   // oneSignalShared
//   //     .setNotificationWillShowInForegroundHandler(onReceivedInForeground);
//   OneSignal.Notifications.addForegroundWillDisplayListener((onReceivedInForeground) {
//     onReceivedInForeground.preventDefault();

//     /// Do async work

//     /// notification.display() to display after preventing default
//     onReceivedInForeground.notification.display();

//   }); //s
// }



// const tagName = "userId";

// void sendUserTag(int userId) {
//   OneSignal.User.addTags({
//     'userId':userId,
//     'tagName':tagName,
//   }).then((response) {
//     print("Successfully sent tags with response");
//   }).catchError((error) {
//     print("Encountered an error sending tags: $error");
//   });
// }

// void deleteUserTag() {
//   OneSignal.User.removeTag(tagName).then((response) {
//     print("Successfully deleted tags with response ");
//   }).catchError((error) {
//     print("Encountered error deleting tag: $error");
//   });
// }
