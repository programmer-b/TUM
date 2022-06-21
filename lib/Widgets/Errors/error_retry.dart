part of 'package:tum/Widgets/widgets.dart';

class ErrorRetry extends StatefulWidget {
  const ErrorRetry({Key? key, this.onPressed}) : super(key: key);
  final Function()? onPressed;

  @override
  State<ErrorRetry> createState() => _ErrorRetryState();
}

class _ErrorRetryState extends State<ErrorRetry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Txt(
              text: 'Oops! Something went wrong',
            ),
            SizedBox(height: Dimens.defaultPadding * 2),
            MyButton(
              text: 'Retry',
              width: 150,
              onPressed: widget.onPressed,
            )
          ],
        ),
      ),
    );
  }
}
