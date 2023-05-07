import "package:animated_text_kit/animated_text_kit.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/pages_routes/app_pages.dart";
import "package:greengrocer/src/config/custom_colors.dart";
import "package:greengrocer/src/pages/auth/controllers/auth_controller.dart";
import "package:greengrocer/src/pages/auth/views/widgets/forget_password_dialog.dart";
import "package:greengrocer/src/pages/widgets/app_name_widget.dart";
import "package:greengrocer/src/pages/widgets/custom_text_field.dart";
import "package:greengrocer/src/services/utils_services.dart";
import "package:greengrocer/src/services/validators.dart";

class SignInScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailEC = TextEditingController();
  final TextEditingController passwordEC = TextEditingController();
  final UtilsServices utilsServices = UtilsServices();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Form(
            key: this._formKey,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const AppNameWidget(
                        greenColorTile: Colors.white,
                        textSize: 40
                      ),
                      SizedBox(
                        height: 30,
                        child: DefaultTextStyle(
                          style: const TextStyle(fontSize: 25),
                          child: AnimatedTextKit(
                            pause: Duration.zero,
                            repeatForever: true,
                            animatedTexts: <FadeAnimatedText>[
                              FadeAnimatedText("Frutas"),
                              FadeAnimatedText("Verduras"),
                              FadeAnimatedText("Legumes"),
                              FadeAnimatedText("Carnes"),
                              FadeAnimatedText("Cereais"),
                              FadeAnimatedText("Laticíneos")
                            ]
                          )
                        )
                      )
                    ]
                  )
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(45))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CustomTextField(
                        controller: this.emailEC,
                        label: "E-mail",
                        icon: Icons.email,
                        textInputType: TextInputType.emailAddress,
                        validator: emailValidator
                      ),
                      CustomTextField(
                        controller: this.passwordEC,
                        label: "Senha",
                        icon: Icons.lock,
                        isSecret: true,
                        validator: passwordValidator
                      ),
                      SizedBox(
                        height: 50,
                        child: GetX<AuthController>(
                          builder: (AuthController authController) =>
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                              onPressed: authController.isLoading.value
                                ? null
                                : () {
                                  FocusScope.of(context).unfocus();
                                  if (this._formKey.currentState!.validate()) {
                                    String email = this.emailEC.text;
                                    String password = this.passwordEC.text;
                                    authController.signin(email: email, password: password);
                                  }
                                },
                              child: authController.isLoading.value
                                ? const CircularProgressIndicator()
                                : const Text("Entrar", style: TextStyle(fontSize: 18))
                            )
                        )
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            final bool? result = await showDialog(
                              context: context,
                              builder: (_) => ForgotPasswordDialog(email: this.emailEC.text)
                            );
                            if (result ?? false)
                              this.utilsServices.showToast(message: "Um link de recuperação de senha foi enviado ao seu e-mail");
                          },
                          child: Text("Esqueceu a senha?", style: TextStyle(color: CustomColors.customContrastColor)),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Divider(thickness: 2, color: Colors.grey.withAlpha(90))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text("Ou")
                            ),
                            Expanded(child: Divider(thickness: 2, color: Colors.grey.withAlpha(90)))
                          ]
                        )
                      ),
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            side: const BorderSide(width: 2, color: Colors.green)
                          ),
                          onPressed: () => Get.toNamed(PageRoutes.signupRoute),
                          child: const Text("Criar conta", style: TextStyle(fontSize: 18))
                        )
                      )
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}