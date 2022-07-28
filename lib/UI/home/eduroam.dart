part of 'package:tum/UI/home/home.dart';

class Eduroam extends StatefulWidget {
  const Eduroam({Key? key}) : super(key: key);

  @override
  State<Eduroam> createState() => _EduroamState();
}

class _EduroamState extends State<Eduroam> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await pushPage(context, const DashBoard());
      },
      child: Scaffold(
        appBar: _appBar(context),
        drawer: const MyDrawer(),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return appBar(context,
        actions: [
          MyIconButton(
            icon: Icons.more_vert,
            onPressed: () {},
            toolTip: "More options",
          )
        ],
        title: const Txt(text: "Eduroam"));
  }
}
