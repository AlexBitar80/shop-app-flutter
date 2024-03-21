import 'package:flutter/material.dart';

class ShopTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const ShopTextField({
    super.key,
    required this.label,
    this.focusNode,
    this.onSaved,
    this.isPassword = false,
    this.validator,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<ShopTextField> createState() => _ShopTextFieldState();
}

class _ShopTextFieldState extends State<ShopTextField> {
  bool _isObscure = true;

  void changeObscured() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  changeObscured();
                },
              )
            : null,
      ),
      obscureText: widget.isPassword ? _isObscure : !_isObscure,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      onSaved: widget.onSaved,
      validator: widget.validator,
      controller: widget.controller,
    );
  }
}
