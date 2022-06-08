part of 'package:tum/Constants/constants.dart';

class Styles {
  static SystemUiOverlayStyle value(ThemeProvider provider) {
    return SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarIconBrightness: Brightness.dark,
        // statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: provider.isDarkMode
            ? Colorz.navigationBarDarkColor
            : Colorz.navigationBarLightColor,
        systemNavigationBarIconBrightness:
            provider.isDarkMode ? Brightness.light : Brightness.dark);
  }
}
