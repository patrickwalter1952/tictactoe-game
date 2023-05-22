import 'package:tictactoe_game/services/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberField extends StatefulWidget {
  const NumberField({super.key,
    required this.fieldLabel,
    required this.fieldType,
    this.initialValue = 0,
    this.hintText = "",
    this.isEnabled = true,
    this.maxLength = 10,
    required this.onChanged,
    required this.editingController,
    this.errorText = "Enter a valid positive number",
  });

  final String fieldLabel;
  final String fieldType;
  final int initialValue;
  final String hintText;
  final bool isEnabled;
  final dynamic maxLength;
  final ValueChanged<String> onChanged;
  final TextEditingController editingController;
  final String errorText;

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // initialValue:  widget.initialValue.toString(),
      controller: widget.editingController,
      onChanged: (value) {
        setState(() {
          if (!value.isValidIntGreaterZero()) {
            _errorText = widget.errorText;
          } else {
            _errorText = null;
            widget.onChanged(value);
          }
        });
      },

      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),

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

        //suffix widget only appears when field is populated
        suffix: Text(widget.fieldType),
      ),
    );
  }
}
