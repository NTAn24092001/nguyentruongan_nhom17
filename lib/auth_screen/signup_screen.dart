//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:nhom17/controller/auth_controller.dart';
import 'package:nhom17/views/home_screen/home.dart';
import 'package:nhom17/widget_common/custom_textfield.dart';
import 'package:nhom17/widget_common/our_button.dart';

import '../consts/consts.dart';
import '../widget_common/applogo_widget.dart';
import '../widget_common/bg_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //var newValue;
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.07).heightBox,
              appLogoWidget(),
              10.heightBox,
              "Join the $appname".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              Obx(() =>
                Column(
                  children: [
                    customTextField(hint: nameHint, title: name, controller: nameController, isPass: false),
                    customTextField(hint: emailHint, title: email, controller: emailController, isPass: false),
                    customTextField(hint: passwordHint, title: password, controller: passwordController, isPass: true),
                    customTextField(hint: passwordHint, title: retypePassword, controller: passwordRetypeController, isPass: true),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {}, child: forgetPass.text.make()),
                    ),
                    5.heightBox,
                    //ourButton().box.width(context.screenWidth - 50).make(),
              
                    Row(
                      children: [
                        Checkbox(
                            activeColor: redColor,
                            checkColor: whiteColor,
                            value: isCheck,
                            onChanged: (newValue) {
                              setState(() {
                                isCheck = newValue;
                              });
                            }),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                              text: const TextSpan(children: [
                            TextSpan(
                                text: "Tôi đồng ý với ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                )),
                            TextSpan(
                                text: termAndCond,
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                )),
                            TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                )),
                            TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                )),
                          ])),
                        )
                      ],
                    ),
                    5.heightBox,
                    controller.isLoading.value? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ) : ourButton(
                            color: isCheck == true ? redColor : lightGrey,
                            title: signUp,
                            textColor: whiteColor,
                            onPress: () async {
                              if (isCheck != false){
                                controller.isLoading(true);
                                try {
                                  await controller.signUpMethod(
                                    context: context, email: emailController.text, password: passwordController.text
                                  ).then((value) {
                                    return controller.storeUserData(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text
                                    );
                                  }).then((value) { 
                                    VxToast.show(context, msg: loggedIn);
                                    Get.offAll(() => const Home());
                                  });
                                } catch (e) {
                                  auth.signOut();
                                  VxToast.show(context, msg: e.toString());
                                  controller.isLoading(false);
                                }
                              }
                            })
                        .box
                        .width(context.screenWidth - 50)
                        .make(),
                    10.heightBox,
                    RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: alreadyHaveAccount,
                            style: TextStyle(
                              fontFamily: bold,
                              color: fontGrey,
                            )),
                        TextSpan(
                            text: login,
                            style: TextStyle(
                              fontFamily: bold,
                              color: redColor,
                            ))
                      ]),
                    ).onTap(() {
                      Get.back();
                    })
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
