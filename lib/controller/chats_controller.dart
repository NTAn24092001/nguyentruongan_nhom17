import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/controller/home_controller.dart';

class ChatController extends GetxController {
  @override
  void onInit(){
    getChatId();
    super.onInit();
  }
  var chats = filestore.collection(chatsCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];
  var senderName = Get.find<HomeController>().userName;
  var currentId = currentUser!.uid;
  var msgController = TextEditingController();
  dynamic chatDocID;
  var isLoading = false.obs;
  getChatId() async {
    isLoading(true);
    await chats.where('users', isEqualTo: {
      friendId: null,
      currentId: null
    }).limit(1).get().then((QuerySnapshot snapshot){
      if(snapshot.docs.isNotEmpty){
        chatDocID = snapshot.docs.single.id;
      }
      else{
        chats.add({
          'created_on': null,
          'last_msg': '',
          'users': {friendId: null, currentId: null},
          'toId': '',
          'fromId': '',
          'friend_name': friendName,
          'sender_name': senderName
        }).then((value){
          {
            chatDocID = value.id;
          }
        });
      }
    });
  isLoading(false);
  }
  sendMsg(String msg) async{
    if(msg.trim().isNotEmpty){
      chats.doc(chatDocID).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,
      });
      chats.doc(chatDocID).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId
      });
    }
  }
}