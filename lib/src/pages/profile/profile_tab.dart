import "package:flutter/material.dart";
import "package:get/get.dart";

import "package:greengrocer/src/pages/auth/controllers/auth_controller.dart";
import "package:greengrocer/src/pages/widgets/custom_text_field.dart";
import "package:greengrocer/src/services/validators.dart";

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthController authController = Get.find();
  final TextEditingController currentPasswordEC = TextEditingController();
  final TextEditingController newPasswordEC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool?> updatePassword() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: this._formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Atualização de senha",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                    CustomTextField(
                      controller: this.currentPasswordEC,
                      isSecret: true,
                      icon: Icons.lock,
                      label: "Senha atual",
                      validator: passwordValidator
                    ),
                    CustomTextField(
                      controller: this.newPasswordEC,
                      isSecret: true,
                      icon: Icons.lock_outline,
                      label: "Nova senha",
                      validator: passwordValidator
                    ),
                    CustomTextField(
                      isSecret: true,
                      icon: Icons.lock_outline,
                      label: "Confirmar nova senha",
                      validator: (String? password) {
                        final String? result = passwordValidator(password);
                        if (result != null) return result;
                        if (password != this.newPasswordEC.text) return "As senhas não são equivalentes";
                        return null;
                      }
                    ),
                    SizedBox(
                      height: 45,
                      child: Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                          ),
                          onPressed: this.authController.isLoading.value
                            ? null
                            : () async {
                              if (this._formKey.currentState!.validate())
                                await this.authController.changePassword(
                                  currentPassword: this.currentPasswordEC.text,
                                  newPassword: this.newPasswordEC.text
                                );
                            },
                          child: this.authController.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text("Atualizar")
                        )
                      )
                    )
                  ]
                ),
              )
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close)
              )
            )
          ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil do usuário"),
        actions: <Widget>[
          IconButton(
            onPressed: () => this.authController.signOut(),
            icon: const Icon(Icons.logout)
          )
        ]
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: <Widget>[
          CustomTextField(
            readOnly: true,
            initialValue: this.authController.user.email,
            label: "E-mail",
            icon: Icons.email
          ),
          CustomTextField(
            readOnly: true,
            initialValue: this.authController.user.name,
            label: "Nome",
            icon: Icons.person
          ),
          CustomTextField(
            readOnly: true,
            initialValue: this.authController.user.phone,
            label: "Celular",
            icon: Icons.phone
          ),
          CustomTextField(
            readOnly: true,
            initialValue: this.authController.user.cpf,
            label: "CPF",
            isSecret: true,
            icon: Icons.copy
          ),
          SizedBox(
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ),
              onPressed: this.updatePassword,
              child: const Text("Atualizar Senha")
            )
          )
        ]
      )
    );
  }
}