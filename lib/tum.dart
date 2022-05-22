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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<FirebaseAuthProvider>(
            create: (_) => FirebaseAuthProvider())
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
              '/dashboard': (context) => const DashBoard(title: 'TUM demo'),
              '/checkEmail' : (context) => const CheckEmail(),
            },
            home: StreamBuilder<User?>(
              stream: Auth.instance.authStateChange(),
              builder: (context, snapshot) {
                // return const LoginScreen();
                return const SetupScreen();
              }
            ),
          );
        },
      ),
    );
  }
}
