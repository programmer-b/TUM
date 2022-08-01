part of 'package:tum/Widgets/widgets.dart';

PreferredSizeWidget customTransParentAppBar() {
  return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness:
              provider.isDarkMode ? Brightness.light : Brightness.dark));
}

PreferredSizeWidget browserAppBar(BuildContext context, String name) {
    return appBar(context,
        actions: [const NavigationControls()],
        title: Txt(text: name));
  }