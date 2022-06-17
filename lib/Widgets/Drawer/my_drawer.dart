part of 'package:tum/Widgets/widgets.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<FirebaseHelper>(context);
    bool _imageError = false;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.67,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [_drawerHeader(themeProvider, provider, _imageError)],
          ),
        ),
      ),
    );
  }

  Widget _drawerHeader(
      ThemeProvider themeProvider, FirebaseHelper provider, bool _imageError) {
    return DrawerHeader(
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? Colorz.appBarColorDark
              : Colorz.primaryGreen,
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child:
                  provider.event!.snapshot.child('profileImage').value != null
                      ? CircleAvatar(
                          backgroundImage:  FirebaseImage(
                            provider.event!.snapshot.child('profileImage').value.toString(),
                          ),
                          onBackgroundImageError: (_, __) =>
                              setState(() => _imageError = true),
                        )
                      : const CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage(Assets.defaultAvatar)),
              // child: CachedNetworkImage(
              //   imageUrl: provider.event!.snapshot
              //       .child('profileImage')
              //       .value
              //       .toString(),
              //   placeholder: (context, url) =>
              //       const MyProgressIndicator(customColor: true),
              //   errorWidget: (context, url, error) => Icon(Icons.error),
              // ),
            ),
          ],
        ));
  }
}
