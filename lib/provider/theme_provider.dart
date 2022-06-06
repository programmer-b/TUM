part of 'package:tum/provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance?.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.black54,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      fontFamily: 'Raleway',
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white));

  static final lightTheme = ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colorz.primaryGreen,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: Colors.blue,),
      ),
      fontFamily: 'Raleway',
      scaffoldBackgroundColor: Colors.grey[200],
      primaryColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.grey),
      colorScheme:
          const ColorScheme.light().copyWith(secondary: Colorz.primaryGreen));
}
