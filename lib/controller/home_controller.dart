import 'package:get/get.dart';
import 'package:nhom17/consts/consts.dart';

class HomeController extends GetxController {
  @override
  void onInit(){
    getUserName();
    super.onInit();
  }
  var currentNavIndex = 0.obs;
  var userName = '';
  var searchController = TextEditingController();
  getUserName() async{
    var n = await filestore.collection(usersCollection).where('id', isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isNotEmpty){
        return value.docs.single['name'];
      }
    });
    userName = n;
    print(userName);
  }
}
