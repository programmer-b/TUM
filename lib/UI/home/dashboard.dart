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
    final provider = Provider.of<FirebaseHelper>(context);
    final _controller = TextEditingController();
    return provider.event == null
        ? scaffoldIndicator()
        : Scaffold(
            appBar: appBar(context, actions: []),
            drawer: const MyDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.event!.snapshot
                        .child('profile/fullName')
                        .value
                        .toString(),
                    style: const TextStyle(fontSize: 21),
                  ),
                  SizedBox(height: Dimens.defaultPadding * 2),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                    ),
                  ),
                  SizedBox(height: Dimens.defaultPadding * 2),
                  MyButton(
                    text: 'Update',
                    onPressed: () {
                      provider.update({'profile/fullName': _controller.text});
                    },
                  )
                ],
              )),
            ),
          );
  }
}
