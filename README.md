# 👏 Password Input

A new Flutter package which helps developers to get input of password in best UI.


The source code is **100% Dart**, and everything resides in the [/lib](https://github.com/shekharAggarwal/Password-Input/tree/master/lib) folder.


### Show some :heart: and star the repo to support the project

[![GitHub stars](https://img.shields.io/github/stars/shekharAggarwal/Password-Input.svg?style=social&label=Star)](https://github.com/shekharAggarwal/Password-Input) [![GitHub forks](https://img.shields.io/github/forks/shekharAggarwal/Password-Input.svg?style=social&label=Fork)](https://github.com/shekharAggarwal/Password-Input/fork) [![GitHub watchers](https://img.shields.io/github/watchers/shekharAggarwal/Password-Input.svg?style=social&label=Watch)](https://github.com/shekharAggarwal/Password-Input) [![GitHub followers](https://img.shields.io/github/followers/shekharAggarwal.svg?style=social&label=Follow)](https://github.com/shekharAggarwal/Password-Input)  
[![Twitter Follow](https://img.shields.io/twitter/follow/ShekharAggarw17.svg?style=social)](https://twitter.com/ShekharAggarw17)

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://opensource.org/licenses/Apache-2.0)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://github.com/shekharAggarwal/Password-Input/blob/master/LICENSE)

## quick UIs made using Password Input

| Without Input                                                                                                                 | With Input                                                                                                                       |
| ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/shekharAggarwal/Password-Input/blob/master/img/with_input.png?raw=true" width="300"/>            | <img src="https://github.com/shekharAggarwal/Password-Input/blob/master/img/with_input.png?raw=true" width="300"/>               |


## 💻 Installation
In the `dependencies:` section of your `pubspec.yaml`, add the following line:

```yaml
  password_input: <latest_version>
```

## ❔ Usage

```dart
import 'package:password_input/password_input.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      //Use this child anywhere in your app
      child: PasswordInputTextField(
        passwordLength: 6,
        keyboardType: TextInputType.text,
        autoFocus: true,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_@.]'
              r''))
        ],
        textInputAction: TextInputAction.done,
        onSubmit: (password) {
          if (password == null || password.isEmpty || password.length > 6)
            setState(() {
              _errorMessage = "Enter Password";
            });
        },
      ),
    );
  }
}

```

## 👨 Developed By

```
Shekhar Aggarwal
```

<a href="https://twitter.com/ShekharAggarw17"><img src="https://github.com/aritraroy/social-icons/blob/master/twitter-icon.png?raw=true" width="60"></a>
<a href="https://www.linkedin.com/in/shekharaggarwal"><img src="https://github.com/aritraroy/social-icons/blob/master/linkedin-icon.png?raw=true" width="60"></a>
<a href="https://instagram.com/theshekharaggarwal"><img src="https://github.com/aritraroy/social-icons/blob/master/instagram-icon.png?raw=true" width="60"></a>

# 👍 How to Contribute
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

# 📃 Copyright-and-license

Code and documentation Copyright 2021 [Shekhar Aggarwal](https://shekhar.live). Code released under the [Apache License](./LICENSE).


## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).