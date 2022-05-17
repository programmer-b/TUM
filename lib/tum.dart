import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

part './provider/theme_provider.dart';
part './UI/dashboard.dart';
part './Widgets/change_theme_button_widget.dart';
part './Constants/colors.dart';
part './UI/auth/login_screen.dart';
part './Constants/assets.dart';
part './Widgets/my_text_field.dart';
part './Widgets/txt.dart';
part './Constants/dimens.dart';
part './Widgets/text_button.dart';
part './Widgets/my_button.dart.dart';
part './UI/auth/register_screen.dart';
part './Widgets/Logo.dart';
part './Widgets/back_button.dart';
part './UI/auth/forgot_password_screen.dart';
part './Firebase/firebase_helper.dart';
part './Firebase/firebase_auth_provider.dart';
part './Utils/dialogs.dart';
part './Widgets/form_fields.dart';

final Dialog dialog = Dialog();
final FormField formField = FormField();

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
              '/dashboard' : (context) => const DashBoard(title: 'TUM demo'),
            },
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
