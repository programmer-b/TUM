part of 'package:tum/Widgets/widgets.dart';

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<FirebaseHelper>(context);
    bool _imageError = false;
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
              child: provider.event!.snapshot.child('profileImage').value !=
                      null
                  ? CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      provider.event!.snapshot.child('profileImage').value.toString(),
                    ),
                    onBackgroundImageError: (_,__) {
                      _imageError = true;
                    },

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
