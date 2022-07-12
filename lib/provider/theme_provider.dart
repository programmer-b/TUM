part of 'package:tum/provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
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
    if (provider.home != null) {
      final String theme =
          provider.home!.snapshot.child("settings/theme").value.toString();

      if (theme == "system") {
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
      return ThemeMode.system;
    } else {
      return ThemeMode.system;
    }
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
      appBarTheme: const AppBarTheme(
        
        color: Colors.black54,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white));

  static final lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colorz.primaryGreen,
    ),
      appBarTheme: const AppBarTheme(
        color: Colorz.primaryGreen,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.blue,
        ),
      ),
      colorSchemeSeed: Colorz.primaryGreen,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: Colors.grey[200],
      // primaryColor: Colors.white,
      listTileTheme: const ListTileThemeData(
          selectedColor: Colorz.primaryGreen, textColor: Colors.black54),
      iconTheme: const IconThemeData(color: Colors.grey));
     
  // colorScheme:
  //     const ColorScheme.light().copyWith(secondary: Colorz.primaryGreen));
}
