part of 'package:tum/Widgets/widgets.dart';

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          provider.isDarkMode ? Colors.white : Colorz.primaryGreen),
    );
  }
}

Widget circularProgressIndicator({Color indicatorColor = Colors.white, double scale = 0.38, double width = 50}){
  
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
