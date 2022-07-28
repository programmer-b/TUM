part of 'package:tum/UI/home/home.dart';

class Eregister extends StatefulWidget {
  const Eregister({Key? key}) : super(key: key);

  @override
  State<Eregister> createState() => _EregisterState();
}

class _EregisterState extends State<Eregister> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    final registrationNumber = provider.home!.snapshot
        .child('profile/registrationNumber')
        .value
        .toString();
    if (provider.home!.snapshot
            .child('eregister/access/opened')
            .value
            .toString() !=
        'true') {
      Future.delayed(
          Duration.zero,
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PortalWelcomeScreen(
                    password: registrationNumber.toUpperCase(),
                    username: registrationNumber.toUpperCase(),
                    title: 'eregister',
                  ))));
    }
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
        title: const Txt(text: "Eregister"));
  }
}
