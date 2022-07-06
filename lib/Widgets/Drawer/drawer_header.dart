part of 'package:tum/Widgets/widgets.dart';

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<FirebaseHelper>(context);

    String value(String path) {
      return provider.home!.snapshot.child(path).value.toString();
    }

    return Container(
        padding: const EdgeInsets.only(
          left: 8,
          top: 40,
        ),
        alignment: Alignment.topLeft,
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? Colors.black54
              : Colorz.primaryGreen,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[UserAvatar(), ChangeThemeButtonWidget()],
            ),
            SizedBox(
              height: Dimens.defaultPadding,
            ),
            Txt(
              text: Operations.firstAndLastName(value('profile/fullName')),
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            SizedBox(
              height: Dimens.defaultPadding,
            ),
            Txt(
              text: value('profile/registrationNumber'),
              color: Colors.white,
            ),
          ],
        ));
  }
}
