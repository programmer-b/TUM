part of 'package:tum/UI/home/home.dart';

class Elearning extends StatefulWidget {
  const Elearning({ Key? key }) : super(key: key);

  @override
  State<Elearning> createState() => _ElearningState();
}

class _ElearningState extends State<Elearning> {
  @override
  Widget build(BuildContext context) {
     final provider = Provider.of<FirebaseHelper>(context);
    final registrationNumber = provider.home!.snapshot
        .child('profile/registrationNumber')
        .value
        .toString();
    if (provider.home!.snapshot
            .child('elearning/access/opened')
            .value
            .toString() !=
        'true') {
      Future.delayed(
          Duration.zero,
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PortalWelcomeScreen(
                    password: registrationNumber.toLowerCase().replaceAll('/', ''),
                    username: registrationNumber.toLowerCase().replaceAll('/', ''),
                    title: 'elearning',
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
        title: const Txt(text: "Elearning"));
  }
}