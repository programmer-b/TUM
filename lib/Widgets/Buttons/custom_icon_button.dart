part of 'package:tum/Widgets/widgets.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {Key? key, this.onPressed, this.icon, this.iconSize, this.toolTip})
      : super(key: key);

  final void Function()? onPressed;
  final IconData? icon;
  final Color iconColor = Colors.white;
  final double? iconSize;
  final String? toolTip;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MyIconButton(
      iconColor: themeProvider.isDarkMode ? Colors.white : Colorz.primaryGreen,
      icon: icon,
      iconSize: iconSize,
      toolTip: toolTip,
    );
  }
}
