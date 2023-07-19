import 'package:flutter/services.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/widget_common/our_button.dart';
Widget exitDialog(context){
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
        Divider(),
        10.heightBox,
        "Are you sure you want to exit?".text.size(16).make(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(color: redColor, onPress: (){
              SystemNavigator.pop();
            }, textColor: whiteColor, title: "Yes"),
            ourButton(color: redColor, onPress: (){
              Navigator.pop(context);
            }, textColor: whiteColor, title: "No")
          ],
        )
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}