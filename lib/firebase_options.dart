import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC_swAcsg5AZDcC3tWn_n0peRXmYnWaL3A',
    appId: '1:169582136982:android:6093db1ddc48abea66bcb7',
    messagingSenderId: '169582136982',
    projectId: 'ostad-batch-six',
    databaseURL: 'https://ostad-batch-six-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ostad-batch-six.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLUsTiuPI3g7sQV4xr_mHhOHZdUgRKLCM',
    appId: '1:169582136982:ios:aa18789eb921007d66bcb7',
    messagingSenderId: '169582136982',
    projectId: 'ostad-batch-six',
    databaseURL: 'https://ostad-batch-six-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ostad-batch-six.firebasestorage.app',
    iosBundleId: 'com.ostad.eCommerce',
  );
}
