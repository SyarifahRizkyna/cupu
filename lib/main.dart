
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import './layout/auth_layout.dart';
import 'package:cupu/layout/app_layout.dart';
import 'package:cupu/layout/status_layout.dart';
import 'package:cupu/stores/user_store.dart';

void main() => runApp(
      Injector(
        inject: <Inject>[
          Inject<User?>.future(() async {
            final FirebaseAuth _auth = FirebaseAuth.instance;
            final User? _user = _auth.currentUser;
            return _user;
          }),
        ],
        builder: (BuildContext context) {
          final ReactiveModel<User?> _userStore = Injector.getAsReactive<User?>();

          return _userStore.whenConnectionState(
            onIdle: () {
              return const StatusLayout(
                message: "Init Cupu App",
              );
            },
            onWaiting: () {
              return const StatusLayout(
                message: "Loading Cupu App...",
              );
            },
            onError: (err) {
              return StatusLayout(
                message: err.toString(),
              );
            },
            onData: (User? user) {
              return Injector(
                inject: <Inject>[
                  Inject<UserStore>(() => UserStore()),
                ],
                builder: (BuildContext context) {
                  final ReactiveModel<UserStore> userStore = Injector.getAsReactive<UserStore>();

                  if (user != null || userStore.state.loggedIn) {
                    return const AppLayout();
                  }

                  return AuthLayout();
                },
              );
            },
          );
        },
      ),
    );
