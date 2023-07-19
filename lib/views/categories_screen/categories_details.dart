// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/controller/product_controller.dart';
import 'package:nhom17/views/categories_screen/item_details.dart';
import 'package:nhom17/widget_common/bg_widget.dart';

import '../../services/filestore_services.dart';

class CategoriesDetails extends StatelessWidget {
  final String? title;
  const CategoriesDetails({Key? key, required this.title});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return bgWidget(
        child: Scaffold(
      appBar: AppBar(
        title: title!.text.fontFamily(bold).white.make(),
      ),
      body: StreamBuilder(
        stream: FilestoreServices.getProducts(title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          }
          else if(snapshot.data!.docs.isEmpty){
            return Center(
              child: 'No products found!'.text.color(darkFontGrey).make(),
            );
          }
          else{
            var data = snapshot.data!.docs;
            return Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          controller.subcat.length,
                          (index) => "${controller.subcat[index]}"
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .makeCentered()
                              .box
                              .white
                              .rounded
                              .size(150, 60)
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .make()),
                    ),
                  ),
                  20.heightBox,
                  Expanded(
                    child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 250,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                data[index]['p_img'][0],
                                height: 150,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              6.heightBox,
                              "${data[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${data[index]['p_price']}".numCurrency
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
                              .outerShadowSm
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                                controller.checkIfFav(data[index]);
                            Get.to(() => ItemDetails(
                              title: "${data[index]['p_name']}", 
                              data: data[index],
                            ));
                          });
                        }),
                  )
                ],
              ),
            );
          }
        }
      )
    ));
  }
}

Widget loadingIndicator(){
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}