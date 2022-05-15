part of 'package:tum/tum.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      this.width,
      this.alignment,
      this.onPressed,
      required this.text,
      this.textUpperCase = false})
      : super(key: key);

  final double? width;
  final AlignmentGeometry? alignment;
  final Function()? onPressed;
  final String text;
  final bool textUpperCase;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: alignment,
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colorz.primaryGreen),
          onPressed: onPressed,
          child: Txt(
            text: text,
            fullUpperCase: textUpperCase,
          ),
        ),
      ),
    );
  }
}
