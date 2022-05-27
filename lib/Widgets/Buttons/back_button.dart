part of 'package:tum/Widgets/widgets.dart';


class BackButton extends StatelessWidget {
  const BackButton({Key? key, required this.route}) : super(key: key);
  final String route;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      icon: const Icon(FontAwesomeIcons.angleLeft),
      color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
      splashColor: themeProvider.isDarkMode ? Colors.white70 : Colors.grey,
    );
  }
}

