import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.icon,
    required TextEditingController controller,
    this.isObscure = false,
    this.isPassword = false,
    this.onPressed,
    this.validator,
    this.borderRadius = 10,
    this.isReadOnly = false,
    this.isFilled = false,
    this.fillColor,
  }) : _controller = controller;
  final String hintText;
  final IconData? icon;
  final TextEditingController _controller;
  final bool isObscure;
  final VoidCallback? onPressed;
  final bool isPassword;
  final FormFieldValidator? validator;
  final double borderRadius;
  final bool isReadOnly, isFilled;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: isReadOnly,
      obscureText: isObscure,
      validator: validator,
      decoration: InputDecoration(
        filled: isFilled,
        fillColor: fillColor,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
