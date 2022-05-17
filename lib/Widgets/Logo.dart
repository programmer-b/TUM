part of 'package:tum/Widgets/widgets.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Image.asset(
      themeProvider.isDarkMode ? Assets.logoDark : Assets.logoLight,
      width: 200,
    );
  }
}
