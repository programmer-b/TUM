part of 'package:tum/tum.dart';

class TxtButton extends StatelessWidget {
  const TxtButton(
      {Key? key, this.onPressed, required this.text, this.alignment})
      : super(key: key);

  final Function()? onPressed;
  final String text;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
        alignment: alignment,
        width: double.infinity,
        child: TextButton(

            onPressed: onPressed,
            child: Txt(
                fontWeight: FontWeight.bold,
                text: text,
                upperCaseFirst: true,
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : Colorz.primaryGreen)));
  }
}
