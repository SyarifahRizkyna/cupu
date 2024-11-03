import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../pages/login_page.dart';
import 'package:cupu/pages/register_page.dart';
import 'package:cupu/stores/user_store.dart';

class AuthLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil ReactiveModel dari UserStore
    final ReactiveModel<UserStore> _userStore = Injector.getAsReactive<UserStore>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: _userStore.state.isRegister ? RegisterPage() : LoginPage(),
        ),
      ),
    );
  }
}
