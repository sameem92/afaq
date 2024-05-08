import 'dart:async';
import 'dart:io';

import 'package:Afaq/app/my_home.dart';
import 'package:Afaq/auth/intro_screen.dart';
import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
  if (message.messageId != null && message.messageId != '') {
    try {
      Future.microtask(() async {
        await GetStorage.init(myStorageName);

        //Get.put(MyPref());
        Get.lazyPut<MyPref>(() => MyPref());
        Get.lazyPut<XController>(() => XController());
      });
    } catch (e) {
      debugPrint("Error _firebaseMessagingBackgroundHandler111: $e");
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init(myStorageName);

  Get.lazyPut<MyPref>(() => MyPref());
  Get.lazyPut<XController>(() => XController());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final XController x = XController.to;
    x.asyncHome();
    //inerval for next 22 minutes
    Timer.periodic(const Duration(minutes: 22), (timer) {
      x.asyncHome();
    });
    FlutterNativeSplash.removeAfter(init);

    return runApp(const MyApp());
  });
}

Future init(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 2));
}

final fontFamily = GoogleFonts.poppins().fontFamily;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Color statusColor = mainBackgroundcolor;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: statusColor,
      statusBarColor: statusColor,
      // Android Only
      statusBarIconBrightness: Brightness.dark,

      //iOS only
      statusBarBrightness: Brightness.light,
    ));

    final MyPref myPref = MyPref.to;
    String lang = myPref.pLang.val.toLowerCase();
    Locale locale =
        lang == 'id' ? const Locale('id', 'ID') : const Locale('en', 'US');

    return GetMaterialApp(
      // translations: MessagesTranslation(),
      locale: locale,
      // fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Afaq Realstates',
      // textDirection:TextDirection.rtl
      //
      //   ,

      theme: ThemeData(
        primaryColor: Color(0xFF4297AA),
        fontFamily: fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardColor: backColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Color(0xFF4297AA),
        ),
      ),
      home: myPref.pLogin.val ? MyHome() : IntroScreen(),
      builder: (BuildContext? context, Widget? child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
