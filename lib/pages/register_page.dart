import 'package:cupu/handlers/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:cupu/stores/user_store.dart';
import 'package:cupu/components/ti_component.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String konfirmasiPassword;

  @override
  Widget build(BuildContext context) {
    final ReactiveModel<UserStore> _userStore =
        Injector.getAsReactive<UserStore>(context: context);

    return Container(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Daftar Cupu App"),
            SizedBox(
              height: 20.0,
            ),
            TiComponent(
              label: "Email",
              hint: "user@contoh.com",
              keyboardType: TextInputType.emailAddress,
              validate: (String value) {
                if (value.isEmpty) {
                  return "Email diperlukan";
                } else if (!EmailValidator.validate(value)) {
                  return "Email tidak valid";
                } else {
                  return null;
                }
              },
              change: (String value) {
                email = value;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TiComponent(
              label: "Password",
              hint: "Kata kunci",
              isPassword: true,
              validate: (String value) {
                if (value.isEmpty) {
                  return "Password diperlukan";
                } else {
                  return null;
                }
              },
              change: (String value) {
                password = value;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TiComponent(
              label: "Konfirmasi password",
              hint: "Konfirmasi lagi",
              isPassword: true,
              validate: (String value) {
                if (value.isEmpty) {
                  return "Konfirmasi password diperlukan";
                } else if (value != password) {
                  return "Password tidak cocok";
                } else {
                  return null;
                }
              },
              change: (String value) {
                konfirmasiPassword = value;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "DAFTAR",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.lightBlue,
                  onPressed: () {
                    doRegister(_userStore);
                  }
                ),
                SizedBox(
                  width: 15.0,
                ),
                FlatButton(
                  child: Text(
                    "BATAL",
                    style: TextStyle(color: Colors.red,),
                  ),
                  onPressed: () {
                    _userStore.setState((state) => state.setRegisterStatus(false));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void doRegister(ReactiveModel<UserStore> _userStore) async {
    if (_formKey.currentState.validate()) {
      final AuthHandler _auth = AuthHandler(
        email: email,
        password: password
      );

      final Map<String, dynamic> status = await _auth.register();

      if (status["isvalid"]) {
        _userStore.setState((state) => state.setRegisterStatus(false));
        _userStore.setState((state) => state.setLogStatus(true));
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(status["data"]),
          )
        );
      }
    }
  }
}
