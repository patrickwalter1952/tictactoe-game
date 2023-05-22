

import 'package:flutter/material.dart';

class MyInputTheme {

  TextStyle _buildTextStyle(Color color, {double size = 16}) {
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(
        color: color,
        width: 2.0,
      ),
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
    contentPadding: const EdgeInsets.all(16.0),
    //isDense seems to do nothing if you pass padding in
    // isDense: true,

    // 'always' put the label at the top
    floatingLabelBehavior: FloatingLabelBehavior.always,

    //this can be useful for putting TextFields in a row.
    //However, it might be more desirable to wrap with a Flexible
    //to make them grow to the available width.
    constraints: const BoxConstraints(maxHeight: 150),

    /// Borders
    // Enable and not showing error
    enabledBorder: _buildBorder(Colors.grey[600]!),
    // Has error but not focus
    errorBorder: _buildBorder(Colors.red),

    // Has error and focus
    focusedErrorBorder: _buildBorder(Colors.red),

    //Default value if borders are null
    // border: _buildBorder(Colors.yellow),

    //Enabled and focused
    focusedBorder: _buildBorder(Colors.blue),

    // Disabled
    disabledBorder: _buildBorder(Colors.grey[400]!),

    /// TextStyle
    suffixStyle: _buildTextStyle(Colors.black),
    counterStyle: _buildTextStyle(Colors.grey, size: 12.0),
    floatingLabelStyle: _buildTextStyle(Colors.black),

    //Make error and helper the same size, so that the field
    //does not grow in height when there is an error text
    errorStyle: _buildTextStyle(Colors.red, size: 12.0),
    helperStyle: _buildTextStyle(Colors.black, size: 12.0),
    hintStyle: _buildTextStyle(Colors.grey),
    labelStyle: _buildTextStyle(Colors.black),
    prefixStyle: _buildTextStyle(Colors.black),

  );

}
