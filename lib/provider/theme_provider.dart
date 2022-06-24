part of 'package:tum/provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance?.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  // void toggleTheme({required bool isDarkMode}) {
  //   themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

  //   notifyListeners();
  // }

  ThemeMode? getTheme(FirebaseHelper provider) {
    if (provider.event != null) {
      final String theme =
          provider.event!.snapshot.child("settings/theme").value.toString();

      if (theme == "systemDefault") {
        themeMode = ThemeMode.system;
        return ThemeMode.system;
      }
      if (theme == "light") {
        themeMode = ThemeMode.light;
        return ThemeMode.light;
      }
      if (theme == "dark") {
        themeMode = ThemeMode.dark;
        return ThemeMode.dark;
      }
      return ThemeMode.light;
    } else {
      return ThemeMode.light;
    }
    
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
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.blue,
        ),
      ),
      fontFamily: 'Raleway',
      scaffoldBackgroundColor: Colors.grey[200],
      primaryColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.grey),
      colorScheme:
          const ColorScheme.light().copyWith(secondary: Colorz.primaryGreen));
}
