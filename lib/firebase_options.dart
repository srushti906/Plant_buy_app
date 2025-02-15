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
        return windows;
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
    apiKey: 'AIzaSyCjiD7U4D0nK0WjglVxFWDFv8as-C2pQmE',
    appId: '1:472341388547:web:94b48210d9a918cfa3dd36',
    messagingSenderId: '472341388547',
    projectId: 'greensquare-c7657',
    authDomain: 'greensquare-c7657.firebaseapp.com',
    storageBucket: 'greensquare-c7657.appspot.com',
    measurementId: 'G-JX152WFER7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTErtyWDfVllr0EFPrCwulI4JOpXnlXSI',
    appId: '1:472341388547:android:bc70ad416a57157da3dd36',
    messagingSenderId: '472341388547',
    projectId: 'greensquare-c7657',
    storageBucket: 'greensquare-c7657.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3LrOCekydbOdIve_rz-6_xD7OkdeIYXk',
    appId: '1:472341388547:ios:5d7e480e0ab51ca0a3dd36',
    messagingSenderId: '472341388547',
    projectId: 'greensquare-c7657',
    storageBucket: 'greensquare-c7657.appspot.com',
    iosBundleId: 'com.vatsalraj.greenSquare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC3LrOCekydbOdIve_rz-6_xD7OkdeIYXk',
    appId: '1:472341388547:ios:5d7e480e0ab51ca0a3dd36',
    messagingSenderId: '472341388547',
    projectId: 'greensquare-c7657',
    storageBucket: 'greensquare-c7657.appspot.com',
    iosBundleId: 'com.vatsalraj.greenSquare',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCjiD7U4D0nK0WjglVxFWDFv8as-C2pQmE',
    appId: '1:472341388547:web:fbdca759a5b9c98ca3dd36',
    messagingSenderId: '472341388547',
    projectId: 'greensquare-c7657',
    authDomain: 'greensquare-c7657.firebaseapp.com',
    storageBucket: 'greensquare-c7657.appspot.com',
    measurementId: 'G-H62VV6QHVY',
  );
}
