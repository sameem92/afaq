import 'dart:convert';
import 'dart:ui' as ui;

import 'package:Afaq/app/my_home.dart';
import 'package:Afaq/core/size_config.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/models/notif_model.dart';
import 'package:Afaq/pages/bycategory.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/icon_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotifPage extends StatelessWidget {
  NotifPage({Key? key}) : super(key: key) {
    final XController x = XController.to;
    datas.value = x.itemHome.value.notifs!;
    temps.value = x.itemHome.value.notifs!;

    isLoading.value = false;
  }

  final datas = <NotifModel>[].obs;
  final temps = <NotifModel>[].obs;
  final isLoading = true.obs;

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    final XController x = XController.to;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainBackgroundcolor,
            mainBackgroundcolor2,
            mainBackgroundcolor3,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: mainBackgroundcolor,
          title: topIcon(),
          elevation: 0.1,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: createBody(x),
      ),
    );
  }

  final TextEditingController _query = TextEditingController();
  Widget inputSearch(final XController x) {
    _query.text = '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
          controller: _query,
          onChanged: (String? text) {
            final List<NotifModel> latests = x.itemHome.value.notifs!;
            if (text!.isNotEmpty &&
                text.trim().isNotEmpty &&
                latests.isNotEmpty) {
              var models = latests.where((NotifModel element) {
                return element.title!
                    .toLowerCase()
                    .contains(text.trim().toLowerCase());
              }).toList();

              if (models.isNotEmpty) {
                datas.value = models;
              } else {
                datas.value = [];
              }
            } else {
              datas.value = temps;
            }
          },
          textDirection: ui.TextDirection.rtl,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            suffixIcon: Icon(
              FontAwesome.search,
              size: 14,
              color: Get.theme.backgroundColor,
            ),
            border: InputBorder.none,
            hintText: "اكتب كلمة".tr,
            hintTextDirection: ui.TextDirection.rtl,
            prefixIcon: InkWell(
              onTap: () {
                _query.text = '';
                datas.value = temps;
              },
              child: Icon(
                FontAwesome.remove,
                size: 14,
                color: Get.theme.backgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createBody(final XController x) {
    return Container(
      width: Get.width,
      height: Get.height,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(5)),
          Obx(
            () => !isLoading.value && temps.isNotEmpty
                ? inputSearch(x)
                : const SizedBox.shrink(),
          ),
          SizedBox(height: getProportionateScreenHeight(15)),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Obx(() => isLoading.value
                      ? MyTheme.loadingCircular()
                      : datas.isEmpty
                          ? ByCategory.noDataFound()
                          : listNotif(x, datas)),
                  SizedBox(height: getProportionateScreenHeight(55)),
                  SizedBox(height: getProportionateScreenHeight(155)),
                ],
              ),
            ),
          ),
        ],
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
          Container(
            padding: const EdgeInsets.only(top: 0, right: 150),
            child: Text(
              "الإشعارات".tr,
              style: const TextStyle(
                fontSize: 18,
                color: colorTrans2,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listNotif(final XController x, final List<NotifModel> notifs) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: notifs.map((NotifModel e) {
          final int index = notifs.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final callback =
                    await MyHome.showDialogNotif(XController.to, e);
                debugPrint(callback);
                if (callback != null && callback['success'] == 'delete') {
                  notifs.removeAt(index);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 19, vertical: 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Get.theme.colorScheme.secondary.withOpacity(.5),
                      blurRadius: 3.0,
                      offset: const Offset(1, 3),
                    )
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${e.title}",
                        textDirection: ui.TextDirection.rtl,

                        // textDirection: TextDirection.RTL,
                        style: textBold.copyWith(fontSize: 14),
                      ),
                      Text(
                        "${e.description}",
                        maxLines: 5, textDirection: ui.TextDirection.rtl,

                        // textDirection: TextDirection.rtl,

                        overflow: TextOverflow.ellipsis,
                        style: textSmall.copyWith(fontSize: 12),
                      ),
                      Container(
                        height: 33,
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  EasyLoading.show(status: 'جاري الحذف');
                                  Future.delayed(
                                      const Duration(milliseconds: 600),
                                      () async {
                                    final jsonBody = jsonEncode({
                                      "id": "${e.id}",
                                      "iu": "${x.thisUser.value.id}",
                                      "status": "0",
                                      "lat": x.latitude,
                                    });
                                    debugPrint(jsonBody);

                                    await x.provider
                                        .pushResponse('notif/update', jsonBody);

                                    x.asyncHome();
                                    EasyLoading.showSuccess('تم الحذف بنجاح');
                                    notifs.removeAt(index);
                                  });
                                },
                                icon: const Icon(FontAwesome.trash_o,
                                    size: 18, color: MyTheme.iconColor)),
                            Text(
                              DateFormat.yMEd().add_jms().format(
                                  MyTheme.convertDatetime(e.dateCreated!)),
                              style: textSmallGrey,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
