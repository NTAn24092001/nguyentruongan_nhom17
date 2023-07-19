import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nhom17/auth_screen/login_screen.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/consts/lists.dart';
import 'package:nhom17/controller/auth_controller.dart';
import 'package:nhom17/controller/profile_controller.dart';
import 'package:nhom17/order_screen/order_screen.dart';
import 'package:nhom17/views/categories_screen/categories_details.dart';
import 'package:nhom17/views/chat_screen/messaging_screen.dart';
import 'package:nhom17/views/profile_screen/components/details_card.dart';
import 'package:nhom17/views/profile_screen/edit_profile_screen.dart';
import 'package:nhom17/widget_common/bg_widget.dart';
import 'package:nhom17/wishlist_screen/wishlist_screen.dart';

import '../../services/filestore_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    FilestoreServices.getCounts();
    return bgWidget(
        child: Scaffold(
      body: StreamBuilder(
        stream: FilestoreServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor)
              ),
            );
          }
          else{
            var data = snapshot.data!.docs[0];
            return SafeArea(
                child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.edit,
                        color: whiteColor,
                      ),
                    ).onTap(() {
                      controller.nameController.text = data['name'];
                      Get.to(() => EditProfileScreen(
                        data: data
                        )
                      );
                    }),
                  ),
                  Row(
                    children: [
                      data['imageUrl'] == '' ?
                      Image.asset(imgProfile2, width: 100, fit: BoxFit.cover)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make() : 
                      Image.network(data['imageUrl'], width: 100, fit: BoxFit.cover)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make(),    
                      10.widthBox,
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "${data['name']}".text.fontFamily(semibold).white.make(),
                          "${data['email']}".text.white.make(),
                        ],
                      )),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: whiteColor)),
                          onPressed: () async {
                            await Get.put(AuthController()).signOutMethod(context);
                            Get.offAll(() => const LoginScreen());
                          },
                          child: logout.text.fontFamily(semibold).white.make())
                    ],
                  ),
                  20.heightBox,
                  FutureBuilder(
                    future: FilestoreServices.getCounts(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: loadingIndicator());
                      } else {
                        var countData = snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detailsCard(
                                count: countData[0].toString(),
                                title: "in your cart",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: countData[1].toString(),
                                title: "in your wishlist",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: countData[2].toString(),
                                title: "in your orders",
                                width: context.screenWidth / 3.4),
                          ],
                        );
                      }
                    }
                  ),
                  
                  
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: lightGrey,
                      );
                    },
                    itemCount: profileButtonsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Get.to(() => const OrderScreen());
                              break;
                            case 1:
                              Get.to(() => const WishlistScreen());
                              break;
                            case 2:
                              Get.to(() => const MessagesScreen());
                              break;  
                            default:
                          }
                        },
                        leading: Image.asset(
                          profileButtonsIcon[index],
                          width: 22,
                        ),
                        title: profileButtonsList[index]
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                      );
                    },
                  )
                      .box
                      .white
                      .rounded
                      .margin(const EdgeInsets.all(12))
                      .padding(const EdgeInsets.symmetric(horizontal: 16))
                      .shadowSm
                      .make()
                      .box
                      .color(redColor)
                      .make()
                ],
              ),
            );
          }
        })
      )
    );
  }
}
