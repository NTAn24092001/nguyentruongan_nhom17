// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:nhom17/consts/consts.dart';
import 'package:nhom17/controller/profile_controller.dart';
import 'package:nhom17/widget_common/bg_widget.dart';
import 'package:nhom17/widget_common/custom_textfield.dart';
import 'package:nhom17/widget_common/our_button.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    controller.nameController.text = data['name'];

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              data['imageUrl'] == '' && controller.profileImgPath.isEmpty ? Image.asset(imgProfile2, width: 100, fit: BoxFit.cover)
                    .box
                    .roundedFull
                    .clip(Clip.antiAlias)
                    .make() 
                    : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                    ? Image.network(
                      data['imageUrl'],
                      width: 100,
                      fit: BoxFit.cover,
                      ).box
                    .roundedFull
                    .clip(Clip.antiAlias)
                    .make()
                    : Image.file(
                      File(controller.profileImgPath.value),
                      width: 100,
                      fit: BoxFit.cover,
                    ).box
                    .roundedFull
                    .clip(Clip.antiAlias)
                    .make(),
                    10.heightBox,
                    ourButton(color: redColor, onPress: (){
                      controller.changeImage(context);
                    }, textColor: whiteColor, title: 'Change'),
                    const Divider(),
                    20.heightBox,
                    customTextField(
                      controller: controller.nameController,
                      hint: nameHint,
                      title: name, isPass: false
                    ),
                    10.heightBox,
                    customTextField(
                      controller: controller.oldPassController,
                      hint: passwordHint,
                      title: oldPass, isPass: true
                    ),
                    10.heightBox,
                    customTextField(
                      controller: controller.newPassController,
                      hint: passwordHint,
                      title: newPass, isPass: true
                    ),
                    20.heightBox,
                    controller.isLoading.value ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ) : SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButton(color: redColor, onPress: () async{
                        controller.isLoading(true);
                        if (controller.profileImgPath.value.isNotEmpty){
                          await controller.uploadProfileImage();
                        }
                        else{
                          controller.profileImageLink = data['imageUrl'];
                        }
                        if(data['password'] == controller.oldPassController.text){
                          await controller.changeAuthPassword(
                            email: data['email'],
                            password: controller.oldPassController.text,
                            newPassword: controller.newPassController.text
                          );
                          await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newPassController.text
                          );
                          VxToast.show(context, msg: 'Updated');
                        }
                        else{
                          VxToast.show(context, msg: 'Wrong old password');
                          controller.isLoading(false);
                        }
                      }, textColor: whiteColor, title: 'Save')
                    ),
            ],
          ).box.white.shadowSm.padding(const EdgeInsets.all(16)).margin(const EdgeInsets.only(top: 50, left: 12, right: 12)).rounded.make(),
        ),
      )
    );
  }
}