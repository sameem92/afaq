import 'dart:ui' as ui;

import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/models/rental_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTheme {
  static const iSDEBUG = kDebugMode;
  static const String appName = "afaq";
  static const String appVersion = "v. 1.0.0";

  static String fcmTopicName = "Afaqtopic";
  static String serverKeyFCM =
      'AAAAFldyrLE:APA91bG3goVYUIx5hJaepqveT4uWj6FhNG47mNaPqaQfcrmY2Uh3EnjY8KuL2PUNt88FB3WaX7r_fZnESu4v2cw44zGtgTgB7kjIxX4vDLVzKirjiV0mFZC-t8Arc2B2ivFK0nnMXnhx';

  static const String webSite = "http://afaq.host";
  static String urlTermService = "http://afaq.host/";
  static String urlPolicy = 'http://afaq.host/';

  static String contentToShare =
      "Afaq \n\nWebsite: http://afaq.host/ @Copyrights 2022, protech\n";

  // ----------------- preference box box -------------
  static String prefDarkName = "darkmode";
  static String prefLangName = "langname";
  static String prefFirstTime = "firsttime";
  static String prefLogin = "loginkey";
  static String prefUuid = "uuidkey";
  static String prefInstall = "installkey";

  static String prefLatitude = "latitudekey";
  static String prefLocation = "locationkey";
  static String prefCountry = "countrykey";

  static String prefTokenFCM = "tokenFCMkey";
  static String prefMember = "memberkey";
  static String prefHome = "homekey";
  static String prefMyhobb = "myhobbkey";
  // ----------------- preference box box -------------

  static String noWA = "+6281293812628";

  // file uploaded reference
  static String image1 = "Image";
  static String image2 = "Image2";
  static String image3 = "Image3";

  // max comment on post data view
  static int maxViewComment = 5;
  static int pagePaging = 400; // 100 row per page
  static String pageLimit = "0,400"; // limit paging push

  static const double conerRadius = 28.0;

  static const iconColor = Color(0xffaf9594);

  static InputDecoration inputForm(final String hint, final Color fillColor) {
    return InputDecoration(
      hintText: hint,
      hintTextDirection: ui.TextDirection.rtl,
      filled: true,
      fillColor: fillColor,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(15),
      border: InputBorder.none,
    );
  }

  static InputDecoration inputFormAccent(
      final String hint, final Color fillColor, final Color accentColor) {
    return InputDecoration(
      hintText: hint,
      hintTextDirection: ui.TextDirection.rtl,
      filled: true,
      fillColor: fillColor,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: accentColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  static String basename(String path) {
    return path.split('/').last;
  }

  static sendWA(String phone, String text) {
    try {
      if (phone.length < 5) {
        EasyLoading.showToast("Phone Number invalid...");
        return;
      }
      if (phone.substring(0, 1) == '0') {
        phone = "+966" + phone.substring(1);
      }
      debugPrint(phone);
      launchUrl(
          Uri.parse("https://api.whatsapp.com/send?phone=$phone&text=$text"));
    } catch (e) {
      debugPrint("");
    }
  }

  static showToast(final String text) {
    EasyLoading.showToast(
      text,
    );
  }

  static showSnackbar(final String text) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(
      text,
      textDirection: ui.TextDirection.rtl,
    )));
  }

  static loadingCircular() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  static String formatCounterNumber(final int number) {
    var f = NumberFormat.compact();
    return f.format(number);
  }

  static bool isValidEmail(String email) => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);

  static String numberFormat(int number) {
    final NumberFormat numberFormat =
        NumberFormat.currency(symbol: "", decimalDigits: 0);

    return numberFormat.format(number);
  }

  static String numberFormatDec(double number, int digit) {
    final NumberFormat numberFormat =
        NumberFormat.currency(symbol: "", decimalDigits: digit);

    return numberFormat.format(number);
  }

  static createLatLngFromString(String latitude) {
    var split = latitude.split(",");
    return LatLng(double.parse(split[0]), double.parse(split[1]));
  }

  static int timeStamp(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(date);
    return dateTime.toLocal().millisecondsSinceEpoch;
  }

  static DateTime convertDatetime(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(date);
    return dateTime.toLocal(); //DateTime.now());
  }

  static String formatDateMemberSince(DateTime date) {
    var format = DateFormat("MMM yyyy");
    return format.format(date.toLocal()); //DateTime.now());
  }

  static String formatDatePost(DateTime date) {
    final MyPref myPref = MyPref.to;
    var format = DateFormat.yMMMMEEEEd();
    var formatHour =
        myPref.pLang.val == 'id' ? DateFormat('HH:mm') : DateFormat("hh:mm a");
    return "${format.format(date.toLocal())} ${formatHour.format(date.toLocal())}";
  }

  static Widget photoView(photoUrl) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: mainBackgroundcolor,
      ),
      body: Container(
        color: mainBackgroundcolor,
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.topLeft,
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: mainBackgroundcolor,
          ),
          loadingBuilder: (context, event) => const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          imageProvider: ExtendedNetworkImageProvider(
            '$photoUrl',
          ),
        ),
      ),
    );
  }

  static launchUrlGeo(String _url) async {
    try {
      debugPrint(_url);
      await canLaunchUrl(Uri.parse(_url))
          ? await launchUrl(Uri.parse(_url))
          : throw 'Could not launch $_url';
    } catch (e) {
      debugPrint("Error launchUrlGeo $e");
    }
  }
}

