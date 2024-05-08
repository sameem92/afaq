import 'package:Afaq/core/my_pref.dart';
import 'package:Afaq/core/size_config.dart';
import 'package:Afaq/core/xcontroller.dart';
import 'package:Afaq/models/category_model.dart';
import 'package:Afaq/models/rental_model.dart';
import 'package:Afaq/pages/detail_rental.dart';
import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/icon_back.dart';
import 'package:Afaq/widgets/info_square.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ByCategory extends StatelessWidget {
  final CategoryModel? categoryModel;
  final List<RentalModel>? rentals;
  final String? title;
  ByCategory({Key? key, this.categoryModel, this.rentals, this.title})
      : super(key: key) {
    int duration = 1500;
    if (rentals != null && rentals!.isNotEmpty) {
      duration = 0;
    }
    Future.delayed(Duration(milliseconds: duration), () {
      final XController x = XController.to;
      if (x.itemPass.value.result != null) {
        datas.value = x.itemPass.value.rents!;
        temps.value = x.itemPass.value.rents!;
      } else if (rentals != null && rentals!.isNotEmpty) {
        datas.value = rentals!;
        temps.value = rentals!;
      } else {
        //try to push one more time
        if (categoryModel!.id != null) {
          Future.microtask(() => x.getRentByCategory(categoryModel!.id!));
          Future.delayed(Duration(milliseconds: duration), () {
            if (x.itemPass.value.result != null) {
              datas.value = x.itemPass.value.rents!;
              temps.value = x.itemPass.value.rents!;
            }
          });
        }
      }

      isLoading.value = false;
    });
  }

  final datas = <RentalModel>[].obs;
  final temps = <RentalModel>[].obs;
  final isLoading = true.obs;
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    final XController x = XController.to;
    final MyPref myPref = MyPref.to;

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
          title: topIcon(x),
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
                              ? noDataFound()
                              : listRents(datas, myPref)),
                      SizedBox(height: getProportionateScreenHeight(55)),
                      SizedBox(height: getProportionateScreenHeight(155)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget noDataFound() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: Get.width / 1.2,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/nodata_found.png",
              height: Get.height / 3,
            ),
            Text("لا يوجد", style: TextStyle(color: Get.theme.primaryColor)),
          ],
        ),
      ),
    );
  }

  Widget listRents(final List<RentalModel> rentals, final MyPref myPref) {
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
                                    " ${MyTheme.formatCounterNumber(e.price!)}  ${myPref.pCurrency.val}",

                                    // "${myPref.pCurrency.val} ${e.price}",
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.left,

                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: thisWidth / 2.8,
                                  child: Text(
                                    "${e.title}",
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
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
                                      const Icon(MaterialIcons.star,
                                          color: Colors.amber, size: 12),
                                      const SizedBox(width: 1),
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
            final List<RentalModel>? latests = x.itemPass.value.rents ?? null;
            if (text!.isNotEmpty &&
                text.trim().isNotEmpty &&
                latests!.isNotEmpty &&
                latests != null) {
              var models = latests.where((RentalModel element) {
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
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            suffixIcon: Icon(
              FontAwesome.search,
              size: 14,
              color: Get.theme.backgroundColor,
            ),
            border: InputBorder.none,
            hintText: "اكتب كلمة".tr,
            hintTextDirection: TextDirection.rtl,
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

  Widget topIcon(final XController x) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
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
              "${title ?? categoryModel!.title}",
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
