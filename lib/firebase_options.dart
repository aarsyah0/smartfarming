import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyBB40eRLlP7kp52g2Hvmx3PkrkzYjuFnpo',
      appId: '1:350710840656:android:d577c4c2427682b2408055',
      messagingSenderId: '350710840656',
      projectId: 'smartfarming-7bd96',
      databaseURL: 'https://smartfarming-7bd96-default-rtdb.firebaseio.com',
      storageBucket: 'smartfarming-7bd96.firebasestorage.app',
    );
  }
} 