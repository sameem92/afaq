import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Afaq/auth/intro_screen.dart';
import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/size_config.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/models/user_model.dart';
import 'package:Afaq/pages/feedback_page.dart';
import 'package:Afaq/pages/webview_page.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/action_menu.dart';
import 'package:Afaq/widgets/crop_editor_helper.dart';
import 'package:Afaq/widgets/icon_back.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  final XController x = XController.to;
  final MyPref myPref = MyPref.to;

  ProfileScreen({Key? key}) : super(key: key) {
    updateUser.value = x.thisUser.value;
  }

  final updateUser = UserModel().obs;

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: mainBackgroundcolor,
        title: topIcon(),
        elevation: 0.1,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getProportionateScreenHeight(25)),
              Container(
                alignment: Alignment.center,
                child: Obx(
                  () => profileIcon(updateUser.value),
                ),
              ),
              spaceHeight15,
              Obx(
                () => displayUserProfile(updateUser.value),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.white70,
                    elevation: 0.5,
                  ),
                  // onPressed: press,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              () => (WebViewPage(
                                  url: 'https://wa.me/966580009872')),
                              transition: Transition.fadeIn);
                        },
                        child: FaIcon(FontAwesomeIcons.whatsapp,
                            color: Color(0xFF4297AA)),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              () => WebViewPage(
                                  url: 'https://www.snapchat.com/afaq_dc/'),
                              transition: Transition.fadeIn);
                        },
                        child: FaIcon(FontAwesomeIcons.snapchat,
                            color: Color(0xFF4297AA)),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              () => WebViewPage(
                                  url: 'https://www.instagram.com/afaq_dc/'),
                              transition: Transition.fadeIn);
                        },
                        child: FaIcon(FontAwesomeIcons.instagram,
                            color: Color(0xFF4297AA)),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                              () => WebViewPage(
                                  url: 'https://twitter.com/afaq_dc/'),
                              transition: Transition.fadeIn);
                        },
                        child: FaIcon(FontAwesomeIcons.twitter,
                            color: Color(0xFF4297AA)),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          // if (!await launchUrl(Uri.parse("00966508050433"))) throw 'Could not launch ';

                          await _makePhoneCall("00966508050433");

                          // Get.to(() => (WebViewPage(url: '00966508050433')),
                          //     transition: Transition.fadeIn);
                        },
                        child: Icon(Icons.call, color: Color(0xFF4297AA)),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          String toEmail = 'info@afaq-alzahbia.com';
                          String subject = 'استفسار من تطبيق آفاق';
                          String body =
                              "مرحباً آفاق العقارية ، أود الاستفسار عن ...";
                          final url =
                              'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
                          if (!await launch(url)) ;

                          // Get.to(() => (WebViewPage(url: url)),
                          //     transition: Transition.fadeIn);
                        },
                        child: Icon(Icons.attach_email_outlined,
                            color: Color(0xFF4297AA)),
                      ),
                      Spacer(),
                      // info@afaq-alzahbia.com
                    ],
                  ),
                ),
              ),
              listActions(),
              SizedBox(height: getProportionateScreenHeight(1)),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "جميع الحقوق محفوظة © لشركة آفاق الذهبية المحدودة",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "version : ${MyTheme.appVersion}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              SizedBox(height: getProportionateScreenHeight(50)),
              SizedBox(height: getProportionateScreenHeight(50)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget displayUserProfile(final UserModel thisUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            "${thisUser.fullname}",
            // style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child:
              Text("${thisUser.email}", style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  final List<dynamic> actions = [
    {
      "title": "موقعنا  :  جدة - حي السامر".tr,
      "icon": const Icon(FontAwesomeIcons.locationDot, color: Color(0xFF4297AA))
    },
    {
      "title": "تغيير اسم المستخدم".tr,
      "icon": const Icon(
        Feather.user,
        color: Color(0xFF4297AA),
      )
    },
    {
      "title": "تغيير كلمة المرور".tr,
      "icon": const Icon(Feather.key, color: Color(0xFF4297AA))
    },
    {
      "title": " موقع آفاق العقاري".tr,
      "icon": const Icon(FontAwesomeIcons.link, color: Color(0xFF4297AA))
    },
    {
      "title": "تقييم التطبيق على المتجر".tr,
      "icon": const Icon(Icons.rate_review_outlined, color: Color(0xFF4297AA))
    },
    {
      "title": "سياسة الخصوصية وشروط آفاق",
      "icon": const Icon(Icons.policy_outlined, color: Color(0xFF4297AA))
    },
    {
      "title": "تعرف على آفاق",
      "icon": const Icon(Icons.info_outline, color: Color(0xFF4297AA))
    },
    {
      "title": "الأسئلة الشائعة",
      "icon": const Icon(FontAwesomeIcons.question, color: Color(0xFF4297AA))
    },
    {
      "title": "تسجيل الخروج",
      "icon": const Icon(Feather.log_out, color: Color(0xFF4297AA))
    },
  ];

  Widget listActions() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: actions.map((e) {
        final int index = actions.indexOf(e);
        return ActionMenu(
            text: e['title'],
            icon: e['icon'],
            press: () {
              clickAction(index);
            });
      }).toList(),
    );
  }

  clickAction(final int index) {
    if (index >= actions.length - 1) {
      CoolAlert.show(
          context: Get.context!,
          backgroundColor: Color(0xD74297AA),
          type: CoolAlertType.confirm,
          text: 'هل تود تسجيل الخروج',
          confirmBtnText: 'نعم',
          cancelBtnText: 'لا',
          title: "يسرنا بقاؤك",
          confirmBtnColor: Color(0xD74297AA),
          onConfirmBtnTap: () async {
            Get.back();
            x.setIndexBar(2);
            EasyLoading.show(status: 'بانتظارك لاحقاً');
            await Future.delayed(const Duration(milliseconds: 2200));

            x.doLogout();

            Future.delayed(const Duration(milliseconds: 1000), () {
              EasyLoading.dismiss();
              Get.offAll(() => (IntroScreen()));
            });
          });
    } else if (index == 1) {
      showDialogOptionChangeFullname(XController.to, updateUser.value);
    } else if (index == 0) {
      Get.to(() => (WebViewPage(url: 'https://goo.gl/maps/bL4rhtAEHA16Th3GA')),
          transition: Transition.fadeIn);
    } else if (index == 2) {
      showDialogOptionChangePassword(XController.to, updateUser.value);
    } else if (index == 3) {
      Get.to(() => (WebViewPage(url: 'https://www.afaq-althahbia.com/')),
          transition: Transition.fadeIn);
    } else if (index == 4) {
      if (Platform.isAndroid) {
        Get.to(
            () => (WebViewPage(
                url:
                    'https://play.google.com/store/apps/details?id=com.afaq.realstate')),
            transition: Transition.fadeIn);
      } else if (Platform.isIOS) {
        Get.to(
            () => (WebViewPage(
                url:
                    'https://apps.apple.com/il/app/%D8%A2%D9%81%D8%A7%D9%82-%D8%A7%D9%84%D8%B9%D9%82%D8%A7%D8%B1%D9%8A%D8%A9/id1631749460')),
            transition: Transition.fadeIn);
      }
    } else if (index == 5) {
      Get.to(
          () => (WebViewPage(
              url:
                  'https://drive.google.com/file/d/1jxiPDiZQsRJgifVAKW2CuARMRW0IDL_O/view?usp=sharing')),
          transition: Transition.fadeIn);
    } else if (index == 6) {
      Get.to(() => (WebViewPage(url: 'https://afaq-althahbia.com/#about')),
          transition: Transition.fadeIn);
    } else if (index == 7) {
      Get.to(() => (WebViewPage(url: 'https://afaq-althahbia.com/#about')),
          transition: Transition.fadeIn);
    }
  }

  Widget profileIcon(final UserModel thisUser) {
    return Container(
      height: getProportionateScreenHeight(115),
      width: getProportionateScreenWidth(115),
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.all(0),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExtendedNetworkImageProvider(
                  // pathImage!=null ||  pathImage.isNotEmpty ? pathImage.obs.string:"${thisUser.image}",
                  "${thisUser.image}",
                  cache: true,
                ),
              ),
            ),
          ),
          // Text("sss${pathImage.string}"),
          Positioned(
            right: -10,
            bottom: -5,
            child: SizedBox(
              height: 44,
              width: 44,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4297AA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    //side: BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  showDialogOptionImage();
                },
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topIcon() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: IconBack(callback: () {
              x.setIndexBar(2);
            }),
          ),
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              "الملف الشخصي".tr,
              style: const TextStyle(
                fontSize: 18,
                color: colorTrans2,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => (FeedbackPage()), transition: Transition.fade);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorGrey2,
                    style: BorderStyle.solid,
                    width: 0.8,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Icon(
                  FontAwesome.edit,
                  size: 16,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // option change photo
  final picker = ImagePicker();
  final pathImage = ''.obs;
  pickImageSource(int tipe) {
    Future<XFile?> file;

    file = picker.pickImage(
        source: tipe == 1 ? ImageSource.gallery : ImageSource.camera);
    file.then((XFile? pickFile) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (pickFile != null) {
          //startUpload();

          pathImage.value = pickFile.path;

          _cropImage(x, File(pathImage.value));

          x.updatePhotoUser(pathImage.value);
        }
      });
    });
  }

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  Future _cropImage(final XController x, final File imageFile) async {
    Get.dialog(
      Container(
        padding: const EdgeInsets.all(5),
        width: Get.width,
        height: Get.height / 1.2,
        child: Stack(
          children: [
            ExtendedImage.file(
              imageFile,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: editorKey,
              cacheRawData: true,
              initEditorConfigHandler: (state) {
                return EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: const EdgeInsets.all(20.0),
                  hitTestSize: 20.0,
                  cropAspectRatio:
                      CropAspectRatios.original, // update your ratio here
                );
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Get.back();
                  cropAction(x);
                },
                icon: Icon(
                  Feather.check_circle,
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  cropAction(final XController x) async {
    final Uint8List fileData = Uint8List.fromList(kIsWeb
        ? (await cropImageDataWithDartLibrary(state: editorKey.currentState!))!
        : (await cropImageDataWithNativeLibrary(
            state: editorKey.currentState!))!);

    final String title = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String? fileFath = await ImageSaver.save(title, fileData);

    File tmpFile = File(fileFath!);
    String base64Image = base64Encode(tmpFile.readAsBytesSync());
    String fileName = tmpFile.path.split('/').last;
    Future.microtask(() {
      upload(fileName, base64Image);
    });
  }

  upload(String fileName, String base64Image) async {
    EasyLoading.show(status: 'جاري التعديل');

    String? idUser = updateUser.value.id;

    if (idUser == null && idUser == '') {
      return;
    }

    var dataPush = jsonEncode({
      "filename": fileName,
      "id": idUser,
      "image": base64Image,
      "lat": x.latitude,
      "loc": x.location,
    });

    //debugPrint(dataPush);
    var path = "upload/upload_image_user";
    //debugPrint(link);

    x.provider.pushResponse(path, dataPush)!.then((result) {
      //debugPrint(result.body);
      dynamic _result = jsonDecode(result.bodyString!);
      //debugPrint(_result);

      //EasyLoading.dismiss();
      if (_result['code'] == '200') {
        EasyLoading.showSuccess("نجحت العملية");
        String fileUploaded = "${_result['result']['file']}";
        debugPrint(fileUploaded);

        x.getUserById();
        Future.delayed(const Duration(seconds: 2), () {
          updateUser.value = x.thisUser.value;
        });
        Future.delayed(const Duration(seconds: 4), () {
          Future.microtask(() {
            x.asyncHome();
          });
          Get.back();
        });
      } else {
        EasyLoading.showError("فشلت العملية");
      }
    }).catchError((error) {
      debugPrint(error);
      EasyLoading.dismiss();
    });
  }

  showDialogOptionImage() {
    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 3.5,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5.0),
            topLeft: Radius.circular(5.0),
          ),
          gradient: LinearGradient(
            colors: [
              mainBackgroundcolor,
              mainBackgroundcolor2,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.only(top: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "التقط واحدة",
                                style: Get.theme.textTheme.headline5!.copyWith(
                                    // fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              pickImageSource(0);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "كاميرا",
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () {
                              Get.back();
                              pickImageSource(1);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "الاستديو",
                                    style: textBold.copyWith(
                                      color: Get.theme.canvasColor,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Feather.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController _fullname = TextEditingController();
  showDialogOptionChangeFullname(
      final XController x, final UserModel thisUser) {
    _fullname.text = '${thisUser.fullname}';

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 2.5,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
          gradient: LinearGradient(
            colors: [
              mainBackgroundcolor,
              mainBackgroundcolor2,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.only(top: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "تعديل الاسم الشخصي".tr,
                                style: Get.theme.textTheme.headline5!.copyWith(
                                    // fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xD74297AA),
                              blurRadius: 1.0,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _fullname,
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "الاسم الكريم",
                              hintTextDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      spaceHeight20,
                      spaceHeight10,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "إنهاء".tr,
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () async {
                              String fn = _fullname.text.trim();
                              if (fn.isEmpty) {
                                MyTheme.showToast('Fullname invalid!');
                                return;
                              }

                              Get.back();
                              EasyLoading.show(status: 'جاري التعديل');
                              x.updateUserById(
                                  'update_about_fullname', 'About Me', fn);
                              await Future.delayed(
                                  const Duration(milliseconds: 1800), () {
                                x.getUserById();
                                Future.delayed(const Duration(seconds: 2), () {
                                  updateUser.value = x.thisUser.value;
                                });
                              });

                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                EasyLoading.showSuccess('تم التحديث');
                                x.asyncHome();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "تعديل",
                                    style: textBold.copyWith(
                                      color: Get.theme.canvasColor,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Feather.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //change password
  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _newRePass = TextEditingController();
  showDialogOptionChangePassword(
      final XController x, final UserModel thisUser) {
    _oldPass.text = '';
    _newPass.text = '';
    _newRePass.text = '';

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 1.7,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
          gradient: LinearGradient(
            colors: [
              mainBackgroundcolor,
              mainBackgroundcolor2,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.only(top: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "تغيير كلمة المرور".tr,
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xD74297AA),
                              blurRadius: 1.0,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _oldPass,
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "الكلمة المرور السابقة",
                              hintTextDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xD74297AA),
                              blurRadius: 1.0,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _newPass,
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "كلمة المرور الجديدة",
                              hintTextDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xD74297AA),
                              blurRadius: 1.0,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _newRePass,
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "تأكيد كلمة المرور",
                              hintTextDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      spaceHeight20,
                      spaceHeight10,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "إنهاء".tr,
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () async {
                              String op = _oldPass.text.trim();
                              String np = _newPass.text.trim();
                              String rp = _newRePass.text.trim();
                              if (op.isEmpty) {
                                MyTheme.showToast('خطأ في كلمة المرور السابقة');
                                return;
                              }

                              if (np.isEmpty || np.length < 6) {
                                MyTheme.showToast(
                                    'كلمة المرور لا تقل عن ٦ خانات');
                                return;
                              }

                              if (rp.isEmpty || rp.length < 6) {
                                MyTheme.showToast('كلمة االمرور غير متطابقة');
                                return;
                              }

                              if (np != rp) {
                                MyTheme.showToast('كلمة االمرور غير متطابقة');
                                return;
                              }

                              if (op != x.myPref.pPassword.val) {
                                MyTheme.showToast('خطأ في كلمة المرور السابقة');
                                return;
                              }

                              Get.back();
                              EasyLoading.show(status: 'جاري التعديل');
                              x.updateUserById('تغيير كلمة المرور', op, np);
                              await Future.delayed(
                                  const Duration(milliseconds: 1800));

                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                EasyLoading.showSuccess('تم التحديث');
                                x.setIndexBar(0);
                                x.doLogout();

                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  EasyLoading.dismiss();
                                  Get.offAll(() => (IntroScreen()));
                                });
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "تعديل",
                                    style: textBold.copyWith(
                                      color: Get.theme.canvasColor,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Feather.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
