import 'package:flutter/material.dart';

import '../decoration/box_loose_decoration.dart';
import '../decoration/box_tight_decoration.dart';
import '../decoration/password_decoration.dart';
import '../decoration/underline_decoration.dart';

class PasswordPaint extends CustomPainter {
  final String text;
  final int passwordLength;
  final PasswordEntryType type;
  final PasswordDecoration decoration;
  final ThemeData themeData;

  PasswordPaint({
    required this.text,
    required this.passwordLength,
    required PasswordDecoration decoration,
    this.type: PasswordEntryType.boxTight,
    required this.themeData,
  }) : this.decoration = decoration.copyWith(
          textStyle: decoration.textStyle ?? themeData.textTheme.headlineSmall!,
          errorTextStyle: decoration.errorTextStyle ??
              themeData.textTheme.bodySmall!
                  .copyWith(color: themeData.colorScheme.error),
          hintTextStyle: decoration.hintTextStyle ??
              themeData.textTheme.headlineSmall!
                  .copyWith(color: themeData.hintColor),
        );

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      !(oldDelegate is PasswordPaint && oldDelegate.text == this.text);

  _drawBoxTight(Canvas canvas, Size size) {
    /// Calculate the height of paint area for drawing the password field.
    /// it should honor the error text (if any) drawn by
    /// the actual texfield behind.
    /// but, since we can access the drawn textfield behind from here,
    /// we use a simple logic to calculate it.
    double mainHeight;
    if (decoration.errorText != null && decoration.errorText!.isNotEmpty) {
      mainHeight = size.height - (decoration.errorTextStyle!.fontSize! + 8.0);
    } else {
      mainHeight = size.height;
    }

    /// Force convert to [BoxTightDecoration].
    var dr = decoration as BoxTightDecoration;
    Paint borderPaint = Paint()
      ..color = dr.strokeColor
      ..strokeWidth = dr.strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    /// Assign paint if [solidColor] is not null
    Paint? insidePaint;
    if (dr.solidColor != null) {
      insidePaint = Paint()
        ..color = dr.solidColor!
        ..strokeWidth = dr.strokeWidth
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
    }

    Rect rect = Rect.fromLTRB(
      dr.strokeWidth / 2,
      dr.strokeWidth / 2,
      size.width - dr.strokeWidth / 2,
      mainHeight - dr.strokeWidth / 2,
    );

    if (insidePaint != null) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, dr.radius), insidePaint);
    }

    /// Draw the whole rect.
    canvas.drawRRect(RRect.fromRectAndRadius(rect, dr.radius), borderPaint);

    /// Calculate the width of each underline.
    double singleWidth =
        (size.width - dr.strokeWidth * (passwordLength + 1)) / passwordLength;

    for (int i = 1; i < passwordLength; i++) {
      double offsetX = singleWidth +
          dr.strokeWidth * i +
          dr.strokeWidth / 2 +
          singleWidth * (i - 1);
      canvas.drawLine(Offset(offsetX, dr.strokeWidth),
          Offset(offsetX, mainHeight - dr.strokeWidth), borderPaint);
    }

    /// The char index of the [text]
    var index = 0;
    var startY = 0.0;
    var startX = 0.0;

    /// Determine whether display obscureText.
    bool obscureOn = decoration.obscureStyle != null &&
        decoration.obscureStyle!.isTextObscure;

    text.runes.forEach((rune) {
      String code;
      if (obscureOn) {
        code = decoration.obscureStyle!.obscureText;
      } else {
        code = String.fromCharCode(rune);
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          style: decoration.textStyle,
          text: code,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      /// Layout the text.
      textPainter.layout();

      /// No need to compute again
      if (startY == 0.0) {
        startY = mainHeight / 2 - textPainter.height / 2;
      }
      startX = dr.strokeWidth * (index + 1) +
          singleWidth * index +
          singleWidth / 2 -
          textPainter.width / 2;
      textPainter.paint(canvas, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null) {
      decoration.hintText!.substring(index).runes.forEach((rune) {
        String code = String.fromCharCode(rune);
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            style: decoration.hintTextStyle,
            text: code,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

        /// Layout the text.
        textPainter.layout();

        startY = mainHeight / 2 - textPainter.height / 2;
        startX = dr.strokeWidth * (index + 1) +
            singleWidth * index +
            singleWidth / 2 -
            textPainter.width / 2;
        textPainter.paint(canvas, Offset(startX, startY));
        index++;
      });
    }
  }

  _drawBoxLoose(Canvas canvas, Size size) {
    /// Calculate the height of paint area for drawing the password field.
    /// it should honor the error text (if any) drawn by
    /// the actual texfield behind.
    /// but, since we can access the drawn textfield behind from here,
    /// we use a simple logic to calculate it.
    double mainHeight;
    if (decoration.errorText != null && decoration.errorText!.isNotEmpty) {
      mainHeight = size.height - (decoration.errorTextStyle!.fontSize! + 8.0);
    } else {
      mainHeight = size.height;
    }

    /// Force convert to [BoxLooseDecoration].
    var dr = decoration as BoxLooseDecoration;
    Paint borderPaint = Paint()
      ..color = dr.strokeColor
      ..strokeWidth = dr.strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    /// Assign paint if [solidColor] is not null
    Paint? insidePaint;
    if (dr.solidColor != null) {
      insidePaint = Paint()
        ..color = dr.solidColor!
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
    }

    double gapTotalLength = dr.gapSpaces?.reduce((a, b) => a + b) ??
        (passwordLength - 1) * dr.gapSpace;

    List<double> gapSpaces =
        dr.gapSpaces ?? List.filled(passwordLength - 1, dr.gapSpace);

    /// Calculate the width of each underline.
    double singleWidth =
        (size.width - dr.strokeWidth * 2 * passwordLength - gapTotalLength) /
            passwordLength;

    var startX = dr.strokeWidth / 2;
    var startY = mainHeight - dr.strokeWidth / 2;

    /// Draw the each rect of password.
    for (int i = 0; i < passwordLength; i++) {
      if (i < text.length && dr.enteredColor != null) {
        borderPaint.color = dr.enteredColor!;
      } else if (decoration.errorText != null &&
          decoration.errorText!.isNotEmpty) {
        /// only draw error-color as border-color or solid-color
        /// if errorText is not null
        if (dr.solidColor == null) {
          borderPaint.color = decoration.errorTextStyle!.color!;
        } else {
          insidePaint = Paint()
            ..color = decoration.errorTextStyle!.color!
            ..style = PaintingStyle.fill
            ..isAntiAlias = true;
        }
      } else {
        borderPaint.color = dr.strokeColor;
      }
      RRect rRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(
            startX,
            dr.strokeWidth / 2,
            startX + singleWidth + dr.strokeWidth,
            startY,
          ),
          dr.radius);
      canvas.drawRRect(rRect, borderPaint);
      if (insidePaint != null) {
        canvas.drawRRect(rRect, insidePaint);
      }
      startX += singleWidth +
          dr.strokeWidth * 2 +
          (i == passwordLength - 1 ? 0 : gapSpaces[i]);
    }

    /// The char index of the [text]
    var index = 0;
    startY = 0.0;

    /// Determine whether display obscureText.
    bool obscureOn = decoration.obscureStyle != null &&
        decoration.obscureStyle!.isTextObscure;

    text.runes.forEach((rune) {
      String code;
      if (obscureOn) {
        code = decoration.obscureStyle!.obscureText;
      } else {
        code = String.fromCharCode(rune);
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          style: decoration.textStyle,
          text: code,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      /// Layout the text.
      textPainter.layout();

      /// No need to compute again
      if (startY == 0.0) {
        startY = mainHeight / 2 - textPainter.height / 2;
      }
      startX = singleWidth * index +
          singleWidth / 2 -
          textPainter.width / 2 +
          _sumList(gapSpaces.take(index)) +
          dr.strokeWidth * index * 2 +
          dr.strokeWidth;
      textPainter.paint(canvas, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null) {
      decoration.hintText!.substring(index).runes.forEach((rune) {
        String code = String.fromCharCode(rune);
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            style: decoration.hintTextStyle,
            text: code,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

        /// Layout the text.
        textPainter.layout();

        startY = mainHeight / 2 - textPainter.height / 2;
        startX = singleWidth * index +
            singleWidth / 2 -
            textPainter.width / 2 +
            _sumList(gapSpaces.take(index)) +
            dr.strokeWidth * index * 2 +
            dr.strokeWidth;
        textPainter.paint(canvas, Offset(startX, startY));
        index++;
      });
    }
  }

  _drawUnderLine(Canvas canvas, Size size) {
    /// Calculate the height of paint area for drawing the password field.
    /// it should honor the error text (if any) drawn by
    /// the actual texfield behind.
    /// but, since we can access the drawn textfield behind from here,
    /// we use a simple logic to calculate it.
    double mainHeight;
    if (decoration.errorText != null && decoration.errorText!.isNotEmpty) {
      mainHeight = size.height - (decoration.errorTextStyle!.fontSize! + 8.0);
    } else {
      mainHeight = size.height;
    }

    /// Force convert to [UnderlineDecoration].
    var dr = decoration as UnderlineDecoration;
    Paint underlinePaint = Paint()
      ..color = dr.color
      ..strokeWidth = dr.lineHeight
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    var startX = 0.0;
    var startY = mainHeight - dr.lineHeight;

    double gapTotalLength = dr.gapSpaces?.reduce((a, b) => a + b) ??
        (passwordLength - 1) * dr.gapSpace;

    List<double> gapSpaces =
        dr.gapSpaces ?? List.filled(passwordLength - 1, dr.gapSpace);

    /// Calculate the width of each underline.
    double singleWidth = (size.width - gapTotalLength) / passwordLength;

    for (int i = 0; i < passwordLength; i++) {
      if (i < text.length && dr.enteredColor != null) {
        underlinePaint.color = dr.enteredColor!;
      } else if (decoration.errorText != null &&
          decoration.errorText!.isNotEmpty) {
        /// only draw error-color as underline-color if errorText is not null
        underlinePaint.color = decoration.errorTextStyle!.color!;
      } else {
        underlinePaint.color = dr.color;
      }
      canvas.drawLine(Offset(startX, startY),
          Offset(startX + singleWidth, startY), underlinePaint);
      startX += singleWidth + (i == passwordLength - 1 ? 0 : gapSpaces[i]);
    }

    /// The char index of the [text]
    var index = 0;
    startX = 0.0;
    startY = 0.0;

    /// Determine whether display obscureText.
    bool obscureOn = decoration.obscureStyle != null &&
        decoration.obscureStyle!.isTextObscure;

    text.runes.forEach((rune) {
      String code;
      if (obscureOn) {
        code = decoration.obscureStyle!.obscureText;
      } else {
        code = String.fromCharCode(rune);
      }
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          style: decoration.textStyle,
          text: code,
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      /// Layout the text.
      textPainter.layout();

      /// No need to compute again
      if (startY == 0.0) {
        startY = mainHeight / 2 - textPainter.height / 2;
      }
      startX = singleWidth * index +
          singleWidth / 2 -
          textPainter.width / 2 +
          _sumList(gapSpaces.take(index));
      textPainter.paint(canvas, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null) {
      decoration.hintText!.substring(index).runes.forEach((rune) {
        String code = String.fromCharCode(rune);
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            style: decoration.hintTextStyle,
            text: code,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

        /// Layout the text.
        textPainter.layout();

        startY = mainHeight / 2 - textPainter.height / 2;
        startX = singleWidth * index +
            singleWidth / 2 -
            textPainter.width / 2 +
            _sumList(gapSpaces.take(index));
        textPainter.paint(canvas, Offset(startX, startY));
        index++;
      });
    }
  }

  /// Return the sum of the [list] even the [list] is empty.
  T _sumList<T extends num>(Iterable<T> list) {
    T sum = 0 as T;
    for (final n in list) {
      sum = (sum + n) as T;
    }

    return sum;
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (decoration.passwordEntryType) {
      case PasswordEntryType.boxTight:
        {
          _drawBoxTight(canvas, size);
          break;
        }
      case PasswordEntryType.boxLoose:
        {
          _drawBoxLoose(canvas, size);
          break;
        }
      case PasswordEntryType.underline:
        {
          _drawUnderLine(canvas, size);
          break;
        }
    }
  }
}
