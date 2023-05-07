import "package:flutter/material.dart";
import "package:flutter/services.dart";

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  // ignore: always_specify_types
  final GlobalKey<FormFieldState>? formFieldKey;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.icon,
    this.inputFormatters,
    this.isSecret = false,
    this.initialValue,
    this.readOnly = false,
    this.validator,
    this.controller,
    this.textInputType,
    this.onSaved,
    this.formFieldKey
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    this.isObscure = this.widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        key: this.widget.formFieldKey,
        onSaved: this.widget.onSaved,
        controller: this.widget.controller,
        validator: this.widget.validator,
        readOnly: this.widget.readOnly,
        initialValue: this.widget.initialValue,
        inputFormatters: this.widget.inputFormatters,
        obscureText: this.isObscure,
        keyboardType: this.widget.textInputType,
        decoration: InputDecoration(
          labelText: this.widget.label,
          prefixIcon: Icon(this.widget.icon),
          suffixIcon: this.widget.isSecret
            ? IconButton(
                onPressed: () => setState(() => this.isObscure = !this.isObscure),
                icon: this.isObscure
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off)
              )
            : null,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18))
        )
      )
    );
  }
}