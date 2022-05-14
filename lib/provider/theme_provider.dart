part of 'package:tum/tum.dart';

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

    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
    iconTheme: const IconThemeData(color: Colors.white)
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey[50],
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(color: Colors.grey)
  );
}
