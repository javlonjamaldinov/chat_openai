import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class ChatDialogs {
  static waiting(
    BuildContext context,
    String message, {
    String? title,
    bool dismissible = false,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.yellow,
              ),
            ));
  }

  static pickOption(
    BuildContext context,
    String message, {
    String? title,
    List<SimpleDialogOption>? options,
    bool dismissible = false,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: title == null
                ? null
                : Text(title,
                    style: const TextStyle(
                      fontSize: 18.0,
                    )),
            children: options,
          );
        });
  }

  static hideProgress(BuildContext context) {
    Navigator.pop(context);
  }

  static informationOkDialog(BuildContext context,
      {required String title,
      required String description,
      required AlertType type}) {
    return Alert(
      context: context,
      type: type,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }



  static confirmDialog(BuildContext context,ValueChanged<bool> onConfirmation,
      {required String title,
        required String description,
        required AlertType type}) {
    return Alert(
      context: context,
      type: type,
      title: title,
      desc: description,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmation(false);
          },
          width: 120,
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),  DialogButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmation(true);
          },
          width: 120,
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

}
