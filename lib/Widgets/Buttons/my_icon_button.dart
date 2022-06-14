part of 'package:tum/Widgets/widgets.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton(
      {Key? key,
      this.backgroundColor = Colors.transparent,
      this.onPressed,
      this.icon,
      this.iconColor = Colors.white,
      this.iconSize})
      : super(key: key);

  final Color backgroundColor;
  final void Function()? onPressed;
  final IconData? icon;
  final Color iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(Dimens.iconButtonPadding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          color: iconColor,
          iconSize: iconSize,
        ));
  }
}
