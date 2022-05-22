part of 'package:tum/Widgets/widgets.dart';

class IconWidget extends StatelessWidget {
  const IconWidget(
      {Key? key,
      this.size,
      required this.icon,
      this.darkModeColor = Colors.white70,
      this.lightModeColor = Colorz.primaryGreen})
      : super(key: key);
  final double? size;
  final IconData icon;
  final Color darkModeColor;
  final Color lightModeColor;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Icon(
      icon,
      color: themeProvider.isDarkMode ? darkModeColor : lightModeColor,
      size: size,
    );
  }
}
