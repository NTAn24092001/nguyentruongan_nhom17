import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/order_screen/order_detail.dart';
import 'package:nhom17/views/categories_screen/categories_details.dart';

import '../services/filestore_services.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Danh sách đơn hàng".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FilestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          }
          else if(snapshot.data!.docs.isEmpty) {
            return "Không có đơn hàng nào !".text.color(darkFontGrey).makeCentered();
          }
          else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: "${index + 1}".text.fontFamily(bold).color(darkFontGrey).xl.make(),
                  title: data[index]['order_code'].toString().text.color(redColor).make(),
                  subtitle: data[index]['total_amount'].toString().numCurrency.text.fontFamily(bold).make(),
                  trailing: IconButton(onPressed: () {
                    Get.to(() => OrderDetail(data: data[index]));
                  }, icon: const Icon(Icons.arrow_forward_ios_rounded), color: darkFontGrey,),
                );
              }
            );
          }
        }
      ),
    );
  }
}