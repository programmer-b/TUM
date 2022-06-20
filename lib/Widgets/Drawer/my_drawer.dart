part of 'package:tum/Widgets/widgets.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.67,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: const <Widget>[MyDrawerHeader()],
          ),
        ),
      ),
    );
  }
}
