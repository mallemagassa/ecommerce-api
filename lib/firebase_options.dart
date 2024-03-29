// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAn0YVJDIG3edM9vOK2FNpWBJq7bf8X3CY',
    appId: '1:382410443875:web:4297b045d42337f6e3fc56',
    messagingSenderId: '382410443875',
    projectId: 'otp-phone-d6ab0',
    authDomain: 'otp-phone-d6ab0.firebaseapp.com',
    storageBucket: 'otp-phone-d6ab0.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5qalQKJ9IZ2DsGuuDAtJlDbEjLR4YDAk',
    appId: '1:382410443875:android:6dd18fdaf59c792ae3fc56',
    messagingSenderId: '382410443875',
    projectId: 'otp-phone-d6ab0',
    storageBucket: 'otp-phone-d6ab0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnGfS4DTeA2zXVb_v0nAKZ2L8KvQkVW80',
    appId: '1:382410443875:ios:be64aac6e0922578e3fc56',
    messagingSenderId: '382410443875',
    projectId: 'otp-phone-d6ab0',
    storageBucket: 'otp-phone-d6ab0.appspot.com',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnGfS4DTeA2zXVb_v0nAKZ2L8KvQkVW80',
    appId: '1:382410443875:ios:7b8c69e53ff1ac93e3fc56',
    messagingSenderId: '382410443875',
    projectId: 'otp-phone-d6ab0',
    storageBucket: 'otp-phone-d6ab0.appspot.com',
    iosBundleId: 'com.example.ecommerce.RunnerTests',
  );
}
