// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADJqpQoRiLiBzYLh4Ij_fHvNhy9zIEYeM',
    appId: '1:344088867271:android:c3739665799829675529e2',
    messagingSenderId: '344088867271',
    projectId: 'beehive-startup',
    storageBucket: 'beehive-startup.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAx2uRL3OsCRwRxhPAj0_Daj1BsL8q-Uws',
    appId: '1:344088867271:ios:9aca466674f2731d5529e2',
    messagingSenderId: '344088867271',
    projectId: 'beehive-startup',
    storageBucket: 'beehive-startup.firebasestorage.app',
    androidClientId: '344088867271-jv4eros525a43il6ukb373kv0f19p1bg.apps.googleusercontent.com',
    iosClientId: '344088867271-s8o0524sulkbdv7j5eq31g0m86jg628b.apps.googleusercontent.com',
    iosBundleId: 'com.example.ulearningApp',
  );

}