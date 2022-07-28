part of 'package:tum/Widgets/widgets.dart';

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({
    Key? key,
    this.color = Colors.white,
    this.customColor = false,
  }) : super(key: key);

  final Color color;
  final bool customColor;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(customColor
            ? color
            : provider.isDarkMode
                ? Colors.white
                : Colorz.primaryGreen),
      ),
    );
  }
}

Widget circularProgressIndicator(
    {Color indicatorColor = Colors.white,
    double scale = 0.38,
    double width = 50}) {
  return Transform.scale(
    scale: scale,
    child: SizedBox(
      width: width,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    ),
  );
}

Widget normalCircularIndicator({Color? indicatorColor}) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(indicatorColor!),
  );
}

final ThemeProvider provider = ThemeProvider();

Widget scaffoldIndicator() {
  return Scaffold(
    appBar: customTransParentAppBar(),
    body: const Center(child: MyProgressIndicator()),
  );
}
