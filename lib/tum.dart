import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

part './provider/theme_provider.dart';
part './UI/dashboard.dart';
part './Widgets/change_theme_button_widget.dart';

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
     builder: (context,_){
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Technical University of Mombasa',
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          home: const DashBoard(title: 'Demo Dashboard',),
        );
     },
    );
  }
}
