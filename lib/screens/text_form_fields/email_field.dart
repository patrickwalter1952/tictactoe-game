

import 'package:flutter/material.dart';
import 'package:tictactoe_game/services/string_extensions.dart';

class EmailField extends StatefulWidget {
  const EmailField({super.key,
    required this.fieldLabel,
    required this.onChanged,
    required this.editingController,
    this.errorText = "Enter a valid email",
  });

  final String fieldLabel;
  final TextEditingController editingController;
  final ValueChanged<String> onChanged;
  final String errorText;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {

  String? _errorText;

  @override
  void initState() {
    super.initState();
    _errorText = widget.errorText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      keyboardType: TextInputType.emailAddress,
      controller: widget.editingController,

      validator: (value) {
        return _errorText;
      },

      onChanged: (value) {
        setState(() {
          if (!value.isValidEmail()) {
            _errorText = widget.errorText;
          } else {
            _errorText = null;
            widget.onChanged(value);
          }
        });
      },

      //this decoration will merge with the theme set
      decoration: InputDecoration(
        labelText:  widget.fieldLabel,
        helperText: "",
        hintText: "email@gmail.com",
        errorText: _errorText,
      ),

    );
  }

}
