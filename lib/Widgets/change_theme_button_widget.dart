part of 'package:tum/Widgets/widgets.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final databaseTheme = Provider.of<FirebaseHelper>(context);

    return IconButton(
      tooltip: "Toggle theme",
      icon: Icon(
        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: Colors.white,
      ),
      onPressed: () async {
        if (themeProvider.isDarkMode) {
          databaseTheme.update({"settings/theme": "light"});
        } else {
          databaseTheme.update({"settings/theme": "dark"});
        }
      },
    );
  }
}
