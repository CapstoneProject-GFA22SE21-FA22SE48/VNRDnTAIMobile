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
    apiKey: 'AIzaSyCarue41zMMMeRgQS5TipT6ePT2H9kpsmc',
    appId: '1:212362228870:web:3295c5f06f0f9eb43d0d07',
    messagingSenderId: '212362228870',
    projectId: 'vnrdntai',
    authDomain: 'vnrdntai.firebaseapp.com',
    databaseURL: 'https://vnrdntai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'vnrdntai.appspot.com',
    measurementId: 'G-LBBVPZP0HR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEre7YKax4irpLfr0I2jrkACu_ZiBL3JU',
    appId: '1:212362228870:android:948373a28afb62e33d0d07',
    messagingSenderId: '212362228870',
    projectId: 'vnrdntai',
    databaseURL: 'https://vnrdntai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'vnrdntai.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOGp2_RR0Xd25YYXD6nsvsd76KvcTwRpc',
    appId: '1:212362228870:ios:8bcb65a87585d6143d0d07',
    messagingSenderId: '212362228870',
    projectId: 'vnrdntai',
    databaseURL: 'https://vnrdntai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'vnrdntai.appspot.com',
    iosClientId: '212362228870-85gt6h908oalmon7ud1f5a3cn58h1t5q.apps.googleusercontent.com',
    iosBundleId: 'com.example.vnrdnTai',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOGp2_RR0Xd25YYXD6nsvsd76KvcTwRpc',
    appId: '1:212362228870:ios:8bcb65a87585d6143d0d07',
    messagingSenderId: '212362228870',
    projectId: 'vnrdntai',
    databaseURL: 'https://vnrdntai-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'vnrdntai.appspot.com',
    iosClientId: '212362228870-85gt6h908oalmon7ud1f5a3cn58h1t5q.apps.googleusercontent.com',
    iosBundleId: 'com.example.vnrdnTai',
  );
}