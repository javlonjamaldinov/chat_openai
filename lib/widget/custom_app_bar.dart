
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class CustomBarWidget extends StatelessWidget {

  String title;
  bool? showNavigationDrawer;
  Widget? actions;

  CustomBarWidget(this.title,{super.key, this.showNavigationDrawer = false,this.actions});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.10,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: 70.0,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
            ),
          )
        ],
      ),
    );
  }
}
