import 'dart:convert';

import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/icon_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatelessWidget {
  final TextEditingController _deController = TextEditingController();

  FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var thisRating = 5.0;
    final XController x = XController.to;

    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: SafeArea(
        top: false,
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
            height: Get.height,
            width: Get.width,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "تقييمك لنا".tr,
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        //debugPrint(rating);
                        thisRating = rating;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                        controller: _deController,
                        enabled: true,
                        textDirection: TextDirection.rtl,
                        maxLines: 5,
                        maxLength: 150,
                        style: const TextStyle(
                          fontSize: 16.0,
                          // fontWeight: FontWeight.w500,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'أرسل لنا تعليقك أو تقييمك'.tr,
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: const TextStyle(
                            fontSize: 16.0,

                            // fontWeight: FontWeight.w500,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                String desc = _deController.text;
                                if (desc.isEmpty) {
                                  EasyLoading.showToast("المحتوى فارغ");
                                  return;
                                }
                                //Get.back();
                                EasyLoading.show(status: 'جاري إرسال تعليقك');
                                var dataPush = jsonEncode({
                                  "iu": "${x.thisUser.value.id}",
                                  "ds": desc.trim(),
                                  "rt": "$thisRating",
                                });

                                debugPrint(dataPush);

                                await x.provider.pushResponse(
                                  "user/feedback",
                                  dataPush,
                                );

                                await Future.delayed(
                                    const Duration(milliseconds: 1800));
                                EasyLoading.dismiss();
                                EasyLoading.showToast("شكراً لك".tr);
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Get.theme.textTheme.button!.color!
                                          .withOpacity(0.2),
                                      blurRadius: 1.0,
                                      offset: const Offset(0.0, 6),
                                    )
                                  ],
                                  color: Get.theme.colorScheme.secondary
                                      .withOpacity(.8),
                                  borderRadius: BorderRadius.circular(42),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 100),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 2, right: 5),
                                        child: const Icon(Feather.check,
                                            size: 20, color: Colors.white),
                                      ),
                                      Text(
                                        "إرسال",
                                        style: Get.theme.textTheme.subtitle2!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget topIcon() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 0),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: const IconBack(),
          ),
          Container(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              "".tr,
              style: const TextStyle(
                fontSize: 18,
                color: colorTrans2,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
