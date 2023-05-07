import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/pages/auth/controllers/auth_controller.dart";
import "package:greengrocer/src/pages/widgets/custom_text_field.dart";
import "package:greengrocer/src/services/validators.dart";

class ForgotPasswordDialog extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  // ignore: always_specify_types
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final AuthController authController = Get.find();

  ForgotPasswordDialog({
    required String email,
    Key? key
  }) : super(key: key) {
    this.emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Recuperação de senha",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  )
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "Digite seu email para recuperar sua senha",
                    textAlign: TextAlign.center,
                    style: TextStyle()
                  )
                ),
                CustomTextField(
                  formFieldKey: this._formFieldKey,
                  controller: this.emailController,
                  icon: Icons.email,
                  label: "Email",
                  validator: emailValidator,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green
                    )
                  ),
                  onPressed: () {
                    final bool isValid = this._formFieldKey.currentState!.validate();
                    if (isValid) {
                      this.authController.resetPassword(this.emailController.text);
                      Get.back(result: isValid);
                    }
                  },
                  child: const Text(
                    "Recuperar",
                    style: TextStyle(fontSize: 13)
                  )
                )
              ]
            )
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close)
            )
          )
        ]
      )
    );
  }
}