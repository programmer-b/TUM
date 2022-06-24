part of 'package:tum/Widgets/widgets.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const MyDrawerHeader(),
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                return const ListTile();
              }),
            ),
          )
        ],
      ),
    ));
  }
}
