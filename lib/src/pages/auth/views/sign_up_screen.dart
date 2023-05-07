import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mask_text_input_formatter/mask_text_input_formatter.dart";

import "package:greengrocer/src/config/custom_colors.dart";
import "package:greengrocer/src/pages/auth/controllers/auth_controller.dart";
import "package:greengrocer/src/pages/widgets/custom_text_field.dart";
import "package:greengrocer/src/services/validators.dart";

class SignUpScreen extends StatelessWidget {
  SignUpScreen({ Key? key }) : super(key: key);

  final MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
    mask: "###.###.###-##",
    filter: <String, RegExp>{"#": RegExp(r"[0-9]")}
  );
  final MaskTextInputFormatter phonefFormatter = MaskTextInputFormatter(
    mask: "## # ####-####",
    filter: <String, RegExp>{"#": RegExp(r"[0-9]")}
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Cadastro",
                        style: TextStyle(color: Colors.white, fontSize: 35)
                      )
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(45))
                    ),
                    child: Form(
                      key: this._formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CustomTextField(
                            label: "Email",
                            icon: Icons.email,
                            onSaved: (String? value) => this.authController.user.email = value,
                            validator: emailValidator,
                            textInputType: TextInputType.emailAddress
                          ),
                          CustomTextField(
                            label: "Senha",
                            icon: Icons.lock,
                            onSaved: (String? value) => this.authController.user.password = value,
                            validator: passwordValidator,
                            isSecret: true
                          ),
                          CustomTextField(
                            label: "Nome",
                            validator: nameValidator,
                            onSaved: (String? value) => this.authController.user.name = value,
                            icon: Icons.person
                          ),
                          CustomTextField(
                            label: "Celular",
                            icon: Icons.phone,
                            validator: phoneValidator,
                            onSaved: (String? value) => this.authController.user.phone = value,
                            textInputType: TextInputType.phone,
                            inputFormatters: <MaskTextInputFormatter>[this.phonefFormatter],
                          ),
                          CustomTextField(
                            label: "CPF",
                            icon: Icons.file_copy,
                            validator: cpfValidator,
                            textInputType: TextInputType.number,
                            onSaved: (String? value) => this.authController.user.cpf = value,
                            inputFormatters: <MaskTextInputFormatter>[this.cpfFormatter],
                          ),
                          SizedBox(
                            height: 50,
                            child: Obx(() => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
                                ),
                                onPressed: this.authController.isLoading.value
                                  ? null
                                  : () async {
                                    FocusScope.of(context).unfocus();
                                    final bool isValid = this._formKey.currentState!.validate();
                                    if (isValid) {
                                      this._formKey.currentState!.save();
                                      await this.authController.signUp();
                                    }
                                  },
                                child: this.authController.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text("Cadastrar usuário", style: TextStyle(fontSize: 18))
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                ]
              ),
              Positioned(
                left: 10,
                top: 10,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white)
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}