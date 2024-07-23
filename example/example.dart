import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_input/password_input.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  /// Control the input text field.
  TextEditingController _passwordEditingController = TextEditingController();

  String _errorMessage = "";

  /// Decorate the outside of the Pin.
  late PasswordDecoration _pinDecoration;

  late PasswordDecoration _looseDecoration;

  late PasswordDecoration _tightDecoration;

  @override
  void initState() {
    super.initState();

    /// for UnderLine Decoration
    _pinDecoration = UnderlineDecoration(
      enteredColor: Colors.black,
      color: Colors.black,
      errorText: _errorMessage,
      textStyle: TextStyle(color: Colors.red),
    );

    /// for BoxLoose Decoration

    _looseDecoration = BoxLooseDecoration(
      enteredColor: Colors.black,
      errorText: _errorMessage,
      textStyle: TextStyle(color: Colors.red),
    );

    /// for BoxTight Decoration

    _tightDecoration = BoxTightDecoration(
      strokeColor: Colors.black,
      errorText: _errorMessage,
      textStyle: TextStyle(color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        child: Text("ENTER PASSWORD",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w900)),
                      ),
                      Text(
                        "Please Enter Password.",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PasswordInputTextField(
                        passwordLength: 6,
                        decoration: _pinDecoration,
                        controller: _passwordEditingController,
                        keyboardType: TextInputType.text,
                        autoFocus: true,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9_@.]'
                                  r''))
                        ],
                        textInputAction: TextInputAction.done,
                        onSubmit: (password) {
                          if (password.isEmpty || password.length > 6)
                            setState(() {
                              _errorMessage = "Enter Password";
                            });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PasswordInputTextField(
                        passwordLength: 6,
                        decoration: _looseDecoration,
                        controller: _passwordEditingController,
                        keyboardType: TextInputType.text,
                        autoFocus: true,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9_@.]'
                                  r''))
                        ],
                        textInputAction: TextInputAction.done,
                        onSubmit: (password) {
                          if (password.isEmpty || password.length > 6)
                            setState(() {
                              _errorMessage = "Enter Password";
                            });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PasswordInputTextField(
                        passwordLength: 6,
                        decoration: _tightDecoration,
                        controller: _passwordEditingController,
                        keyboardType: TextInputType.text,
                        autoFocus: true,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9_@.]'
                                  r''))
                        ],
                        textInputAction: TextInputAction.done,
                        onSubmit: (password) {
                          if (password.isEmpty || password.length > 6)
                            setState(() {
                              _errorMessage = "Enter Password";
                            });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                    onPressed: () {
                      if (_passwordEditingController.value.text.isEmpty ||
                          _passwordEditingController.value.text.length > 6)
                        setState(() {
                          _errorMessage = "Enter Password";
                        });
                      else
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PasswordScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 15.0),
                      child: Text(
                        "VERIFY",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
