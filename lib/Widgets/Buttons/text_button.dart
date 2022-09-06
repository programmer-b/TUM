part of 'package:tum/Widgets/widgets.dart';

class TxtButton extends StatelessWidget {
  const TxtButton(
      {Key? key,
      this.onPressed,
      required this.text,
      this.alignment,
      this.padding,
      this.textColor})
      : super(key: key);

  final Function()? onPressed;
  final String text;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
        alignment: alignment,
        width: double.infinity,
        padding: padding,
        child: TextButton(
            onPressed: onPressed,
            child: Txt(
                fontWeight: FontWeight.bold,
                text: text,
                color: textColor ?? (themeProvider.isPreDarkMode
                    ? Colors.white
                    : Colorz.primaryGreen))));
  }
}
 