part of 'package:tum/Widgets/widgets.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton(
      {Key? key,
      this.backgroundColor = Colors.transparent,
      this.onPressed,
      this.icon,
      this.iconColor = Colors.white,
      this.iconSize,
      this.toolTip})
      : super(key: key);

  final Color backgroundColor;
  final void Function()? onPressed;
  final IconData? icon;
  final Color iconColor;
  final double? iconSize;
  final String? toolTip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: iconColor,
      iconSize: iconSize,
      tooltip: toolTip,
    );
  }
}
