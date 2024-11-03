import 'package:cupu/handlers/auth_handler.dart';
import 'package:cupu/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:cupu/pages/app_page.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Cupu App"),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                final AuthHandler _auth = AuthHandler();
                final ReactiveModel<UserStore> _user = Injector.getAsReactive<UserStore>();
                
                await _auth.signOut();
                _user.setState((state) => state.setLogStatus(false));
              },
            ),
          ],
        ),
        body: const AppPage(),
      ),
    );
  }
}
