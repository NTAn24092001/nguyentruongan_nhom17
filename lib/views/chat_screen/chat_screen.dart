import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/controller/chats_controller.dart';
import 'package:nhom17/services/filestore_services.dart';
import 'package:nhom17/views/categories_screen/categories_details.dart';
import 'package:nhom17/views/chat_screen/components/sender_bubble.dart';
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.friendName}".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              ()=>
              controller.isLoading.value ? Center(
                        child: loadingIndicator(),
                      ) 
              : Expanded(
                child: StreamBuilder(
                  stream: FilestoreServices.getChatMessages(controller.chatDocID.toString()),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(!snapshot.hasData){
                      return Center(
                        child: loadingIndicator(),
                      );
                    }
                    else if(snapshot.data!.docs.isEmpty){
                      return Center(
                        child: "Send a message...".text.color(darkFontGrey).make(),
                      );
                    }
                    else {
                      return ListView(
                        children: snapshot.data!.docs.mapIndexed((currentValue, index) {
                          var data = snapshot.data!.docs[index];

                          return Align(
                            alignment: data['uid'] == currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
                            child: senderBubble(data)
                          );
                        }).toList(),
                      );
                    }
                  }
                )
              ),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(child: TextFormField(
                  controller: controller.msgController,
                  decoration: const InputDecoration(
                    hintText: "Nhập tin nhắn...",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey
                      )
                    )
                  ),
                ),),
                IconButton(onPressed: (){
                  controller.sendMsg(controller.msgController.text);
                  controller.msgController.clear();
                }, icon: const Icon(Icons.send, color: redColor,))
              ],
            ).box.height(80).padding(const EdgeInsets.all(12)).margin(const EdgeInsets.only(bottom: 8)).make(),
          ],
        ),
      ),
    );
  }
}