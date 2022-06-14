part of 'package:tum/Widgets/widgets.dart';

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({Key? key}) : super(key: key);

 

 

  _updateData() async {
    print(userId());

    final ref = FirebaseDatabase.instance.ref();
    ref.child('Users/Students/${userId()}').onValue.listen((event) {
      print(event.snapshot.value);
    });

    final snapshot = await ref.child('Users/Students/${userId()}').get();
    if (snapshot.exists) {
      print(snapshot.child('fullName').value);
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateData();
    final themeProvider = Provider.of<ThemeProvider>(context);
    return DrawerHeader(
        decoration: BoxDecoration(
            color: themeProvider.isDarkMode
                ? Colorz.appBarColorDark
                : Colorz.primaryGreen),
        child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance
                .ref('Users/Students/${userId()}')
                .onValue,
            builder: (context, snapshot) {
              debugPrint(snapshot.toString());
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data!.snapshot;
                return Center(child: Txt(text: data.toString()));
              } else {
                return _indicator();
              }
            }));
  }

  Widget _indicator() {
    return Center(
      child: circularProgressIndicator(
          indicatorColor: Colors.white, scale: 0.9, width: 40),
    );
  }
}
