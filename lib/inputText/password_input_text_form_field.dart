import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../decoration/box_loose_decoration.dart';
import '../decoration/password_decoration.dart';
import 'password_input_text_field.dart';

class PasswordInputTextFormField extends FormField<String> {
  /// Controls the password being edited.
  final TextEditingController? controller;

  /// The max length of password.
  final int passwordLength;

  final String? initialValue;

  PasswordInputTextFormField({
    Key? key,
    this.controller,
    this.initialValue,
    required this.passwordLength,
    ValueChanged<String>? onSubmit,
    PasswordDecoration decoration = const BoxLooseDecoration(),
    List<TextInputFormatter>? inputFormatter,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? focusNode,
    bool autoFocus = false,
    TextInputAction textInputAction = TextInputAction.done,
    bool enabled = true,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    AutovalidateMode autovalidate = AutovalidateMode.disabled,
    ValueChanged<String>? onChanged,
  })  : assert(initialValue == null || controller == null),
        assert(passwordLength > 0),
        super(
            key: key,
            initialValue:
                controller != null ? controller.text : (initialValue ?? ''),
            onSaved: onSaved,
            validator: (value) {
              var result = validator!(value);
              if (result == null) {
                if (value!.isEmpty) {
                  return 'Input field is empty.';
                }
                if (value.length < passwordLength) {
                  if (passwordLength - value.length > 1) {
                    return 'Missing ${passwordLength - value.length} digits of input.';
                  } else {
                    return 'Missing last digit of input.';
                  }
                }
              }
              return result;
            },
            autovalidateMode: autovalidate,
            enabled: enabled,
            builder: (FormFieldState<String> field) {
              final _PasswordInputTextFormFieldState state =
                  field as _PasswordInputTextFormFieldState;
              return PasswordInputTextField(
                passwordLength: passwordLength,
                onSubmit: onSubmit,
                decoration:
                    decoration.copyWith(errorText: field.errorText ?? ''),
                inputFormatter: inputFormatter,
                keyboardType: keyboardType,
                controller: state._effectiveController,
                focusNode: focusNode,
                autoFocus: autoFocus,
                textInputAction: textInputAction,
                enabled: enabled,
                onChanged: onChanged,
              );
            });

  @override
  _PasswordInputTextFormFieldState createState() =>
      _PasswordInputTextFormFieldState();
}

class _PasswordInputTextFormFieldState extends FormFieldState<String> {
  late TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  PasswordInputTextFormField get widget =>
      (super.widget as PasswordInputTextFormField);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(PasswordInputTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _controller =
          TextEditingController.fromValue(oldWidget.controller?.value);
      _controller.addListener(_handleControllerChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);
      // Invalidate the text when controller hold different old text.
      if (value != widget.controller?.text) {
        _handleControllerChanged();
      }
    } else if (widget.controller != oldWidget.controller) {
      // The old controller and current controller is not null and not the same.
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);
    }

    /// If the newLength is shorter than now and the current text length longer
    /// than [passwordLength], So we should cut the superfluous subString.
    if (oldWidget.passwordLength > widget.passwordLength &&
        value!.runes.length > widget.passwordLength) {
      setState(() {
        setValue(value!.substring(0, widget.passwordLength));
        _effectiveController.text = value!;
        _effectiveController.selection = TextSelection.collapsed(
          offset: value!.runes.length,
        );
      });
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue!;
    });
  }

  @override
  void didChange(String? value) {
    if (value!.runes.length > widget.passwordLength) {
      super.didChange(String.fromCharCodes(
        value.runes.take(widget.passwordLength),
      ));
    } else {
      super.didChange(value);
    }
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }
}
