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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAR1F-vo0K0dVw04jWRTvj9YLCnphSQasM',
    appId: '1:606399324370:web:e06452d7e90f57711b8d0b',
    messagingSenderId: '606399324370',
    projectId: 'bu-news',
    authDomain: 'bu-news.firebaseapp.com',
    storageBucket: 'bu-news.appspot.com',
    measurementId: 'G-3YN325P5C0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-BsZ3VMxaU6TmViMyEIpXUrTRxQTpQ2I',
    appId: '1:606399324370:android:195339cdea1822e31b8d0b',
    messagingSenderId: '606399324370',
    projectId: 'bu-news',
    storageBucket: 'bu-news.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQ9LeGVgQqXnEgKQ1z_SQ8OFWEx7PYVg0',
    appId: '1:606399324370:ios:716d823d89cf9a6b1b8d0b',
    messagingSenderId: '606399324370',
    projectId: 'bu-news',
    storageBucket: 'bu-news.appspot.com',
    iosClientId: '606399324370-j1l74o8rd5snouje00doncphnb3ap2mb.apps.googleusercontent.com',
    iosBundleId: 'dev.kiishidart.buNews',
  );
}