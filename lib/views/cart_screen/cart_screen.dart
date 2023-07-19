import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/controller/cart_controller.dart';
import 'package:nhom17/views/cart_screen/shipping_screen.dart';
import 'package:nhom17/views/categories_screen/categories_details.dart';
import 'package:nhom17/widget_common/our_button.dart';

import '../../services/filestore_services.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: 
      SizedBox(
        height: 60,
          width: context.screenWidth - 60,
          child: ourButton(
          color: redColor, 
          onPress: (){
            Get.to(() => const ShippingDetails());
          },
          textColor: whiteColor,
          title: 'Proceed to shipping'
        )
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FilestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          // if (snapshot.hasData){
          //   return Center(
          //     child: loadingIndicator(),
          //   );
          // }
          if(snapshot.data?.docs.isEmpty ?? true){
            return Center(
              child: "Cart is empty".text.color(darkFontGrey).make(),
            );
          }
          else{
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          leading: Image.network("${data[index]['img']}", width: 80, fit: BoxFit.cover,),
                          title: "${data[index]['title']} (x${data[index]['qty']})".text.fontFamily(semibold).make(),
                          subtitle: "${data[index]['tPrice']}".numCurrency.text.color(redColor).fontFamily(semibold).make(),
                          trailing: const Icon(Icons.delete, color: redColor,).onTap(() {
                            FilestoreServices.deleteDocument(data[index].id);
                          }),
                        );
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      'Total price'.text.fontFamily(semibold).color(darkFontGrey).make(),
                      Obx(() => "${controller.totalPrice.value}".numCurrency.text.fontFamily(semibold).color(redColor).make())
                    ],
                  ).box.padding(const EdgeInsets.all(12)).color(lightGolden).width(context.screenWidth - 60).roundedSM.make(),
                ],
              ),
            );
          }
        },
      )
    );
  }
}
