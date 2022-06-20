part of 'package:tum/Widgets/widgets.dart';

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DrawerHeader(
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? Colorz.appBarColorDark
              : Colorz.primaryGreen,
        ),
        child: ListView(
          children: const <Widget>[UserAvatar()],
        ));
  }
}
