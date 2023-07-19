// ignore_for_file: avoid_unnecessary_containers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nhom17/components/featured_button.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/consts/lists.dart';
import 'package:nhom17/controller/home_controller.dart';
import 'package:nhom17/services/filestore_services.dart';
import 'package:nhom17/views/categories_screen/categories_details.dart';
import 'package:nhom17/views/categories_screen/item_details.dart';
import 'package:nhom17/views/home_screen/search_screen.dart';
import 'package:nhom17/widget_common/home_buttons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            color: lightGrey,
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(Icons.search).onTap(() {
                    if (controller.searchController.text.isNotEmptyAndNotNull) {
                      Get.to(() => SearchScreen(
                        title: controller.searchController.text,
                      ));
                    }  
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchAnything,
                  hintStyle: const TextStyle(color: textfieldGrey)),
            ),
          ),
          10.heightBox,
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: slidersList.length,
                      itemBuilder: ((context, index) {
                        return Image.asset(
                          slidersList[index],
                          fit: BoxFit.fitWidth,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      })),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        2,
                        (index) => homeButtons(
                              height: context.screenHeight * 0.15,
                              width: context.screenWidth / 2.5,
                              icon: index == 0 ? icTodaysDeal : icFlashDeal,
                              title: index == 0 ? todayDeal : flashSale,
                            )),
                  ),
                  10.heightBox,
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: ((context, index) {
                        return Image.asset(
                          secondSlidersList[index],
                          fit: BoxFit.fitWidth,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      })),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        3,
                        (index) => homeButtons(
                              height: context.screenHeight * 0.15,
                              width: context.screenWidth / 4,
                              icon: index == 0
                                  ? icTopCategories
                                  : index == 1
                                      ? icBrands
                                      : icTopSeller,
                              title: index == 0
                                  ? topCategories
                                  : index == 1
                                      ? brand
                                      : topSellers,
                            )),
                  ),
                  20.heightBox,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: featuredCategories.text
                        .color(darkFontGrey)
                        .size(18)
                        .fontFamily(semibold)
                        .make(),
                  ),
                  20.heightBox,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          3,
                          (index) => Column(
                                children: [
                                  featuredButton(
                                      icon: featuredImages1[index],
                                      title: featuredTitle1[index]),
                                  10.heightBox,
                                  featuredButton(
                                      icon: featuredImages2[index],
                                      title: featuredTitle2[index])
                                ],
                              )).toList(),
                    ),
                  ),
                  20.heightBox,
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: const BoxDecoration(color: redColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featuredProduct.text.white
                            .fontFamily(bold)
                            .size(18)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                            future: FilestoreServices.getFeatureProducts(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: loadingIndicator());
                              } else if(snapshot.data!.docs.isEmpty) {
                                return "No feature products".text.white.makeCentered();
                              } else {
                                var featuredData = snapshot.data!.docs;
                                return Row(
                                  children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.network(
                                                featuredData[index]['p_img'][0],
                                                width: 150,
                                                fit: BoxFit.cover,
                                              ),
                                              10.heightBox,
                                              "${featuredData[index]['p_name']}"
                                                  .text
                                                  .fontFamily(semibold)
                                                  .color(darkFontGrey)
                                                  .make(),
                                              10.heightBox,
                                              "${featuredData[index]['p_price']}"
                                                  .text
                                                  .color(redColor)
                                                  .fontFamily(bold)
                                                  .size(16)
                                                  .make()
                                            ],
                                          )
                                              .box
                                              .white
                                              .margin(const EdgeInsets.symmetric(
                                                  horizontal: 4))
                                              .roundedSM
                                              .padding(const EdgeInsets.all(8))
                                              .make().onTap(() {
                                                Get.to(() => ItemDetails(title: "${featuredData[index]['p_name']}", data: featuredData[index],));
                                              })
                                  ),
                                );
                              }
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: ((context, index) {
                        return Image.asset(
                          secondSlidersList[index],
                          fit: BoxFit.fitWidth,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      })),
                  20.heightBox,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: "All Products".text.fontFamily(bold).color(darkFontGrey).size(18).make(),
                  ),
                  20.heightBox,
                  StreamBuilder(
                    stream: FilestoreServices.allProducts(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return loadingIndicator();
                      } else {
                        var allProductsData = snapshot.data!.docs;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allProductsData.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: 300),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  allProductsData[index]['p_img'][0],
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                const Spacer(),
                                5.heightBox,
                                "${allProductsData[index]['p_name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                10.heightBox,
                                "${allProductsData[index]['p_price']}"
                                    .text
                                    .color(redColor)
                                    .fontFamily(bold)
                                    .size(16)
                                    .make()
                              ],
                            )
                                .box
                                .white
                                .margin(const EdgeInsets.symmetric(horizontal: 4))
                                .roundedSM
                                .padding(const EdgeInsets.all(12))
                                .make().onTap(() {
                                  Get.to(() => ItemDetails(title: "${allProductsData[index]['p_name']}", data: allProductsData[index],));
                                });
                          }
                        );
                      }
                    }
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
