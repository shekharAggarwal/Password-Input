import 'package:flutter/material.dart';

import '../style/obscure_style.dart';

enum PasswordEntryType { underline, boxTight, boxLoose }

abstract class PasswordDecoration {
  /// The style of painting text.
  final TextStyle? textStyle;

  /// The style of obscure text.
  final ObscureStyle? obscureStyle;

  /// The error text that will be displayed if any
  final String? errorText;

  /// The style of error text.
  final TextStyle? errorTextStyle;

  final String? hintText;

  final TextStyle? hintTextStyle;

  PasswordEntryType get passwordEntryType;

  const PasswordDecoration({
    this.textStyle,
    this.obscureStyle,
    this.errorText,
    this.errorTextStyle,
    this.hintText,
    this.hintTextStyle,
  });

  /// Creates a copy of this password decoration with the given fields replaced
  /// by the new values.
  PasswordDecoration copyWith({
    TextStyle textStyle,
    ObscureStyle obscureStyle,
    String errorText,
    TextStyle errorTextStyle,
    String hintText,
    TextStyle hintTextStyle,
  });
}
