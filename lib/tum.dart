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

class TUM extends StatefulWidget {
  const TUM({Key? key}) : super(key: key);

  @override
  State<TUM> createState() => _TUMState();
}

class _TUMState extends State<TUM> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Technical University of Mombasa',
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          routes: {
            '/login' : (context) => const LoginScreen(),
            '/register' : (context) => const RegisterScreen(),
          },
          home: const LoginScreen(),
        );
      },
    );
  }
}
