import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../decoration/box_loose_decoration.dart';
import '../decoration/box_tight_decoration.dart';
import '../decoration/password_decoration.dart';
import '../decoration/underline_decoration.dart';
import '../paint/password_paint.dart';

class PasswordInputTextField extends StatefulWidget {
  /// The max length of password.
  final int passwordLength;

  /// The callback will execute when user click done.
  final ValueChanged<String>? onSubmit;

  /// Decorate the password.
  final PasswordDecoration decoration;

  /// Just like [TextField]'s inputFormatter.
  final List<TextInputFormatter> inputFormatters;

  /// Just like [TextField]'s keyboardType.
  final TextInputType keyboardType;

  /// Controls the password being edited.
  final TextEditingController? controller;

  /// Same as [TextField]'s autoFocus.
  final bool autoFocus;

  /// Same as [TextField]'s focusNode.
  final FocusNode? focusNode;

  /// Same as [TextField]'s textInputAction.
  final TextInputAction textInputAction;

  /// Same as [TextField]'s enabled.
  final bool enabled;

  /// Same as [TextField]'s onChanged.
  final ValueChanged<String>? onChanged;

  PasswordInputTextField({
    Key? key,
    required this.passwordLength,
    this.onSubmit,
    this.decoration: const BoxLooseDecoration(),
    List<TextInputFormatter>? inputFormatter,
    this.keyboardType: TextInputType.text,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.onChanged,
  })  :

        /// passwordLength must larger than 0.
        /// If passwordEditingController isn't null, guarantee the [passwordLength] equals to the passwordEditingController's _passwordMaxLength
        assert(passwordLength > 0),

        /// Hint length must equal to the [passwordLength].
        assert(decoration.hintText == null ||
            decoration.hintText!.length == passwordLength),
        assert(decoration is BoxTightDecoration ||
            (decoration is UnderlineDecoration &&
                passwordLength - 1 ==
                    (decoration.gapSpaces?.length ?? (passwordLength - 1))) ||
            (decoration is BoxLooseDecoration &&
                passwordLength - 1 ==
                    (decoration.gapSpaces?.length ?? (passwordLength - 1)))),
        inputFormatters = inputFormatter == null
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.singleLineFormatter,
                LengthLimitingTextInputFormatter(passwordLength)
              ]
            : inputFormatter
          ..add(LengthLimitingTextInputFormatter(passwordLength)),
        super(key: key);

  @override
  State createState() {
    return _PasswordInputTextFieldState();
  }
}

class _PasswordInputTextFieldState extends State<PasswordInputTextField> {
  /// The display text to the user.
  late String _text;

  TextEditingController _controller = TextEditingController();

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  void _passwordChanged() {
    setState(() {
      _updateText();

      /// This below code will cause dead loop in iOS,
      /// you should assign selection when you set text.
//      _effectiveController.selection = TextSelection.collapsed(
//          offset: _effectiveController.text.runes.length);
    });
  }

  void _updateText() {
    if (_effectiveController.text.runes.length > widget.passwordLength) {
      _text = String.fromCharCodes(
          _effectiveController.text.runes.take(widget.passwordLength));
    } else {
      _text = _effectiveController.text;
    }
  }

  @override
  void initState() {
    super.initState();
    _effectiveController.addListener(_passwordChanged);

    //Ensure the initial value will be displayed when the field didn't get the focus.
    _updateText();
  }

  @override
  void dispose() {
    // Ensure no listener will execute after dispose.
    _effectiveController.removeListener(_passwordChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(PasswordInputTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller?.removeListener(_passwordChanged);
      _controller =
          TextEditingController.fromValue(oldWidget.controller?.value);
      _controller.addListener(_passwordChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller.removeListener(_passwordChanged);
      widget.controller?.addListener(_passwordChanged);
      // Invalidate the text when controller hold different old text.
      if (_text != widget.controller?.text) {
        _passwordChanged();
      }
    } else if (widget.controller != oldWidget.controller) {
      // The old controller and current controller is not null and not the same.
      oldWidget.controller?.removeListener(_passwordChanged);
      widget.controller?.addListener(_passwordChanged);
    }

    /// If the newLength is shorter than now and the current text length longer
    /// than [passwordLength], So we should cut the superfluous subString.
    if (oldWidget.passwordLength > widget.passwordLength &&
        _text.runes.length > widget.passwordLength) {
      setState(() {
        _text = _text.substring(0, widget.passwordLength);
        _effectiveController.text = _text;
        _effectiveController.selection =
            TextSelection.collapsed(offset: _text.runes.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      /// The foreground paint to display password.
      foregroundPainter: PasswordPaint(
          text: _text,
          passwordLength: widget.passwordLength,
          decoration: widget.decoration,
          themeData: Theme.of(context)),
      child: TextField(
        /// Actual textEditingController.
        controller: _effectiveController,

        /// Fake the text style.
        style: TextStyle(
          /// Hide the editing text.
          color: Colors.transparent,
          fontSize: 1,
        ),

        /// Hide the Cursor.
        cursorColor: Colors.transparent,

        /// Hide the cursor.
        cursorWidth: 0.0,

        /// No need to correct the user input.
        autocorrect: false,

        /// Center the input to make more natural.
        textAlign: TextAlign.center,

        /// Disable the actual textField selection.
        enableInteractiveSelection: false,

        /// The maxLength of the password input, the default value is 6.
        maxLength: widget.passwordLength,

        /// If use system keyboard and user click done, it will execute callback
        /// Note!!! Custom keyboard in Android will not execute, see the related issue [https://github.com/flutter/flutter/issues/19027]
        onSubmitted: widget.onSubmit,

        /// Default text input type is number.
        keyboardType: widget.keyboardType,

        /// only accept digits.
        inputFormatters: widget.inputFormatters,

        /// Defines the keyboard focus for this widget.
        focusNode: widget.focusNode,

        /// {@macro flutter.widgets.editableText.autofocus}
        autofocus: widget.autoFocus,

        /// The type of action button to use for the keyboard.
        ///
        /// Defaults to [TextInputAction.done]
        textInputAction: widget.textInputAction,

        /// {@macro flutter.widgets.editableText.obscureText}
        /// Default value of the obscureText is false. Make
        obscureText: true,

        onChanged: widget.onChanged,

        /// Clear default text decoration.
        decoration: InputDecoration(
          /// Hide the counterText
          counterText: '',

          /// Hide the outline border.
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),

          /// Bind the error text from password decoration to this input decoration.
          errorText: widget.decoration.errorText,

          /// Bind the style of error text from password decoration to
          /// this input decoration.
          errorStyle: widget.decoration.errorTextStyle,
        ),
        enabled: widget.enabled,
      ),
    );
  }
}
