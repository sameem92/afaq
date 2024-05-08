import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/size_config.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/models/category_model.dart';
import 'package:Afaq/models/rental_model.dart';
import 'package:Afaq/pages/bycategory.dart';
import 'package:Afaq/pages/detail_rental.dart';
import 'package:Afaq/pages/notif_page.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/info_square.dart';
import 'package:badges/badges.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../pages/webview_page.dart';

class HomeScreen extends StatelessWidget {
  final XController x = XController.to;
  final myPref = MyPref.to;

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      padding: EdgeInsets.only(top: Get.mediaQuery.padding.top),
      width: Get.width,
      height: Get.height,
      child: RefreshIndicator(
        onRefresh: () async {
          x.asyncHome();
          await Future.delayed(const Duration(milliseconds: 2200));
          // x.asyncLatitude();bbbbbbbbbbbb
          return;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 22, right: 18, top: 10, bottom: 10),
                child: Obx(() => topIcon(myPref, x.shortAddress.value)),
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              Obx(
                () => x.itemHome.value.result == null
                    ? Container(child: MyTheme.loadingCircular())
                    : listCategories(x.itemHome.value.categories!),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => (ByCategory(
                          categoryModel: null,
                          rentals: x.itemHome.value.recommend!,
                          title: "الموصى به لك".tr)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المزيد".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 12,
                            color: colorGrey,
                          ),
                        ),
                        Text(
                          "الموصى به لك".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 18,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Obx(
                () => x.itemHome.value.recommend == null
                    ? Container(child: MyTheme.loadingCircular())
                    : listRecommends(x.itemHome.value.recommend!),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => (ByCategory(
                          categoryModel: null,
                          rentals: x.itemHome.value.nearbys!,
                          title: "عقارات بجوارك".tr)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المزيد".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 12,
                            color: colorGrey,
                          ),
                        ),
                        Text(
                          "عقارات بجوارك".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 18,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Obx(
                () => x.itemHome.value.result == null
                    ? Container(child: MyTheme.loadingCircular())
                    : listNearby(x.itemHome.value.nearbys!),
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => (ByCategory(
                          categoryModel: null,
                          rentals: x.itemHome.value.latests!,
                          title: "الجديد من عقاراتنا".tr)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "المزيد".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 12,
                            color: colorGrey,
                          ),
                        ),
                        Text(
                          "الجديد من عقاراتنا".tr,
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontSize: 18,
                            // fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Obx(
                () => x.itemHome.value.result == null
                    ? Container(child: MyTheme.loadingCircular())
                    : listLatest(x.itemHome.value.latests!),
              ),
              SizedBox(height: getProportionateScreenHeight(55)),
              SizedBox(height: getProportionateScreenHeight(70)),
            ],
          ),
        ),
      ),
    );
  }

  Widget listNearby(final List<RentalModel> nearbys) {
    if (nearbys.length > 1 && nearbys[0].distance != 0) {
      nearbys.sort((a, b) => a.distance!.compareTo(b.distance!));
    }

    final double thisWidth = Get.width;
    return SizedBox(
      width: Get.width,
      child: ListView(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: nearbys.map((RentalModel e) {
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
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: GetPlatform.isAndroid
                          ? thisWidth / 1.65
                          : Get.width / 1.55,
                      padding: const EdgeInsets.only(
                          top: 10, left: 10, right: 5, bottom: 5),
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
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4297AA),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  width: thisWidth / 2.8,
                                  child: Text(
                                    "${e.title}",
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.1,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(bottom: 1),
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
                                      width: thisWidth / 2.8,
                                      child: Text(
                                        "${e.address}",
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
                            margin: const EdgeInsets.only(bottom: 1),
                            child: InfoSquare(
                              rental: e,
                              iconSize: 12,
                              spaceWidth: 5,
                            ),
                          ),
                          if (e.distance != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${MyTheme.numberFormatDec(e.distance!, 2)} كم ",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ExtendedImage.network(
                        "${e.image}",
                        width: 80,
                        height: 80,
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

  Widget listRecommends(final List<RentalModel> rentals) {
    final double thisWidth = Get.width / 1.2;
    return SizedBox(
      height: (GetPlatform.isAndroid) ? Get.height / 2.3 : Get.height / 2.5,
      child:

          //============================================================================
          ListView(
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: rentals.map((RentalModel e) {
          final int index = rentals.indexOf(e);

          String unitPrice = "${e.unitPrice}".tr;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(() => (DetailRental(rental: e)),
                    transition: Transition.fadeIn);
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
                margin: EdgeInsets.only(
                  left: index == 0 ? 22 : 0,
                  right: index >= rentals.length - 1 ? 50 : 20,
                  bottom: 3,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: ExtendedImage.network(
                              "${e.image}",
                              width: thisWidth,
                              height: Get.height / 3.9,
                              fit: BoxFit.cover,
                              cache: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 18, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 1.5,
                                      child: Text(
                                        "${e.title}",
                                        maxLines: 2,
                                        textDirection: TextDirection.rtl,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            height: 1.1,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${e.address}",
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black45),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(MaterialIcons.location_pin,
                                        color: Colors.black45, size: 18),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: InfoSquare(rental: e),
                              ),
                              Row(
                                children: [
                                  Text(
                                    " ${MyTheme.formatCounterNumber(e.price!)} ${myPref.pCurrency.val}",
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4297AA),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colorTrans2.withOpacity(.8),
                        ),
                        child: Row(
                          children: [
                            const Icon(MaterialIcons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              "${e.rating}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      //============================================================================
    );
  }

  Widget listLatest(final List<RentalModel> latests) {
    final double thisWidth = Get.width / 1.45;
    final double thisHeight =
        (GetPlatform.isAndroid) ? Get.height / 2.9 : Get.height / 3.5;
    return SizedBox(
      height: thisHeight,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: latests.map((RentalModel e) {
          final int index = latests.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.to(() => (DetailRental(rental: e)),
                    transition: Transition.fadeIn);
              },
              child: Container(
                width: thisWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: colorBoxShadow,
                      blurRadius: 1.0,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
                margin: EdgeInsets.only(
                  left: index == 0 ? 22 : 0,
                  right: index >= latests.length - 1 ? 50 : 20,
                  bottom: 3,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: ExtendedImage.network(
                              "${e.image}",
                              width: thisWidth,
                              height: thisHeight / 1.8,
                              fit: BoxFit.cover,
                              cache: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      " ${MyTheme.formatCounterNumber(e.price!)} ${myPref.pCurrency.val}",
                                      textAlign: TextAlign.end,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4297AA),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: Get.width / 2.4,
                                      child: Text(
                                        "${e.title}",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        textDirection: TextDirection.rtl,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            height: 1.1,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(MaterialIcons.location_pin,
                                        color: Colors.black45, size: 14),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${e.address}",
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black45),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: InfoSquare(
                                  rental: e,
                                  iconSize: 14,
                                  spaceWidth: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colorTrans2.withOpacity(.7),
                        ),
                        child: Row(
                          children: [
                            const Icon(MaterialIcons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              "${e.rating}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget listNearbyMap(final MyPref myPref,
      final List<RentalModel> latests, final Function(int index) onTap) {
    final double thisWidth = Get.width / 1.55;
    final double thisHeight =
        (GetPlatform.isAndroid) ? Get.height / 3.1 : Get.height / 3.7;
    return SizedBox(
      height: thisHeight,
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: latests.map((RentalModel e) {
          final int index = latests.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onTap(index);
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
                margin: EdgeInsets.only(
                  left: index == 0 ? 22 : 0,
                  right: index >= latests.length - 1 ? 50 : 20,
                  bottom: 10,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: ExtendedImage.network(
                              "${e.image}",
                              width: thisWidth,
                              height: thisHeight / 2.1,
                              fit: BoxFit.cover,
                              cache: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 2.7,
                                      child: Text(
                                        "${e.title}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            height: 1.1,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Text(
                                      "${myPref.pCurrency.val} ${MyTheme.formatCounterNumber(e.price!)}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4297AA),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(MaterialIcons.location_pin,
                                        color: Colors.black45, size: 14),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${e.address}",
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black45),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 1),
                                child: InfoSquare(
                                  rental: e,
                                  iconSize: 11,
                                  spaceWidth: 2,
                                ),
                              ),
                              if (e.distance != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${MyTheme.numberFormatDec(e.distance!, 2)} km",
                                          style: const TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colorTrans2.withOpacity(.7),
                        ),
                        child: Row(
                          children: [
                            const Icon(MaterialIcons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              "${e.rating}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget listCategories(final List<CategoryModel> categories) {
    return SizedBox(
      height: Get.height / 6.5,
      child: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: categories.map((CategoryModel e) {
            final int index = categories.indexOf(e);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  x.getRentByCategory("${e.id}");
                  Get.to(() => (ByCategory(categoryModel: e)),
                      transition: index.isEven
                          ? Transition.leftToRight
                          : Transition.rightToLeft);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 22 : 0,
                    right: index >= categories.length - 1 ? 30 : 17,
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: colorBoxShadow,
                                blurRadius: 1.0,
                                offset: Offset(1, 1),
                              )
                            ],
                          ),
                          child: ExtendedImage.network(
                            "${e.image}",
                            width: 24,
                            fit: BoxFit.cover,
                            color: Color(0xD74297AA),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text("${e.title}",
                            style: const TextStyle(
                                fontSize: 13, color: colorGrey)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget topIcon(final MyPref myPref, final String lastAddress) {
    //debugPrint(dataInstall);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
        Row(
          children: [
            spaceWidth5,
            InkWell(
              onTap: () {
                Get.to(() => (WebViewPage(url: 'https://wa.me/966580009872')),
                    transition: Transition.fadeIn);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
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
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("تواصل معنا واتساب   ",
                            style: TextStyle(
                                color: Color(0xD74297AA), fontSize: 16)),
                        Icon(
                          FontAwesome.whatsapp,
                          size: 16,
                          color: Color(0xD74297AA),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
        Spacer(),
        Spacer(),
        Spacer(),
        Spacer(),
        Row(
          children: [
            spaceWidth5,
            InkWell(
              onTap: () {
                Get.to(() => (NotifPage()), transition: Transition.fadeIn);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                  child: Badge(
                    badgeContent: const Text(''),
                    badgeColor: Color(0xD74297AA),
                    position: BadgePosition.topEnd(top: -12, end: -1),
                    child: Icon(
                      FontAwesome.bell,
                      size: 20,
                      // color: Get.theme.disabledColor,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }
}
