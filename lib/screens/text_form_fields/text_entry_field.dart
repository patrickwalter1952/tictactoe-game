

import 'package:flutter/material.dart';
import 'package:tictactoe_game/services/string_extensions.dart';

class TextEntryField extends StatefulWidget {
  TextEntryField({super.key,
    required this.fieldLabel,
    required this.onChanged,
    required this.editingController,
    this.hintText = "",
    this.errorText = "field must be valued",
  });

  final String fieldLabel;
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController editingController;
  final String errorText;

  @override
  State<TextEntryField> createState() => _TextEntryFieldState();
}

class _TextEntryFieldState extends State<TextEntryField> {

  String? _errorText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.editingController,
      onChanged: (value) {
        setState(() {
          if (value.trim().isEmpty) {
            _errorText = widget.errorText;
          } else {
            _errorText = "";
            widget.onChanged(value);
          }
        });
      },

      validator: (value) {
        return _errorText;
      },

      style: const TextStyle(fontSize: 20),

      //this decoration will merge with the theme set
      decoration: InputDecoration(
        labelText: widget.fieldLabel,
        // An empty helperText makes it so the filed does not
        // grow in height when an error is displayed
        helperText: "",
        errorText: _errorText,
        hintText: widget.hintText,
      ),
    );
  }
}
