import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/pages/login/providers/AuthViewModel.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/LoadingPageOverlay.dart';
import 'package:chat_with_bisky/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../route/app_route/AppRouter.gr.dart';

@RoutePage()
class OtpPage extends ConsumerStatefulWidget {
  String userId;

  OtpPage(this.userId);

  @override
  _OtpPageState createState() {
    return _OtpPageState();
  }
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(authNotifierProvider.notifier);
    final state = ref.watch(authNotifierProvider);
    return Scaffold(
        body: LoadingPageOverlay(
      loading: state.loading,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OTPTextField(
                otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                    focusBorderColor: Colors.amber),
                length: 6,
                width: MediaQuery.of(context).size.width,
                // fieldWidth: 40,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (String code) async {
                  controller.text = code;
                  notifier.phoneNumberChanged(widget.userId);
                  notifier.setSecret(code);
                  final success = await notifier.mobileNumberVerification();
                  if (success) {
                    routeToProfile();
                  } else {
                    if (mounted) {
                      ChatDialogs.informationOkDialog(context,
                          title: "txt_error",
                          description: "txt_invalid_code_supplied".tr,
                          type: AlertType.error);
                    }
                  }
                },
                onChanged: (String changed) {},
                obscureText: false,
              ),
            ],
          )
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  routeToProfile() async {
    print("navigate to another page username page");
    LocalStorageService.putString(LocalStorageService.userId, widget.userId);
    LocalStorageService.putString(
        LocalStorageService.stage, LocalStorageService.updateNamePage);
    final user = await ref.read(userRepositoryProvider).getUser(widget.userId);
    if (mounted) {
      AutoRouter.of(context)
          .push(UpdateNamePage(userId: widget.userId, user: user));
    }
  }
}
