part of 'package:tum/Widgets/widgets.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      this.width = double.infinity,
      this.alignment,
      this.onPressed,
      required this.text,
      this.textUpperCase = false})
      : super(key: key);

  final double width;
  final AlignmentGeometry? alignment;
  final Function()? onPressed;
  final String text;
  final bool textUpperCase;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: width,
      alignment: alignment,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colorz.primaryGreen),
        onPressed: onPressed,
        child: Txt(
          text: text,
          fullUpperCase: textUpperCase,
        ),
      ),
    );
  }
}
