import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tum/UI/setup/setup.dart';
import 'package:tum/provider/provider.dart';

import 'Firebase/firebase.dart';
import 'UI/auth/auth.dart';
import 'UI/dashboard.dart';

class TUM extends StatefulWidget {
  const TUM({Key? key}) : super(key: key);

  @override
  State<TUM> createState() => _TUMState();
}

class _TUMState extends State<TUM> {
  final FirebaseHelper helper = FirebaseHelper();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<FirebaseAuthProvider>(
            create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider<FirebaseHelper>(create: (_) => FirebaseHelper()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Technical University of Mombasa',
            themeMode: provider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/forgotPassword': (context) => const ForgotPasswordScreen(),
              '/dashboard': (context) => const DashBoard(),
              '/checkEmail': (context) => const CheckEmail(),
              '/setup': (context) => const SetupScreen(),
            },
            home: StreamBuilder<User?>(
                stream: Auth.instance.authStateChange(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return FutureBuilder(
                        future: helper.rootFirebaseIsExists(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data == true &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return const DashBoard();
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _indicator();
                          } else {
                            return const SetupScreen();
                          }
                        });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _indicator();
                  } else {
                    return const LoginScreen();
                  }
                }),
          );
        },
      ),
    );
  }

  Widget _indicator() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
