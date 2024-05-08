import 'dart:convert';

import 'package:Afaq/app/my_home.dart';
import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/size_config.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/models/rental_model.dart';
import 'package:Afaq/models/trans_model.dart';
import 'package:Afaq/pages/bycategory.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/icon_back.dart';
import 'package:Afaq/widgets/image_clip.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  final XController x = XController.to;

  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyPref myPref = MyPref.to;
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
              SizedBox(height: getProportionateScreenHeight(15)),
              Obx(() => rowMenus(selectedOpt.value, myPref)),
              SizedBox(height: getProportionateScreenHeight(55)),
              SizedBox(height: getProportionateScreenHeight(155)),
            ],
          ),
        ),
      ),
    );
  }

  final selectedOpt = 0.obs;
  final List<String> catOptions = ["حالي".tr, "سابق".tr];
  Widget rowMenus(final int selectedOption, final MyPref myPref) {
    return Container(
      // padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 140),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: catOptions.map(
                (e) {
                  final index = catOptions.indexOf(e);
                  return InkWell(
                    onTap: () {
                      selectedOpt.value = index;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            e,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: (index == selectedOption) ? 15 : 14,
                                color: (index == selectedOption)
                                    ? Colors.black87
                                    : Colors.white,
                                fontWeight: (index == selectedOption)
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          if (index == selectedOption)
                            Container(
                              margin: const EdgeInsets.only(top: 3),
                              color: Get.theme.primaryColor,
                              height: 3,
                              width: 30,
                            )
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          spaceHeight20,
          spaceHeight10,
          Obx(
            () => selectedOption == 0
                ? listTrans(x.itemHome.value.trans!, selectedOption, myPref)
                : listPastTrans(
                    x.itemHome.value.trans!, selectedOption, myPref),
          ),
          spaceHeight5,
        ],
      ),
    );
  }

  Widget listTrans(
      final List<TransModel> temps, final int indexTrans, final MyPref myPref) {
    debugPrint("build listTrans..");

    final List<TransModel> trans = [];
    for (var element in temps) {
      if (element.status! < 3) {
        trans.add(element);
      }
    }

    return Container(
      child: trans.isEmpty
          ? Container(child: ByCategory.noDataFound())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: trans.map((TransModel e) {
                RentalModel rental = e.rent!; //findRentalById(e.idRent!);
                String unitPrice = "${rental.unitPrice}".tr;
                final int status = e.status ?? 0;

                // status = 1 (checkin), 2 = stayed, 3 = done, 4 =void
                String descPay = e.descPayment!;
                try {
                  if (e.payment! == 'Credit Card') {
                    final jsonPay = jsonDecode(e.descPayment!);
                    descPay =
                        "CC: ${jsonPay['no'].toString().substring(0, 4)} xxxx xxxx xxxx";
                  }
                } catch (e) {
                  debugPrint("");
                }

                return InkWell(
                  onTap: () {
                    //Get.to(DetailRental(rental: rental));
                    MyHome.showDialogTrans(x, e);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: colorBoxShadow,
                          blurRadius: 1.0,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "#${e.no} - ${e.payment}",
                                  style: textBold.copyWith(
                                    fontSize: 11,
                                    color: colorTrans2,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  width: Get.width / 1.9,
                                  child: Text(
                                    "${rental.title}",
                                    maxLines: 2,
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis,
                                    style: textBold.copyWith(
                                      fontSize: 13,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                                // \n$descPay
                                SizedBox(
                                  width: Get.width / 1.8,
                                  child: Text(
                                    "${e.duration}",
                                    textDirection: TextDirection.rtl,
                                    style: textSmallGrey.copyWith(
                                        color: Colors.black54),
                                  ),
                                ),
                                Container(
                                  width: GetPlatform.isAndroid
                                      ? Get.width / 1.8
                                      : Get.width / 1.6,
                                  height: 30,
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        " ${MyTheme.formatCounterNumber(e.total!)}  ${myPref.pCurrency.val}",

                                        // "${MyTheme.numberFormat(e.total!)}  ${e.currency}",
                                        textDirection: TextDirection.rtl,

                                        style: textBold.copyWith(
                                          color: Get.theme.primaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 5, left: 20, bottom: 5, right: 10),
                          child: ImageClip(
                            url: '${rental.image}',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget listPastTrans(
      final List<TransModel> temps, final int indexTrans, final MyPref myPref) {
    debugPrint("build listPastTrans..");

    final List<TransModel> trans = [];
    for (var element in temps) {
      if (element.status! > 2) {
        trans.add(element);
      }
    }

    return Container(
      child: trans.isEmpty
          ? Container(child: ByCategory.noDataFound())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: trans.map((TransModel e) {
                final int index = trans.indexOf(e);
                RentalModel rental = e.rent!;

                String unitPrice = "${rental.unitPrice}".tr;
                final int status = e.status!;

                String descPay = e.descPayment!;
                try {
                  if (e.payment! == 'Credit Card') {
                    final jsonPay = jsonDecode(e.descPayment!);
                    descPay =
                        "CC: ${jsonPay['no'].toString().substring(0, 4)} xxxx xxxx xxxx";
                  }
                } catch (e) {
                  debugPrint("");
                }

                return InkWell(
                  onTap: () {
                    //Get.to(DetailRental(rental: rental));
                    MyHome.showDialogTrans(x, e);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 11),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 1.0,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ImageClip(
                            url: '${rental.image}',
                            width: 85,
                            height: 85,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("#${e.no} - ${e.payment}",
                                      style: textBold.copyWith(
                                          fontSize: 11, color: colorTrans2)),
                                  SizedBox(
                                    width: Get.width / 1.9,
                                    child: Text(
                                      "${rental.title}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: textBold.copyWith(
                                        fontSize: 13,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width / 1.8,
                                    child: Text(
                                      "${e.duration}\n$descPay",
                                      style: textSmallGrey.copyWith(
                                          color: Colors.black54),
                                    ),
                                  ),
                                  Container(
                                    width: GetPlatform.isAndroid
                                        ? Get.width / 1.8
                                        : Get.width / 1.65,
                                    height: 40,
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\n${e.currency}. ${MyTheme.numberFormat(e.total!)} /$unitPrice",
                                          style: textBold.copyWith(
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                        status != 4
                                            ? const Icon(Feather.check_circle,
                                                color: Colors.green, size: 18)
                                            : const Icon(Feather.x,
                                                color: Colors.lightBlue,
                                                size: 18),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    CoolAlert.show(
                                        context: Get.context!,
                                        backgroundColor: Get.theme.canvasColor,
                                        type: CoolAlertType.confirm,
                                        title: 'confirmation'.tr,
                                        text: 'confirm_delete'.tr,
                                        confirmBtnText: 'yes'.tr,
                                        cancelBtnText: 'cancel'.tr,
                                        confirmBtnColor: Colors.green,
                                        onConfirmBtnTap: () async {
                                          Get.back();
                                          final jsonBody = jsonEncode({
                                            "it": "${e.id}",
                                            "iu": "${x.thisUser.value.id}",
                                            "act": "delete",
                                            "lat": x.latitude,
                                          });
                                          debugPrint(jsonBody);

                                          await x.provider.pushResponse(
                                              'trans/update_trans', jsonBody);
                                          trans.removeAt(index);
                                          x.asyncHome();
                                          EasyLoading.showSuccess(
                                              'Delete successful...');
                                        });
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
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: Icon(
                                        FontAwesome.trash,
                                        size: 16,
                                        color: Get.theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
          Spacer(),
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              "الحجوزات".tr,
              style: const TextStyle(
                fontSize: 18,
                color: colorTrans2,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacer(),
          // const SizedBox.shrink(),
        ],
      ),
    );
  }
}
