part of 'package:tum/tum.dart';


class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(value: themeProvider.isDarkMode, onChanged: (value){
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      provider.toggleTheme(value);
    });
  }
}
