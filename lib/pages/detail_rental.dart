import 'dart:convert';
import 'dart:ui' as ui;

import 'package:Afaq/app/my_home.dart';
import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/size_config.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/models/rental_model.dart';
import 'package:Afaq/models/review_model.dart';
import 'package:Afaq/models/user_model.dart';
import 'package:Afaq/pages/gallery_photo.dart';
import 'package:Afaq/pages/review_rental.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/button_container.dart';
import 'package:Afaq/widgets/icon_back.dart';
import 'package:Afaq/widgets/info_square.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailRental extends StatelessWidget {
  final RentalModel rental;
  DetailRental({Key? key, required this.rental}) : super(key: key) {
    isLiked.value = x.getLikedByRentId(rental.id!).isNotEmpty;

    //load data review by id rental
    Future.microtask(() {
      x.getRentReviewById(rental.id!, x.thisUser.value.id!);
    });
  }

  final XController x = XController.to;
  final myPref = MyPref.to;
  final dataReviews = <ReviewModel>[].obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainBackgroundcolor,
            mainBackgroundcolor2,
            mainBackgroundcolor3,
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
            floatingActionButton: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    debugPrint("احجز الان");
                    showDialogBooking(x.thisUser.value, rental);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                    child: ButtonContainer(
                      text: "احجز الآن".tr,
                      boxShadow: BoxShadow(
                        color: Color(0xD74297AA),
                        blurRadius: 1.0,
                        offset: const Offset(1, 3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: createBody(),
          ),
        ),
      ),
    );
  }

  Widget createBody() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(top: 5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: getProportionateScreenHeight(15)),
            InkWell(
              onTap: () {
                debugPrint("clicked image");
                Get.dialog(MyTheme.photoView(rental.image));
              },
              child: createImage(rental),
            ),
            SizedBox(height: getProportionateScreenHeight(15)),
            Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                "مواصفات العقار :".tr,
                textAlign: TextAlign.end,
                textDirection: ui.TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              padding:
                  const EdgeInsets.only(left: 25, right: 20, top: 5, bottom: 5),
              child: Text(
                "${rental.description}",
                textAlign: TextAlign.start,
                textDirection: ui.TextDirection.rtl,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(15)),
            if (rental.image2 != null && rental.image2 != '')
              Container(
                margin: const EdgeInsets.only(right: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  "ستوديو العقار :".tr,
                  textDirection: ui.TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    // fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            if (rental.image2 != null && rental.image2 != '')
              SizedBox(height: getProportionateScreenHeight(10)),
            if (rental.image2 != null && rental.image2 != '') listGalleries(),
            SizedBox(height: getProportionateScreenHeight(30)),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  x.getReviewByRent(rental, "");

                  Get.to(
                      () => (ReviewRental(
                            rentalModel: rental,
                            title: "${rental.title} تقييمات  ",
                            reviews: x.itemReview.value.reviews!,
                          )),
                      transition: Transition.size);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                        "تقييمات :".tr,
                        textDirection: ui.TextDirection.rtl,
                        style: Get.theme.textTheme.headline6!.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            newReview(),
            SizedBox(height: getProportionateScreenHeight(15)),
            Obx(
              () => x.itemReview.value.result != null &&
                      x.itemReview.value.reviews!.isNotEmpty
                  ? listReview(x.itemReview.value.reviews!)
                  : const SizedBox.shrink(),
            ),
            SizedBox(height: getProportionateScreenHeight(120)),
          ],
        ),
      ),
    );
  }

  Widget newReview() {
    return InkWell(
      onTap: () {
        MyHome.showDialogInputReview(x, rental, x.thisUser.value);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [
              Colors.white60,
              Colors.white70,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Get.theme.backgroundColor,
              blurRadius: 0.0,
              offset: const Offset(1, 1),
            )
          ],
        ),
        child: SizedBox(
          width: Get.width,
          child: TextField(
            enabled: false,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(
                FontAwesome.star,
                size: 20,
                color: Get.theme.primaryColor,
              ),
              border: InputBorder.none,
              hintText: "اكتب تعليقك".tr,
              hintTextDirection: ui.TextDirection.rtl,
              suffixIcon: Icon(
                FontAwesome.send,
                size: 16,
                color: Get.theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listReview(final List<ReviewModel> reviews) {
    final double thisWidth = Get.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      width: Get.width,
      child: ListView(
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: reviews.map((e) {
            return Container(child: createSingleReview(thisWidth, e));
          }).toList()),
    );
  }

  static createSingleReview(final double thisWidth, final ReviewModel e) {
    return InkWell(
      onTap: () {
        //Get.to(DetailRental(rental: e));
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
        child: Stack(
          children: [
            Container(
              width: thisWidth / 1.1,
              padding:
                  const EdgeInsets.only(top: 5, left: 22, right: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 0, right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.user!.fullname!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.1,
                                color: Colors.black87,
                              ),
                              // fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ExtendedImage.network(
                            e.user!.image!,
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            cache: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            "${e.rating}",
                            style: const TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ),
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: e.rating!,
                          minRating: 1,
                          direction: Axis.horizontal,
                          unratedColor: Colors.amber.withAlpha(50),
                          itemCount: 5,
                          itemSize: 14.0,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                          updateOnDrag: false,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                    ),
                    child: Text(
                      "${e.review}",
                      textDirection: ui.TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                children: [
                  // InkWell(
                  //     onTap: () {
                  //       debugPrint("clicked thumb up");
                  //       MyTheme.showToast('Dummy action...');
                  //     },
                  //     child: const Icon(Feather.thumbs_up, size: 18)),
                  const SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        debugPrint("clicked thumb down");
                        MyTheme.showToast('Dummy action...');
                      },
                      child: const Icon(Feather.thumbs_down,
                          size: 18, color: colorGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listGalleries() {
    List<dynamic> temps = [];
    try {
      if (rental.image2 != null) {
        temps.add({"image": "${rental.image2}"});
      }

      if (rental.image3 != null) {
        temps.add({"image": "${rental.image3}"});
      }

      if (rental.image4 != null) {
        temps.add({"image": "${rental.image4}"});
      }

      if (rental.image5 != null) {
        temps.add({"image": "${rental.image5}"});
      }

      if (rental.image6 != null) {
        temps.add({"image": "${rental.image6}"});
      }
    } catch (e) {
      debugPrint("");
    }

    List<dynamic> galleries = [];
    if (temps.isNotEmpty) {
      galleries = temps.toList()..shuffle();
    }

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: galleries.map((e) {
          final int idx = galleries.indexOf(e);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showDialogPhoto(galleries, idx);
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: idx == 0 ? 16 : 0,
                  right: idx >= galleries.length - 1 ? 50 : 0,
                ),
                padding: EdgeInsets.only(
                  left: idx == 0 ? 15 : 0,
                  right: idx >= galleries.length - 1 ? 30 : 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ExtendedImage.network(
                    "${e['image']}",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    cache: true,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  showDialogPhoto(final List<dynamic> photos, final int index) {
    return Get.dialog(
      Container(
        width: Get.width,
        height: Get.height,
        color: Colors.black87,
        padding: const EdgeInsets.only(bottom: 0),
        child: Stack(
          children: [
            GalleryPhoto(images: photos, initialIndex: index),
            Positioned(
              top: 10,
              left: 10,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: mainBackgroundcolor,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        FontAwesome.chevron_left,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createImage(final RentalModel e) {
    final double thisWidth = Get.width; //  / 1.2;
    String unitPrice = "${e.unitPrice}".tr;
    return Container(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: thisWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
        ),
        margin: const EdgeInsets.only(
          bottom: 3,
          right: 12,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ExtendedImage.network(
                      "${e.image}",
                      width: thisWidth - 1,
                      height: Get.height / 3.9,
                      fit: BoxFit.cover,
                      cache: true,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              " ${MyTheme.formatCounterNumber(e.price!)} ${myPref.pCurrency.val}",
                              textDirection: ui.TextDirection.rtl,
                              // "${e.price!}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 1.8,
                              child: Text(
                                "${e.title}",
                                textDirection: ui.TextDirection.rtl,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.1,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          debugPrint("clicked location here");
                          String? latitude = e.latitude;

                          if (latitude != null) {
                            var split = latitude.split(",");
                            String googleUrl =
                                'https://www.google.com/maps/search/?api=1&query=${split[0]},${split[1]}';
                            MyTheme.launchUrlGeo(googleUrl);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesome.heart,
                                        size: 15, color: Colors.white),
                                    spaceWidth5,
                                    Text(
                                        MyTheme.formatCounterNumber(
                                            e.totalLike!),
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.white))
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${e.address}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(MaterialIcons.location_pin,
                                      color: Colors.white, size: 18),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: InfoSquare(
                          rental: e,
                          iconSize: 17,
                          spaceWidth: 6,
                        ),
                      ),
                      if (e.distance != null)
                        InkWell(
                          onTap: () {
                            debugPrint("clicked location here");
                            String? latitude = e.latitude;

                            if (latitude != null) {
                              var split = latitude.split(",");
                              String googleUrl =
                                  'https://www.google.com/maps/search/?api=1&query=${split[0]},${split[1]}';
                              MyTheme.launchUrlGeo(googleUrl);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Feather.navigation,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                spaceWidth5,
                                Text(
                                  "كم ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "${MyTheme.numberFormatDec(e.distance!, 2)}  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 18,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(MaterialIcons.star,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      "${e.rating} (${e.totalRating} ${'review'.tr})",
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final isLiked = false.obs;
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
            padding: const EdgeInsets.only(top: 0),
            child: const Text(
              "تفاصيل العقار",
              style: TextStyle(
                fontSize: 18,
                color: colorTrans2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
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
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Obx(
                () => AnimatedIconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  size: 14,
                  onPressed: () {
                    isLiked.value = !isLiked.value;
                    debugPrint("isLiked: ${isLiked.value}");

                    Future.microtask(() =>
                        MyHome.pushLikeOrDislike(x, rental, isLiked.value));
                  },
                  duration: const Duration(milliseconds: 500),
                  splashColor: Colors.transparent,
                  icons: <AnimatedIconItem>[
                    AnimatedIconItem(
                      icon: Icon(
                        FontAwesome.heart,
                        size: 14,
                        color: isLiked.value
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //dialog rent book
  static final List<dynamic> methods = [
    {"title": "Credit Card", "icon": ""},
    // {"title": "Paypal", "icon": ""},
    // {"title": "Cash", "icon": ""}
  ];

  static final isProcessBook = false.obs;
  static final idxMethod = 0.obs;
  // static final TextEditingController _fullname = TextEditingController();
  // static final TextEditingController _date = TextEditingController();

  static showDialogBooking(final UserModel user, final RentalModel rental) {
    // _fullname.text = '';
    // _date.text = '';
    _email.text = '';

    idxMethod.value = 0;
    stepProcess.value = 1;

    final myPref = Get.find<MyPref>();

    return showCupertinoModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height,
        color: mainBackgroundcolor.withOpacity(.9),
        child: Container(
          width: Get.width,
          height: Get.height,
          margin: const EdgeInsets.only(top: 20, bottom: 0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height,
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(22),
                          child: Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                MyTheme.conerRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.secondary
                                      .withOpacity(.5),
                                  blurRadius: 2.0,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: Obx(
                              () => isProcessBook.value
                                  ? childProcessing()
                                  : childBooking(context, rental, myPref),
                            ),
                          ),
                        ),
                        //spaceHeight5,
                        Obx(
                          () => Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (stepProcess.value == 2 &&
                                      idxMethod.value == 0) {
                                    stepProcess.value = 1;

                                    dataFormCard.value = {
                                      "no": "",
                                      "exp": "",
                                      "cname": "",
                                      "cvv": "",
                                      "focus": "1",
                                    };
                                  } else {
                                    Get.back();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("إلغاء",
                                          style:
                                              textSmall.copyWith(fontSize: 18))
                                    ],
                                  ),
                                ),
                              ),
                              if (!isProcessBook.value) spaceWidth10,
                              if (!isProcessBook.value)
                                InkWell(
                                  onTap: () async {
                                    // String fullnm = _fullname.text.trim();
                                    // if (fullnm.isEmpty || fullnm.length < 3) {
                                    //   EasyLoading.showToast(
                                    //       'الرجاء التأكد من الاسم الكريم');
                                    //   return;
                                    // }

                                    String dateRange = DateFormat('dd/MM/yyyy')
                                            .format(DateTime.now())
                                            .toString() +
                                        ' - ' +
                                        DateFormat('dd/MM/yyyy')
                                            .format(DateTime.now()
                                                .add(Duration(days: 15)))
                                            .toString();
                                    // if (dateRange.isEmpty ||
                                    //     dateRange.length < 3) {
                                    //   EasyLoading.showToast(
                                    //       'Date Range selection invalid...');
                                    //   return;
                                    // }

                                    debugPrint(
                                        "method value ${idxMethod.value}");

                                    if (idxMethod.value == 2) {
                                      MyTheme.showToast('الرجاء الانتظار');
                                      await doPostNewRent(
                                          XController.to,
                                          rental,
                                          dateRange,
                                          "Cash",
                                          "Method Cash");
                                      //Get.back();
                                    } else if ((stepProcess.value == 2 ||
                                            stepProcess.value == 3) &&
                                        (idxMethod.value == 0 ||
                                            idxMethod.value == 1)) {
                                      String em = _email.text.trim();
                                      if (idxMethod.value == 1 &&
                                          (em.isEmpty ||
                                              !GetUtils.isEmail(em))) {
                                        EasyLoading.showToast(
                                            'Email invalid...');
                                        return;
                                      }

                                      MyTheme.showToast('Please wait...');

                                      await doPostNewRent(
                                          XController.to,
                                          rental,
                                          dateRange,
                                          idxMethod.value == 1
                                              ? "Paypal"
                                              : "Credit Card",
                                          idxMethod.value == 1
                                              ? em
                                              : jsonEncode(dataFormCard));
                                      await Future.delayed(
                                          const Duration(seconds: 1), () {
                                        stepProcess.value = 1;
                                        dataFormCard.value = {
                                          "no": "",
                                          "exp": "",
                                          "cname": "",
                                          "cvv": "",
                                          "focus": "1",
                                        };
                                      });
                                    } else if (idxMethod.value == 0) {
                                      stepProcess.value = 2;
                                    } else if (idxMethod.value == 1) {
                                      stepProcess.value = 3;
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    margin: const EdgeInsets.only(
                                        left: 0, right: 0, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Get.theme.primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(
                                          () => Text(
                                            (stepProcess.value == 2 ||
                                                        stepProcess.value ==
                                                            3) &&
                                                    (idxMethod.value == 0 ||
                                                        idxMethod.value == 1)
                                                ? "دفع"
                                                : "احجز",
                                            style: textBold.copyWith(
                                                color: Get.theme.canvasColor,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        spaceHeight20,
                        spaceHeight10,
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
                        child: const Icon(
                          Feather.chevron_down,
                          size: 30,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static doPostNewRent(
      final XController x,
      final RentalModel rental,
      final String duration,
      final String payment,
      final String descPayment) async {
    isProcessBook.value = true;

    await Future.delayed(const Duration(seconds: 2));

    try {
      final jsonBody = jsonEncode({
        "lat": x.latitude,
        "ir": "${rental.id}",
        "dr": duration,
        "iu": "${x.thisUser.value.id}",
        "cr": x.myPref.pCurrency.val,
        "tt": "${rental.price}",
        "py": payment,
        "dp": descPayment,
        "up": "${rental.unitPrice}",
      });
      debugPrint(jsonBody);
      final response =
          await x.provider.pushResponse('trans/insert_trans', jsonBody);

      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.bodyString!);

        if (_result['code'] == '200') {
          x.asyncHome();
        }

        await Future.delayed(const Duration(seconds: 1));
        isProcessBook.value = false;
        Get.back();
        EasyLoading.showSuccess("تم الحجز بنجاح");

        Future.microtask(() => showDialogSuccess());
      }
    } catch (e) {
      debugPrint("error $e");
    }
  }

  static showDialogSuccess() {
    return showCupertinoModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 1.15,
        color: mainBackgroundcolor.withOpacity(.9),
        child: Container(
          width: Get.width,
          height: Get.height,
          margin: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height,
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(22),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              MyTheme.conerRadius,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Get.theme.colorScheme.secondary
                                    .withOpacity(.5),
                                blurRadius: 5.0,
                                offset: const Offset(2, 5),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: Get.width,
                                child: Text(
                                  "تم الحجز بنجاح\nشكرا لكً",
                                  textAlign: TextAlign.center,
                                  style:
                                      Get.theme.textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              spaceHeight20,
                              Image.asset("assets/green-success.gif",
                                  width: 180),
                              spaceHeight20,
                            ],
                          ),
                        ),
                      ),
                      spaceHeight10,
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
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("إنهاء",
                                      style: textSmall.copyWith(fontSize: 18))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                    ],
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
                        child: const Icon(
                          Feather.chevron_down,
                          size: 30,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static final TextEditingController _email = TextEditingController();
  static Widget childFormPaypal(final RentalModel rental, final MyPref myPref) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
                color: Get.theme.colorScheme.secondary,
                style: BorderStyle.solid,
              ),
            ),
            child: TextField(
              controller: _email,
              decoration: MyTheme.inputFormAccent('Email Paypal',
                  Get.theme.canvasColor, Get.theme.primaryColor),
            ),
          ),
        ),
        spaceHeight10,
      ],
    );
  }

  static final dataFormCard = {
    "no": "",
    "exp": "",
    "cname": "",
    "cvv": "",
    "focus": "1",
  }.obs;

  static final GlobalKey<FormState> formCardKey = GlobalKey<FormState>();

  static Widget childFormCreditCard(
      final RentalModel rental, final MyPref myPref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => CreditCardWidget(
              onCreditCardWidgetChange: (_) {},
              cardNumber: dataFormCard['no'].toString(),
              expiryDate: dataFormCard['exp'].toString(),
              cardHolderName: dataFormCard['cname'].toString(),
              cvvCode: dataFormCard['cvv'].toString(),
              showBackView: int.parse(dataFormCard['focus'].toString()) == 1,
              cardBgColor: mainBackgroundcolor,
              obscureCardNumber: true,
              obscureCardCvv: true,
              height: 135,
              textStyle: const TextStyle(
                color: MyTheme.iconColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              width: Get.width,
              animationDuration: const Duration(milliseconds: 1000),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: CreditCardForm(
              cardNumber: dataFormCard['no'].toString(),
              expiryDate: dataFormCard['exp'].toString(),
              cardHolderName: dataFormCard['cname'].toString(),
              cvvCode: dataFormCard['cvv'].toString(),
              formKey: formCardKey, // Required
              onCreditCardModelChange: (CreditCardModel creditCardModel) {
                String cardNumber = creditCardModel.cardNumber;
                String expiryDate = creditCardModel.expiryDate;
                String cardHolderName = creditCardModel.cardHolderName;
                String cvvCode = creditCardModel.cvvCode;
                bool isCvvFocused = creditCardModel.isCvvFocused;

                dataFormCard.value = {
                  "no": cardNumber,
                  "exp": expiryDate,
                  "cname": cardHolderName,
                  "cvv": cvvCode,
                  "focus": isCvvFocused ? "1" : "0",
                };
              }, // Required
              themeColor: Color(0xFF4297AA),
              obscureCvv: true,
              obscureNumber: true,
              cardNumberDecoration: MyTheme.inputFormAccent(
                'XXXX XXXX XXXX XXXX',
                Get.theme.canvasColor,
                Get.theme.primaryColor,
              ).copyWith(
                labelText: 'Number',
                contentPadding: const EdgeInsets.all(5),
              ),
              expiryDateDecoration: MyTheme.inputFormAccent(
                'XX/XX',
                Get.theme.canvasColor,
                Get.theme.primaryColor,
              ).copyWith(
                labelText: 'Expired Date',
                contentPadding: const EdgeInsets.all(5),
              ),
              cvvCodeDecoration: MyTheme.inputFormAccent(
                'XXX',
                Get.theme.canvasColor,
                Get.theme.primaryColor,
              ).copyWith(
                labelText: 'CVV',
                contentPadding: const EdgeInsets.all(5),
              ),
              cardHolderDecoration: MyTheme.inputFormAccent(
                'Card Holder Name',
                Get.theme.canvasColor,
                Get.theme.primaryColor,
              ).copyWith(
                labelText: 'Card Holder',
                contentPadding: const EdgeInsets.all(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget childFormBooking(
      BuildContext context, final RentalModel rental, final MyPref myPref) {
    return Column(
      children: [
        spaceHeight10,
        Container(
          width: Get.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 5,
            top: 5,
            bottom: 5,
            right: 5,
          ),
          child: Text(
            ' فترة الحجز :   ' +
                DateFormat('dd/MM/yyyy').format(DateTime.now()).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.now().add(Duration(days: 15)))
                    .toString(),
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.rtl,
            style: Get.theme.textTheme.headline6!.copyWith(
              fontSize: 13,
            ),
          ),
        ),

        spaceHeight20,
        //view payment
        Container(
          width: Get.width,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              Wrap(
                children: methods.map((e) {
                  final int index = methods.indexOf(e);
                  return Obx(
                    () => InkWell(
                      onTap: () {
                        idxMethod.value = index;
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: index == idxMethod.value
                              ? Get.theme.primaryColor
                              : mainBackgroundcolor,
                        ),
                        child: Text(
                          "${e['title']}",
                          style: textBold.copyWith(
                            color: index == idxMethod.value
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget childProcessing() {
    return Column(
      children: [
        Text(
          "جاري الحجز",
          style: Get.theme.textTheme.headline6!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        spaceHeight20,
        Image.asset("assets/loading2.gif", width: 120),
        spaceHeight20,
      ],
    );
  }

  static final stepProcess = 1.obs;
  static Widget childBooking(
      BuildContext context, final RentalModel rental, final MyPref myPref) {
    String unitPrice = "${rental.unitPrice}".tr;
    return Column(
      children: [
        Container(
          width: Get.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Text(
            " حجز ${rental.title} ",
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.rtl,
            style: Get.theme.textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        Container(
          width: Get.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 5,
            top: 5,
            bottom: 5,
            right: 5,
          ),
          child: Text(
            " بإمكانك دفع عربون بقيمة ١٠٠٠ ريال سعودي لحجز العقار ",
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.rtl,
            style: Get.theme.textTheme.headline6!.copyWith(
              fontSize: 13,
            ),
          ),
        ),
        Container(
          width: Get.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 5,
            top: 5,
            bottom: 5,
            right: 5,
          ),
          child: Text(
            " مع العلم أنها مستردة في حال عدم التوافق ",
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.rtl,
            style: Get.theme.textTheme.headline6!
                .copyWith(fontSize: 13, color: Colors.green),
          ),
        ),
        Container(
          width: Get.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 5,
            top: 5,
            bottom: 5,
            right: 5,
          ),
          child: Text(
            "قيمة الحجز ستكون من قيمة تكلفة العقار",
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.rtl,
            style: Get.theme.textTheme.headline6!
                .copyWith(fontSize: 13, color: Colors.green),
          ),
        ),
        Container(
          width: Get.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 5,
            top: 5,
            bottom: 5,
            right: 5,
          ),
          child: Text(
            " غير مستردة في حال عدم المجيء في فترة الحجز ١٥ يوم",
            textAlign: TextAlign.center,
            textDirection: ui.TextDirection.rtl,
            style: Get.theme.textTheme.headline6!
                .copyWith(fontSize: 13, color: Colors.red),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: Text("1000 ريال سعودي",
              textDirection: ui.TextDirection.rtl,
              textAlign: TextAlign.center,
              style: textSmall.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.primaryColor)),
        ),
        stepProcess.value == 2 ? const SizedBox(height: 1) : spaceHeight10,
        Obx(() => stepProcess.value == 1
            ? childFormBooking(context, rental, myPref)
            : stepProcess.value == 2
                ? childFormCreditCard(rental, myPref)
                : childFormPaypal(rental, myPref)),
      ],
    );
  }
}
