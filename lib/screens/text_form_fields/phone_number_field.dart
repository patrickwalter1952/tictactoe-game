
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictactoe_game/services/string_extensions.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({super.key,
    required this.fieldLabel,
    this.hintText = "",
    this.isEnabled = true,
    this.maxLength = 16,
    required this.onChanged,
    required this.editingController,
    this.errorText = "Enter a valid phone number",
  });

  final String fieldLabel;
  final String hintText;
  final bool isEnabled;
  final dynamic maxLength;
  final ValueChanged<String> onChanged;
  final TextEditingController editingController;
  final String errorText;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
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
          if (!value.isValidPhoneNumber()) {
            _errorText = widget.errorText;
          } else {
            _errorText = null;
            widget.onChanged(value);
          }
        });
      },

      validator: (value) {
        return _errorText;
      },

      style: const TextStyle(fontSize: 20),

      maxLength: widget.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,

      //this decoration will merge with the theme set
      decoration: InputDecoration(
        enabled: widget.isEnabled,
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
