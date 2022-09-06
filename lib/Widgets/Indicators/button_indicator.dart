part of 'package:tum/Widgets/widgets.dart';

class MyIndicator extends StatelessWidget {
  const MyIndicator(
      {Key? key,
      this.indicatorColor = Colors.white,
      this.indicatorWidth = 50,
      this.transformScale = 0.4,
      this.text = 'Please wait ...',
      this.textColor = Colors.white})
      : super(key: key);
  final Color indicatorColor;
  final double indicatorWidth;
  final double transformScale;
  final String text;
  final Color textColor;
  final double textSize = 12;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        circularProgressIndicator(
          indicatorColor: indicatorColor,
          width: indicatorWidth,
          scale: transformScale,
        ),
        Dimens.progressToText(),
        Txt(
          text: text,
          color: textColor,
          fontSize: textSize,
        )
      ],
    );
  }
}

class MyCircularIndicatpr extends StatelessWidget {
  const MyCircularIndicatpr({Key? key, this.valueColor = Colors.white }) : super(key: key);
  final Color valueColor;
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(valueColor),
    );
  }
}