part of 'package:tum/UI/home/home.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
    context.read<FirebaseHelper>().read();
  }

  @override
  Widget build(BuildContext context) {
    _readDatabase();
    final provider = Provider.of<FirebaseHelper>(context);
    return provider.event == null
        ? scaffoldIndicator()
        : Scaffold(
            appBar: appBar(context, actions: []),
            drawer: const MyDrawer(),
            body: Center(
                child: Text(
              provider.event!.snapshot.child('fullName').value.toString(),
              style: const TextStyle(fontSize: 21),
            )),
          );
  }
}
