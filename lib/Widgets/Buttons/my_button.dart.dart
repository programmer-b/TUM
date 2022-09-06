part of 'package:tum/Widgets/widgets.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      this.width = double.infinity,
      this.alignment,
      this.onPressed,
      required this.text,
      this.textUpperCase = false,
      this.loading = false,
      this.child,
      this.shouldOverrideLoading = false,
      this.primaryColor = Colorz.primaryGreen,
      this.textColor})
      : super(key: key);

  final double width;
  final AlignmentGeometry? alignment;
  final Function()? onPressed;
  final String text;
  final bool textUpperCase;
  final bool loading;
  final Widget? child;
  final bool shouldOverrideLoading;
  final Color primaryColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: alignment,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        onPressed: onPressed,
        // child: child,
        child: context.read<FirebaseAuthProvider>().loading ||
                context.read<FirebaseApi>().uploading ||
                context.read<FirebaseHelper>().loading ||
                loading && !shouldOverrideLoading
            ? const MyIndicator()
            : Txt(
                text: text,
                fullUpperCase: textUpperCase,
                color: textColor,
              ),
      ),
    );
  }
}
