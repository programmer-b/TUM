part of 'package:tum/tum.dart';


class BackButton extends StatefulWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  State<BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<BackButton> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },

        icon: const Icon(Icons.arrow_back), color: themeProvider.isDarkMode ? Colors.white : Colors.black),
    );
  }
}
