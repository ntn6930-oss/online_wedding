import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'YOUR_ANDROID_API_KEY',
          appId: 'YOUR_ANDROID_APP_ID',
          messagingSenderId: 'YOUR_ANDROID_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_IOS_API_KEY',
          appId: 'YOUR_IOS_APP_ID',
          messagingSenderId: 'YOUR_IOS_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
          iosBundleId: 'com.example.onlineWedding',
        );
      case TargetPlatform.macOS:
        return const FirebaseOptions(
          apiKey: 'YOUR_MAC_API_KEY',
          appId: 'YOUR_MAC_APP_ID',
          messagingSenderId: 'YOUR_MAC_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
          iosBundleId: 'com.example.onlineWedding',
        );
      case TargetPlatform.windows:
        return const FirebaseOptions(
          apiKey: 'YOUR_WINDOWS_API_KEY',
          appId: 'YOUR_WINDOWS_APP_ID',
          messagingSenderId: 'YOUR_WINDOWS_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      case TargetPlatform.linux:
        return const FirebaseOptions(
          apiKey: 'YOUR_LINUX_API_KEY',
          appId: 'YOUR_LINUX_APP_ID',
          messagingSenderId: 'YOUR_LINUX_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
      default:
        return const FirebaseOptions(
          apiKey: 'YOUR_WEB_API_KEY',
          appId: 'YOUR_WEB_APP_ID',
          messagingSenderId: 'YOUR_WEB_SENDER_ID',
          projectId: 'YOUR_PROJECT_ID',
          storageBucket: 'YOUR_STORAGE_BUCKET',
        );
    }
  }
}
