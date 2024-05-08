import 'dart:convert';

import 'package:Afaq/auth/sign_in_screen.dart';
import 'package:Afaq/auth/sign_up_screen.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/button_container.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../app/my_home.dart';
import '../core/firebase_auth_service.dart';

class IntroScreen extends StatelessWidget {
  final XController x = XController.to;
  IntroScreen({Key? key}) : super(key: key) {
    Future.delayed(const Duration(milliseconds: 2200), () {});
  }
  final PageController controller = PageController(initialPage: 0);

  final titles = [
    "شركة آفاق الذهبية المحدودة للتطوير العقاري السعودية تأسست مطلع ٢٠٢٠م على أيدي خبرات عملية وبتخصصات دقيقة لتلبية الطلب المتزايد في قطاع التطوير العقاري في المملكة العربية السعودية.",
    "تطبيق آفاق العقاري طريقك للرقي والجمال .",
    "شقة العمر مع آفاق غير .",
  ];
  final images = [
    'assets/slide05_trans.png',
    'assets/slide04_trans.png',
    'assets/slide03_trans.png'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              mainBackgroundcolor,
              mainBackgroundcolor2,
              mainBackgroundcolor3,
              mainBackgroundcolor2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: Get.width,
            padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceHeight50,
                  spaceHeight50,
                  pageController(),
                  spaceHeight20,
                  spaceHeight20,
                  Obx(() => createIndicator(indexSelected.value)),
                  spaceHeight20,
                  Container(
                    margin: const EdgeInsets.only(bottom: 0),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          debugPrint("sign in clicked..");
                          Get.to(() => (SignInScreen()),
                              transition: Transition.fadeIn);
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          debugPrint("sign up clicked..");
                          Get.to(() => (SignUpScreen()),
                              transition: Transition.zoom);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: ButtonContainer(
                            colorPrimary: true,
                            text: "تسجيل الحساب",
                            linearGradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white,
                              ],
                            ),
                            boxShadow: BoxShadow(
                              color: Get.theme.disabledColor.withOpacity(.5),
                              blurRadius: 3.0,
                              offset: const Offset(1, 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  spaceHeight10,
                  spaceHeight10,
                  spaceHeight50,
                  spaceHeight50,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final indexSelected = 0.obs;
  Widget pageController() {
    return SizedBox(
      width: Get.width,
      height: Get.height / 2.5,
      child: PageView.builder(
        onPageChanged: (int index) {
          indexSelected.value = index;
        },
        controller: controller,
        itemCount: titles.length,
        itemBuilder: (BuildContext context, int index) {
          return eachPage(titles[index], images[index]);
        },
      ),
    );
  }

  Widget eachPage(final String title, final String image) {
    return Container(
      color: Colors.transparent,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              margin: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
              ),
              child: Image.asset(
                image,
                fit: BoxFit.scaleDown,
                // height: getProportionateScreenHeight(300),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              maxLines: 7,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Size of points
  final double size = 8.0;

  /// Spacing of points
  final double spacing = 4.0;

  Widget createIndicator(final int selectedIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(titles.length, (int index) {
        return _buildIndicator(
            index, titles.length, size, spacing, selectedIndex);
      }),
    );
  }

  Widget _buildIndicator(int index, int pageCount, double dotSize,
      double spacing, int selectedIndex) {
    // Is the current page selected?
    bool isCurrentPageSelected = index == selectedIndex;

    return SizedBox(
      height: size,
      width: size + (2 * spacing),
      child: Center(
        child: Material(
          color: isCurrentPageSelected
              ? Colors.white
              : Get.theme.colorScheme.secondary,
          type: MaterialType.circle,
          child: SizedBox(
            width: dotSize,
            height: dotSize,
          ),
        ),
      ),
    );
  }

  final textEmail = ''.obs;
  final textPassword = ''.obs;
  pushLogin(final XController x) async {
    EasyLoading.show(status: 'Loading...');

    try {
      String em = textEmail.value.trim();
      String ps = textPassword.value.trim();

      FirebaseAuthService _auth = x.notificationFCMManager.firebaseAuthService;
      await _auth.firebaseSignInByEmailPwd(em, ps);

      await Future.delayed(const Duration(milliseconds: 1200));

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

          await Future.delayed(const Duration(milliseconds: 800), () {
            x.asyncHome();
          });

          await Future.delayed(const Duration(milliseconds: 2200), () {
            EasyLoading.dismiss();
            Get.offAll(() => (MyHome()));
          });
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
      backgroundColor: Get.theme.backgroundColor,
      context: Get.context!,
      type: CoolAlertType.error,
      text: "Your credential login (Email & Password) invalid!",
      //autoCloseDuration: Duration(seconds: 10),
    );
  }

  // pushLoginGmail(final XController x, {required String email}) async {
  //   EasyLoading.show(status: 'Loading...');
  //
  //   try {
  //     String em = textEmail.value.trim();
  //     String ps = textPassword.value.trim();
  //
  //     FirebaseAuthService _auth = x.notificationFCMManager.firebaseAuthService;
  //     await _auth.firebaseSignInByEmailPwd(em, ps);
  //
  //     await Future.delayed(const Duration(milliseconds: 1200));
  //
  //     String? uid = await _auth.getFirebaseUserId();
  //     if (uid == null) {
  //       showErrorLogin();
  //       return;
  //     }
  //
  //     var dataPush = jsonEncode({
  //       "em": email,
  //       "ps": ps,
  //       "is": x.install['id_install'],
  //       "lat": x.latitude,
  //       "loc": x.location,
  //       "cc": x.myPref.pCountry.val,
  //       "uf": uid,
  //     });
  //     debugPrint(dataPush);
  //
  //     final response = await x.provider.pushResponse('api/login', dataPush);
  //     //debugPrint(response);
  //
  //     if (response != null && response.statusCode == 200) {
  //       //debugPrint(response.body);
  //       dynamic _result = jsonDecode(response.bodyString!);
  //
  //       if (_result['code'] == '200') {
  //         dynamic member = _result['result'][0];
  //         x.doLogin(member);
  //
  //         await Future.delayed(const Duration(milliseconds: 800), () {
  //           print('000000000');
  //           x.asyncHome();
  //         });
  //
  //         await Future.delayed(const Duration(milliseconds: 2200), () {
  //           print('1111111111');
  //           EasyLoading.dismiss();
  //           Get.offAll(() => (MyHome()));
  //         });
  //       } else {
  //         await Future.delayed(const Duration(milliseconds: 2200), () async {
  //           // pushRegisterGmail(x,email: email);
  //           showErrorLogin();
  //           await Future.delayed(const Duration(milliseconds: 3200), () {
  //             x.notificationFCMManager.firebaseAuthService.signOut();
  //           });
  //         });
  //       }
  //     } else {
  //       print('2222222222');
  //       await Future.delayed(const Duration(milliseconds: 3200), () {
  //         x.notificationFCMManager.firebaseAuthService.signOut();
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Error: api/login $e");
  //   }
  // }

  // pushRegisterGmail(final XController x,{required String email}) async {
  //   // EasyLoading.show(status: 'جاري التسجيل لانصمامك معنا');
  //
  //   // String em = textEmail.value.toString().trim();
  //
  //   // check email first
  //   bool passChecked = false;
  //   try {
  //     final datapush = {
  //       "em": email,
  //     };
  //
  //     debugPrint(jsonEncode(datapush));
  //     final response = await x.provider
  //         .pushResponse('api/checkEmailPhone', jsonEncode(datapush));
  //     if (response != null && response.statusCode == 200) {
  //       dynamic _result = jsonDecode(response.bodyString!);
  //       //debugPrint(_result);
  //
  //
  //       if (_result['code'] != '200') {
  //         passChecked = true;
  //         print("new email");
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("");
  //   }
  //
  //   try {
  //     if (!passChecked) {
  //       EasyLoading.dismiss();
  //       print("exist email");
  //       // EasyLoading.showToast("البريد الإلكتروني موجود مسبقاً");
  //       return;
  //     }
  //
  //     // push email Firebase
  //     FirebaseAuthService _auth = x.notificationFCMManager.firebaseAuthService;
  //     await _auth.firebaseSignUpByEmailPwd(email: em);
  //
  //     await Future.delayed(const Duration(milliseconds: 1200));
  //
  //     String? uid = await _auth.getFirebaseUserId();
  //     if (uid == null) {
  //       EasyLoading.dismiss();
  //       return;
  //     }
  //
  //     final MyPref myPref = MyPref.to;
  //
  //     final datapush = {
  //       "em": em,
  //       // "ps": ps,
  //       "is": x.install['id_install'] ?? "",
  //       "lat": myPref.pLatitude.val,
  //       "loc": myPref.pLocation.val,
  //       "cc": myPref.pCountry.val,
  //       // "fn": textFullname.value.toString().trim(),
  //       "uf": uid,
  //     };
  //
  //     //debugPrint(datapush);
  //
  //     final response =
  //     await x.provider.pushResponse('api/register', jsonEncode(datapush));
  //     //debugPrint(response);
  //
  //     if (response != null && response.statusCode == 200) {
  //       EasyLoading.dismiss();
  //       dynamic _result = jsonDecode(response.bodyString!);
  //
  //       if (_result['code'] == '200') {
  //         dynamic member = _result['result'][0];
  //
  //         Future.microtask(() => successRegisterGmail(x, member));
  //         Future.delayed(const Duration(milliseconds: 2200), () {
  //           Get.offAll(() =>(MyHome()));
  //         });
  //       } else {
  //         await Future.delayed(const Duration(milliseconds: 2200), () async {
  //           EasyLoading.dismiss();
  //
  //           CoolAlert.show(
  //             backgroundColor: Get.theme.backgroundColor,
  //             context: Get.context!,
  //             type: CoolAlertType.error,
  //             text: "${_result['message']}",
  //             //autoCloseDuration: Duration(seconds: 10),
  //           );
  //
  //           await Future.delayed(const Duration(milliseconds: 2200), () {
  //             x.notificationFCMManager.firebaseAuthService.signOut();
  //           });
  //         });
  //       }
  //     } else {
  //       EasyLoading.dismiss();
  //       await Future.delayed(const Duration(milliseconds: 2200), () {
  //         x.notificationFCMManager.firebaseAuthService.signOut();
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Error: ${e.toString()}");
  //   }
  // }
  //
  // static successRegisterGmail(final XController x, final dynamic member) async {
  //   //dynamic member = _result['result'][0];
  //
  //   x.doLogin(member);
  //
  //   await Future.delayed(const Duration(milliseconds: 3200), () {
  //     EasyLoading.dismiss();
  //   });
  // }
}

// pushRegisterGmail(final XController x,{required String email}) async {
//   EasyLoading.show(status: 'جاري التسجيل لانصمامك معنا');
//
//   // String em = textEmail.value.toString().trim();
//
//   // check email first
//   bool passChecked = false;
//   try {
//     final datapush = {
//       "em": email,
//     };
//
//     debugPrint(jsonEncode(datapush));
//
//     final response = await x.provider
//         .pushResponse('api/checkEmailPhone', jsonEncode(datapush));
//     if (response != null && response.statusCode == 200) {
//       dynamic _result = jsonDecode(response.bodyString!);
//       //debugPrint(_result);
//
//       if (_result['code'] != '200') {
//         passChecked = true;
//       }
//     }
//   } catch (e) {
//     debugPrint("");
//   }
//
//   try {
//     if (!passChecked) {
//       EasyLoading.dismiss();
//
//       EasyLoading.showToast("البريد الإلكتروني موجود مسبقاً");
//       return;
//     }
//
//     // push email Firebase
//     // FirebaseAuthService _auth = x.notificationFCMManager.firebaseAuthService;
//     // await _auth.firebaseSignUpByEmailPwd(em, ps);
//
//     await Future.delayed(const Duration(milliseconds: 1200));
//
//     // String? uid = await _auth.getFirebaseUserId();
//     // if (uid == null) {
//     //   EasyLoading.dismiss();
//     //   return;
//     // }
//
//     final MyPref myPref = MyPref.to;
//
//     final datapush = {
//       "em": email,
//
//       "is": x.install['id_install'] ?? "",
//       "lat": myPref.pLatitude.val,
//       "loc": myPref.pLocation.val,
//       "cc": myPref.pCountry.val,
//
//       // "uf": uid,
//     };
//
//     //debugPrint(datapush);
//
//     final response =
//     await x.provider.pushResponse('api/register', jsonEncode(datapush));
//     //debugPrint(response);
//
//     if (response != null && response.statusCode == 200) {
//       EasyLoading.dismiss();
//       dynamic _result = jsonDecode(response.bodyString!);
//
//       // if (_result['code'] == '200') {
//         dynamic member = _result['result'][0];
//
//         Future.microtask(() => successRegisterGmail(x, member));
//         Future.delayed(const Duration(milliseconds: 2200), () {
//           Get.offAll(MyHome());
//         });
//       // } else {
//       //   await Future.delayed(const Duration(milliseconds: 2200), () async {
//       //     print('qqqqqqqqq');
//           // EasyLoading.dismiss();
//           //
//           // CoolAlert.show(
//           //   backgroundColor: Get.theme.backgroundColor,
//           //   context: Get.context!,
//           //   type: CoolAlertType.error,
//           //   text: "${_result['message']}",
//           //   //autoCloseDuration: Duration(seconds: 10),
//           // );
//           //
//           // await Future.delayed(const Duration(milliseconds: 2200), () {
//           //   x.notificationFCMManager.firebaseAuthService.signOut();
//           // });
//         // }
//     // );
//     //   }
//     } else {
//       // EasyLoading.dismiss();
//       // await Future.delayed(const Duration(milliseconds: 2200), () {
//       //   x.notificationFCMManager.firebaseAuthService.signOut();
//       // });
//       print('11111111111');
//     }
//   } catch (e) {
//     debugPrint("Error: ${e.toString()}");
//   }
// }
//
// static successRegisterGmail(final XController x, final dynamic member) async {
//   //dynamic member = _result['result'][0];
//
//   x.doLogin(member);
//
//   await Future.delayed(const Duration(milliseconds: 3200), () {
//     EasyLoading.dismiss();
//   });
// }
