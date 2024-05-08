import 'dart:convert';

import 'package:Afaq/app/my_home.dart';
import 'package:Afaq/auth/sign_up_screen.dart';
import 'package:Afaq/core/firebase_auth_service.dart';
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

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key) {
    Future.delayed(const Duration(milliseconds: 2200), () {});
  }

  final XController x = XController.to;
  @override
  Widget build(BuildContext context) {
    _email.text = '';
    _password.text = '';

    return Container(
      padding: const EdgeInsets.only(top: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainBackgroundcolor,
            mainBackgroundcolor2,
            mainBackgroundcolor3,
            mainBackgroundcolor2,
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
                    spaceHeight50,
                    Container(
                      padding: const EdgeInsets.only(top: 60, right: 10),
                      child: const Text(
                        "أهلاً وسهلاً بك معنا",
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
                        ". آفاق تقدم لك أحدث الشقق والفلل الروف العقارية",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    spaceHeight20,
                    spaceHeight20,
                    inputEmail(),
                    spaceHeight20,
                    inputPassword(),
                    spaceHeight50,
                    spaceHeight20,
                    Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            debugPrint("sign in clicked..");
                            String em = textEmail.value;
                            String ps = textPassword.value;

                            if (em.trim().length < 3 || !GetUtils.isEmail(em)) {
                              MyTheme.showSnackbar(
                                  "! خطأ في البريد الإلكتروني");
                              return;
                            }

                            if (ps.trim().length < 6) {
                              MyTheme.showSnackbar("! خطأ في كلمة المرور");
                              return;
                            }

                            pushLogin(x);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: const ButtonContainer(
                              text: "تسجيل الدخول",
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
                              text: '  لا تملك حساب في آفاق ؟    ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: fontFamily,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'تسجيل حساب',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: fontFamily,
                                      fontSize: 16,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // navigate to desired screen
                                        Get.back();
                                        Future.microtask(() => Get.to(
                                            () => SignUpScreen(),
                                            transition: Transition.upToDown));
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

  // email address
  final textEmail = ''.obs;
  final TextEditingController _email = TextEditingController();
  Widget inputEmail() {
    debugPrint("rebuild form inputEmail");
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
          autocorrect: false,
          // autofocus: true,

          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (!GetUtils.isEmail(value!)) {
              return "   ! صيغة البريد خاطئة";
            } else {
              return null;
            }
          },
          onChanged: (text) {
            textEmail.value = text;
          },
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.rtl,

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
    debugPrint("rebuild form inputPassword");
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
            textDirection: TextDirection.rtl,
            controller: _password,
            onChanged: (text) {
              textPassword.value = text;
            },
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
                // ),
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
            padding: const EdgeInsets.only(
              top: 0,
            ),
            child: const Text(
              "تسجيل الدخول",
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

  pushLogin(final XController x) async {
    EasyLoading.show(status: 'نتشرف بك معنا');

    try {
      String em = textEmail.value.trim();
      String ps = textPassword.value.trim();

      FirebaseAuthService _auth = x.notificationFCMManager.firebaseAuthService;
      await _auth.firebaseSignInByEmailPwd(em, ps);

      // await Future.delayed(const Duration(milliseconds: 1200));

      String? uid = await _auth.getFirebaseUserId();
      if (uid == null) {
        showErrorLogin();
        return;
      }

      var dataPush = jsonEncode({
        "em": em,
        "ps": ps,
        "is": x.install['id_install'],
        "lat": x.latitude,
        "loc": x.location,
        "cc": x.myPref.pCountry.val,
        "uf": uid,
      });
      debugPrint(dataPush);

      final response = await x.provider.pushResponse('api/login', dataPush);
      //debugPrint(response);

      if (response != null && response.statusCode == 200) {
        //debugPrint(response.body);
        dynamic _result = jsonDecode(response.bodyString!);

        if (_result['code'] == '200') {
          dynamic member = _result['result'][0];
          x.doLogin(member);
          Get.offAll(() => (MyHome()));
        } else {
          await Future.delayed(const Duration(milliseconds: 2200), () async {
            showErrorLogin();
            await Future.delayed(const Duration(milliseconds: 3200), () {
              x.notificationFCMManager.firebaseAuthService.signOut();
            });
          });
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 3200), () {
          x.notificationFCMManager.firebaseAuthService.signOut();
        });
      }
    } catch (e) {
      debugPrint("Error: api/login $e");
    }
  }

  showErrorLogin() {
    EasyLoading.dismiss();

    CoolAlert.show(
        backgroundColor: Color(0xD74297AA),
        context: Get.context!,
        type: CoolAlertType.error,
        title: "عذراً",
        text: "! للأسف ، البيانات المدخلة خاطئة ",
        confirmBtnText: "إنهاء",
        confirmBtnColor: Color(0xD74297AA));
  }
}
