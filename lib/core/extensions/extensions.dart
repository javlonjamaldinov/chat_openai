

import 'dart:io';

import 'package:chat_with_bisky/localization/app_localization.dart';
import 'package:chat_with_bisky/pages/dashboard/chat/VideoPlayerScreen.dart';
import 'package:chat_with_bisky/widget/TrimmerView.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

extension OnDateTime on DateTime{

  String get formatDateTime => DateFormat('dd MM yyyy hh:mm a').format(toLocal());

  String getFormattedTime(){
    DateFormat formatter = DateFormat('HH:mm');
    String formattedText = getFormattedText();

    if(formattedText == 'Today'){

      return formatter.format(toLocal());
    }else  if(formattedText == 'Yesterday'){

      return '${'txt_yesterday_at'.tr} ${formatter.format(toLocal())}';
    }else{
      return '$formattedText ${formatter.format(toLocal())}';
    }
  }
  String getFormattedLastSeenTime(){
    DateFormat formatter = DateFormat('HH:mm');
    String formattedText = getFormattedText();

    if(formattedText == 'Today'){

      return '${'txt_last_online_at'.tr} ${formatter.format(toLocal())}';
    }else  if(formattedText == 'Yesterday'){

      return '${'txt_last_online_yesterday_at'.tr} ${formatter.format(toLocal())}';
    }else{
      return '${'txt_last_online_on'.tr} $formattedText ${formatter.format(toLocal())}';
    }
  }



  String getFormattedText() {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    final now = DateTime.now();
    if (formatter.format(now) == formatter.format(toLocal())) {
      return 'Today';
    } else if (formatter
        .format(DateTime(now.year, now.month, now.day - 1)) ==
        formatter.format(toLocal())) {
      return 'Yesterday';
    } else {
      return '${DateFormat('d').format(toLocal())} ${DateFormat('MMMM').format(toLocal())} ${DateFormat('y').format(toLocal())}';
    }
  }
}


extension OnBuildContext on BuildContext{


  MediaQueryData get media => MediaQuery.of(this);

  Future<File?> pickAndCropImage([double? aspectRatioX, ImageSource? source]) async {


    try{
      final file = await ImagePicker().pickImage(source: source ?? ImageSource.gallery);

      if(file != null){

        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatio: CropAspectRatio(ratioX: (aspectRatioX ?? 1), ratioY: 1),
          uiSettings: [],
        );

        return croppedFile != null ? File(croppedFile.path) :null;
      }
    }catch(e){
      print(e);
    }
    return null;
  }


  Future<File?> pickVideo(BuildContext context,final ValueChanged<File> onChanged) async {


    try{
      final file = await ImagePicker().pickVideo(source:  ImageSource.gallery);

      if(mounted && file != null){


        Navigator.push(context, MaterialPageRoute(builder: (context) => TrimmerView(File(file.path), onChanged),));

        return null;
      }
    }catch(e){
      print(e);
    }
    return null;
  }


  void openImage(String path){

    Navigator.of(this).push(MaterialPageRoute(builder: (context) => Scaffold(
      appBar: AppBar(title: Text("txt_image".tr),),
      body: Center(
        child: SafeArea(
          child: Image.file(File(path)),
        ),
      ),
    ),));
  }

  void playVideo(String path){

    push(VideoPlayerScreen(path));

  }

  push(Widget widget){

    Navigator.of(this).push(MaterialPageRoute(builder: (context) =>widget,));
  }

}

extension GetByKeyIndex on Map {
  elementAt(int index) => this.values.elementAt(index);
}
extension LocalizationExtension on String {
  String get tr => AppLocalization.of().getString(this);
}
