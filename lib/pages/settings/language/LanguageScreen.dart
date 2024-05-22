import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/localization/app_localization.dart';
import 'package:chat_with_bisky/main.dart';
import 'package:chat_with_bisky/model/AppLanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageScreen extends ConsumerStatefulWidget{

  const LanguageScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {

    return _LanguageScreenState();
  }

}

class _LanguageScreenState extends ConsumerState<LanguageScreen>{
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('change_language'.tr),),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(


            child: DropdownButton<AppLanguage>(
              iconSize: 30,
              hint: Text('change_language'.tr),
              onChanged: (AppLanguage? language) {

                if(language!= null){
                  _changeLanguage(language);
                }

              },
              items: languageList()
                  .map<DropdownMenuItem<AppLanguage>>(
                    (e) => DropdownMenuItem<AppLanguage>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        e.flag,
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(e.name)
                    ],
                  ),
                ),
              )
                  .toList(),
            )),
      ),
    );
  }

  void _changeLanguage(AppLanguage language) async {
    final locale = await setLocale(language.code);
    MyApp.setLocale(locale);
    setState(() {

    });
  }

}