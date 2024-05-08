import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/size_config.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/models/rental_model.dart';
import 'package:Afaq/pages/detail_rental.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/icon_back.dart';
import 'package:Afaq/widgets/info_square.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final XController x = XController.to;
  final MyPref myPref = MyPref.to;

  SearchScreen({Key? key}) : super(key: key) {
    datas.value = x.itemHome.value.rents ?? [];
  }

  final datas = <RentalModel>[].obs;

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(5)),
            inputSearch(),
            SizedBox(height: getProportionateScreenHeight(15)),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Obx(() => listSearchs(datas)),
                    SizedBox(height: getProportionateScreenHeight(55)),
                    SizedBox(height: getProportionateScreenHeight(155)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listSearchs(final List<RentalModel> rentals) {
    final double thisWidth = Get.width;
    return SizedBox(
      width: Get.width,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: rentals.map((e) {
          return InkWell(
            onTap: () {
              Get.to(() => (DetailRental(rental: e)));
            },
            child: Container(
              width: thisWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: colorBoxShadow,
                    blurRadius: 1.0,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: GetPlatform.isAndroid
                          ? thisWidth / 1.65
                          : thisWidth / 1.55,
                      padding: const EdgeInsets.only(
                          top: 10, left: 10, right: 0, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: thisWidth / 5,
                                  child: Text(
                                    " ${MyTheme.formatCounterNumber(e.price!)} ${myPref.pCurrency.val}",

                                    // " ${e.price} ${myPref.pCurrency.val}",
                                    maxLines: 2,
                                    textDirection: TextDirection.rtl,

                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4297AA),
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                SizedBox(
                                  width: thisWidth / 2.8,
                                  child: Text(
                                    "${e.title}",
                                    maxLines: 3,
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.1,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(MaterialIcons.location_pin,
                                        color: Colors.black45, size: 14),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      width: thisWidth / 2.5,
                                      child: Text(
                                        "${e.address}",
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black45),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${e.rating}",
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 1),
                                      const Icon(MaterialIcons.star,
                                          color: Colors.amber, size: 12),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: InfoSquare(
                              rental: e,
                              iconSize: 12,
                              spaceWidth: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ExtendedImage.network(
                        "${e.image}",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        cache: true,
                      ),
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

  final TextEditingController _query = TextEditingController();
  Widget inputSearch() {
    final List<RentalModel> latests = x.itemHome.value.latests!;
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
        child: TextField(
          controller: _query,
          onChanged: (String? text) {
            if (text!.isNotEmpty && text.isNotEmpty) {
              var models = latests.where((RentalModel element) {
                return element.title!
                    .toLowerCase()
                    .contains(text.trim().toLowerCase());
              }).toList();

              if (models.isNotEmpty) {
                datas.value = models;
              }
            } else {
              datas.value = latests;
            }
          },
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            suffixIcon: Icon(
              FontAwesome.search,
              size: 14,
              color: Color(0xFF4297AA),
            ),
            border: InputBorder.none,
            hintText: "اكتب كلمة".tr,
            hintTextDirection: TextDirection.rtl,
            prefixIcon: InkWell(
              onTap: () {
                _query.text = '';
                datas.value = latests;
              },
              child: Icon(
                FontAwesome.remove,
                size: 14,
                color: Color(0xFF4297AA),
              ),
            ),
          ),
        ),
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
            padding: const EdgeInsets.only(top: 0, right: 150),
            child: Text(
              "بحث".tr,
              style: const TextStyle(
                fontSize: 18,
                color: colorTrans2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
