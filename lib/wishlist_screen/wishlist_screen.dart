import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/views/categories_screen/categories_details.dart';

import '../services/filestore_services.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FilestoreServices.getWishlist(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          }
          // else if(snapshot.data!.docs.isNotEmpty) {
          //   return "No wishlist yet!".text.color(darkFontGrey).makeCentered();
          // }
          else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.network("${data[index]['p_img'][0]}", width: 80, fit: BoxFit.cover,),
                        title: "${data[index]['p_name']}".text.fontFamily(semibold).size(16).make(),
                        subtitle: "${data[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(semibold).make(),
                        trailing: const Icon(Icons.favorite, color: redColor,).onTap(() async {
                          await filestore.collection(productCollection).doc(data[index].id).set({
                            'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                          }, SetOptions(merge: true));
                        }
                      )
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
      ),
    );
  }
}