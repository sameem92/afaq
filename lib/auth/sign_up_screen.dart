import 'dart:convert';

import 'package:Afaq/app/my_home.dart';
import 'package:Afaq/auth/sign_in_screen.dart';
import 'package:Afaq/core/firebase_auth_service.dart';
import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/main.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/button_container.dart';
import 'package:Afaq/widgets/icon_back.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key) {
    Future.delayed(const Duration(milliseconds: 2200), () {});
  }
  final XController x = XController.to;

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Container(
      padding: const EdgeInsets.only(top: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainBackgroundcolor,
            mainBackgroundcolor2,
            mainBackgroundcolor3,
            mainBackgroundcolor2
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 30, right: 10),
                      child: const Text(
                        "تسجيل الحساب في منصة آفاق",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: const Text(
                        "سارع بالانضمام معنا للحصول على أحدث وأرقى الشقق والفلل الروف مع آفاق العقارية",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    spaceHeight20,
                    inputFullname(),
                    spaceHeight20,
                    inputEmail(),
                    spaceHeight20,
                    inputPassword(),
                    spaceHeight20,
                    inputRePassword(),
                    spaceHeight10,
                    spaceHeight10,
                    spaceHeight10,
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            String nm = textFullname.value;
                            String em = textEmail.value;
                            String pass = textPassword.value;
                            String repass = textRePassword.value;

                            if (nm.trim().length < 2) {
                              MyTheme.showSnackbar('! خطأ في البيانات');
                              return;
                            }
                            if (em.trim().length < 3 || !GetUtils.isEmail(em)) {
                              MyTheme.showSnackbar("! خطأ في البيانات");
                              return;
                            }

                            if (pass.trim().length < 6) {
                              MyTheme.showSnackbar(
                                  "! خطأ في البيانات،كلمة المرور ٦ خانات عالأقل");
                              return;
                            }

                            if (repass.trim().length < 6) {
                              MyTheme.showSnackbar("كلمة المرور غير متطابقة");
                              return;
                            }

                            if (pass.trim() != repass.trim()) {
                              MyTheme.showSnackbar("كلمة المرور غير متطابقة");
                              return;
                            }

                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');

                            CoolAlert.show(
                                context: Get.context!,
                                backgroundColor: Color(0xD74297AA),
                                type: CoolAlertType.confirm,
                                text: 'أنك تريد تسجيل حسابك معنا $em?',
                                confirmBtnText: 'نعم',
                                cancelBtnText: 'لا',
                                confirmBtnColor: Color(0xD74297AA),
                                title: "هل أنت متأكد",
                                onConfirmBtnTap: () async {
                                  Get.back();
                                  Future.microtask(() => pushRegister(x));
                                });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: const ButtonContainer(
                              text: "سجل معنا",
                            ),
                          ),
                        ),
                      ),
                    ),
                    spaceHeight20,
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'تملك حساب معنا  ؟  ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: fontFamily,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'سجل دخول من هنا',
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      // decoration: TextDecoration.underline,
                                      fontFamily: fontFamily,
                                      fontSize: 16,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // navigate to desired screen
                                        Get.back();
                                        Future.microtask(() => Get.to(
                                            () => SignInScreen(),
                                            transition: Transition.cupertino));
                                      })
                              ]),
                        ),
                      ),
                    ),
                    spaceHeight50,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // fullname
  final textFullname = ''.obs;
  final TextEditingController _fullname = TextEditingController();
  Widget inputFullname() {
    _fullname.text = textFullname.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Get.theme.canvasColor,
            Get.theme.canvasColor.withOpacity(.98)
          ],
        ),
      ),
      child: SizedBox(
        width: Get.width,
        child: TextFormField(
          controller: _fullname,
          onChanged: (text) {
            textFullname.value = text;
          },
          textDirection: TextDirection.rtl,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
              suffixIcon: Icon(
                FontAwesome.user,
                size: 18,
                color: Get.theme.backgroundColor,
              ),
              border: InputBorder.none,
              hintText: "الاسم الكريم",
              hintTextDirection: TextDirection.rtl),
        ),
      ),
    );
  }

  // email address
  final textEmail = ''.obs;
  final TextEditingController _email = TextEditingController();
  Widget inputEmail() {
    _email.text = textEmail.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Get.theme.canvasColor,
            Get.theme.canvasColor.withOpacity(.98)
          ],
        ),
      ),
      child: SizedBox(
        width: Get.width,
        child: TextFormField(
          controller: _email,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (!GetUtils.isEmail(value!)) {
              return "  ! صيغة البريد خاطئة";
            } else {
              return null;
            }
          },
          onChanged: (text) {
            textEmail.value = text;
          },
          textDirection: TextDirection.rtl,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
              suffixIcon: Icon(
                FontAwesome.envelope,
                size: 18,
                color: Get.theme.backgroundColor,
              ),
              border: InputBorder.none,
              hintText: "البريد الإلكتروني",
              hintTextDirection: TextDirection.rtl),
        ),
      ),
    );
  }

  // password
  final textPassword = ''.obs;
  final isSecured = true.obs;
  final TextEditingController _password = TextEditingController();
  Widget inputPassword() {
    _password.text = textPassword.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Get.theme.canvasColor,
            Get.theme.canvasColor.withOpacity(.98)
          ],
        ),
      ),
      child: SizedBox(
        width: Get.width,
        child: Obx(
          () => TextFormField(
            controller: _password,
            onChanged: (text) {
              textPassword.value = text;
            },
            textDirection: TextDirection.rtl,
            obscureText: isSecured.value,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              suffixIcon: Icon(
                FontAwesome.key,
                size: 18,
                color: Get.theme.backgroundColor,
              ),
              border: InputBorder.none,
              hintText: "كلمة المرور",
              hintTextDirection: TextDirection.rtl,
              prefixIcon: InkWell(
                onTap: () {
                  isSecured.value = !isSecured.value;
                },
                child: Icon(
                  isSecured.value ? FontAwesome.eye : FontAwesome.eye_slash,
                  size: 18,
                  color: Get.theme.backgroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // re-password
  final textRePassword = ''.obs;
  final isSecuredRe = true.obs;
  final TextEditingController _repassword = TextEditingController();
  Widget inputRePassword() {
    _repassword.text = textRePassword.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Get.theme.canvasColor,
            Get.theme.canvasColor.withOpacity(.98)
          ],
        ),
      ),
      child: SizedBox(
        width: Get.width,
        child: Obx(
          () => TextFormField(
            controller: _repassword,
            onChanged: (text) {
              textRePassword.value = text;
            },
            textDirection: TextDirection.rtl,
            obscureText: isSecuredRe.value,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              suffixIcon: Icon(
                FontAwesome.key,
                size: 18,
                color: Get.theme.backgroundColor,
              ),
              border: InputBorder.none,
              hintText: "تأكيد كلمة المرور",
              hintTextDirection: TextDirection.rtl,
              prefixIcon: InkWell(
                onTap: () {
                  isSecuredRe.value = !isSecuredRe.value;
                },
                child: Icon(
                  isSecuredRe.value ? FontAwesome.eye : FontAwesome.eye_slash,
                  size: 18,
                  color: Get.theme.backgroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget topIcon() {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: const IconBack(),
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: const Text(
              "تسجيل الحساب",
              style: TextStyle(
                fontSize: 18,
                color: colorTrans2,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  //push registration
  pushRegister(final XController x) async {
    EasyLoading.show(status: 'جاري التسجيل لانصمامك معنا');

    String em = textEmail.value.toString().trim();
    String ps = textPassword.value.toString().trim();

    // check email first
    bool passChecked = false;
    try {
      final datapush = {
        "em": em,
      };

      debugPrint(jsonEncode(datapush));
      final response = await x.provider
          .pushResponse('api/checkEmailPhone', jsonEncode(datapush));
      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.bodyString!);
        //debugPrint(_result);

        if (_result['code'] != '200') {
          passChecked = true;
        }
      }
    } catch (e) {
      debugPrint("");
    }

    try {
      if (!passChecked) {
        EasyLoading.dismiss();

        EasyLoading.showToast("البريد الإلكتروني موجود مسبقاً");
        return;
      }

      // push email Firebase
      FirebaseAuthService _auth = x.notificationFCMManager.firebaseAuthService;
      await _auth.firebaseSignUpByEmailPwd(email: em, passwd: ps);

      await Future.delayed(const Duration(milliseconds: 1200));

      String? uid = await _auth.getFirebaseUserId();
      if (uid == null) {
        EasyLoading.dismiss();
        return;
      }

      final MyPref myPref = MyPref.to;

      final datapush = {
        "em": em,
        "ps": ps,
        "is": x.install['id_install'] ?? "",
        "lat": myPref.pLatitude.val,
        "loc": myPref.pLocation.val,
        "cc": myPref.pCountry.val,
        "fn": textFullname.value.toString().trim(),
        "uf": uid,
      };

      //debugPrint(datapush);

      final response =
          await x.provider.pushResponse('api/register', jsonEncode(datapush));
      //debugPrint(response);

      if (response != null && response.statusCode == 200) {
        EasyLoading.dismiss();
        dynamic _result = jsonDecode(response.bodyString!);

        if (_result['code'] == '200') {
          dynamic member = _result['result'][0];

          Future.microtask(() => successRegister(x, member));
          Future.delayed(const Duration(milliseconds: 2200), () {
            Get.offAll(() => (MyHome()));
          });
        } else {
          await Future.delayed(const Duration(milliseconds: 2200), () async {
            EasyLoading.dismiss();

            CoolAlert.show(
              backgroundColor: Get.theme.backgroundColor,
              context: Get.context!,
              type: CoolAlertType.error,
              text: "${_result['message']}",
              //autoCloseDuration: Duration(seconds: 10),
            );

            await Future.delayed(const Duration(milliseconds: 2200), () {
              x.notificationFCMManager.firebaseAuthService.signOut();
            });
          });
        }
      } else {
        EasyLoading.dismiss();
        await Future.delayed(const Duration(milliseconds: 2200), () {
          x.notificationFCMManager.firebaseAuthService.signOut();
        });
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  static successRegister(final XController x, final dynamic member) async {
    x.doLogin(member);

    await Future.delayed(const Duration(milliseconds: 3200), () {
      EasyLoading.dismiss();
    });
  }
}
