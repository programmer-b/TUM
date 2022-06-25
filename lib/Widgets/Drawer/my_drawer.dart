part of 'package:tum/Widgets/widgets.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    context.read<FirebaseHelper>().readMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context).apps;
    final updateIndex = Provider.of<TUMState>(context);
    return Drawer(
        child: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const MyDrawerHeader(),
          Flexible(
            child: ListView.builder(
              itemCount: (provider.length / 2).ceil(),
              itemBuilder: (_, index) {
                log(provider[0]['name']);
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0;
                          i < 2 && index * 2 + i < provider.length;
                          i++)
                        ApplicationButton(
                            selected:
                                updateIndex.currentScreen == index * 2 + i,
                            icon: getIconUsingPrefix(
                                name: provider[index * 2 + i]['icon']),
                            text: provider[index * 2 + i]['name'],
                            onTap: () =>
                                updateIndex.updateIndex(index * 2 + i)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

 // Expanded(
          //   child: ListView.builder(
          //     itemBuilder: ((context, index) {
          //       return const ListTile();
          //     }),
          //   ),
          // )