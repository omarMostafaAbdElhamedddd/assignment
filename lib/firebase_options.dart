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
    apiKey: 'AIzaSyA9E9ZyrHR8Dm_m9EKwliZcOTBKCv6AtSA',
    appId: '1:176966010861:web:740a09b21289d87660c9e4',
    messagingSenderId: '176966010861',
    projectId: 'assigment-33cbc',
    authDomain: 'assigment-33cbc.firebaseapp.com',
    storageBucket: 'assigment-33cbc.appspot.com',
    measurementId: 'G-ZSMMXVN8N7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA43RuAVg1FfG60KIMoKtRd84rI8oix2eU',
    appId: '1:176966010861:android:3b23ed57666e689960c9e4',
    messagingSenderId: '176966010861',
    projectId: 'assigment-33cbc',
    storageBucket: 'assigment-33cbc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtSgZmMmIVLfyoeaPwJ9oYW4-CbTvhtdo',
    appId: '1:176966010861:ios:8bd7af6476791c6260c9e4',
    messagingSenderId: '176966010861',
    projectId: 'assigment-33cbc',
    storageBucket: 'assigment-33cbc.appspot.com',
    iosBundleId: 'com.example.assignment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBtSgZmMmIVLfyoeaPwJ9oYW4-CbTvhtdo',
    appId: '1:176966010861:ios:eeee9cf322d4689760c9e4',
    messagingSenderId: '176966010861',
    projectId: 'assigment-33cbc',
    storageBucket: 'assigment-33cbc.appspot.com',
    iosBundleId: 'com.example.assignment.RunnerTests',
  );
}