// ignore: avoid_print
logPrint(text) => MyTheme.iSDEBUG ? print(text) : "";

const myStorageName = "myStorageBox";

const backColor = Color(0xffd4dce4);
const mainBackgroundcolor = Color(0xD74297AA);
const mainBackgroundcolor2 = Color(0x864294A7);
const mainBackgroundcolor3 = Color(0xD54297AA);

const colorGrey = Color(0xffffffff);
const colorGrey2 = Color(0xffffffff);
const colorTrans1 = Color(0xffffffff);
const colorTrans2 = Color(0xffffffff);

const colorBoxShadow = Color(0xFF4297AA); //Color(0xffe2e2e2)
const colorBoxShadowGrey = Color(0xFFFFFFFF);

const EdgeInsets padding5 = EdgeInsets.all(5);
const EdgeInsets padding8 = EdgeInsets.all(8);

const TextStyle textBold = TextStyle(fontWeight: FontWeight.bold);
const TextStyle textNormal = TextStyle(fontSize: 14);
const TextStyle textSmall = TextStyle(
  fontSize: 11,
);
const TextStyle textSmallGrey = TextStyle(fontSize: 12, color: Colors.white);

const SizedBox spaceHeight2 = SizedBox(height: 2);
const SizedBox spaceHeight5 = SizedBox(height: 5);
const SizedBox spaceHeight10 = SizedBox(height: 10);
const SizedBox spaceHeight15 = SizedBox(height: 15);
const SizedBox spaceHeight20 = SizedBox(height: 20);
const SizedBox spaceHeight50 = SizedBox(height: 50);

const SizedBox spaceWidth2 = SizedBox(width: 2);
const SizedBox spaceWidth5 = SizedBox(width: 5);
const SizedBox spaceWidth10 = SizedBox(width: 10);
const SizedBox spaceWidth15 = SizedBox(width: 15);
const SizedBox spaceWidth20 = SizedBox(width: 20);
const SizedBox spaceWidth50 = SizedBox(width: 50);

RentalModel findRentalById(final String id) {
  final XController x = XController.to;
  final List<RentalModel> latests = x.itemHome.value.latests!;

  return latests.firstWhere((element) => element.id == id);
}

BoxDecoration boxDecorationGradientHome = const BoxDecoration(
  gradient: LinearGradient(
    //begin: Alignment.topCenter,
    //end: Alignment.bottomCenter,
    colors: [
      mainBackgroundcolor,
      mainBackgroundcolor2,
      mainBackgroundcolor3,
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topLeft,
  ),
);
