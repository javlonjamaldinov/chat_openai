


import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/values/values.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

@RoutePage()
class IntroPage extends StatefulWidget{

  @override
  _IntroPageState  createState() {


    return _IntroPageState();
  }

}


class  _IntroPageState extends State<IntroPage>{


  @override
  Widget build(BuildContext context) {

    return introWidget();
  }


  Widget introWidget(){

    return IntroductionScreen(
      showSkipButton: false,
      next: const Icon(Icons.arrow_forward_ios),
      pages: [
        PageViewModel(
          title: "txt_intro1_title".tr,
          body: "txt_intro1_description".tr,
          image: _buildImage(ImagePath.intro1)
        ),
        PageViewModel(
            title: "txt_intro2_title".tr,
            body: "txt_intro2_description".tr,
            image: _buildImage(ImagePath.intro2)
        ),
        PageViewModel(
            title: "txt_intro3_title".tr,
            body: "txt_intro3_description".tr,
            image: _buildImage(ImagePath.intro3)
        )

      ],
      onDone:onDonePress,
      showDoneButton: true,
      done:  Text('txt_done'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),


    );
  }


  Widget _buildImage(String imagePath){

    return Image.asset(imagePath,width: 150,);
  }

  void onDonePress() {

    print("Ondone.....");

    AutoRouter.of(context).push(const LoginPage());
  }

}
