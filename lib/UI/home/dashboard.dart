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
    context.read<API>().getContent('https://www.tum.ac.ke/');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    return provider.event == null
        ? scaffoldIndicator()
        : Scaffold(
            appBar: _appBar(context),
            drawer: const MyDrawer(),
            body: const Center());
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return appBar(context,
        actions: [
          MyIconButton(
            icon: Icons.search,
            onPressed: () {},
            toolTip: "Search",
          ),
          MyIconButton(
            icon: Icons.notifications_outlined,
            onPressed: () {},
            toolTip: "Notifications",
          ),
          MyIconButton(
            icon: Icons.more_vert,
            onPressed: () {},
            toolTip: "More options",
          )
        ],
        title: const Txt(text: "Home"));
  }

  List<String?> getImagesFromClass(String className, String body) {
    List<String?> urls = [];
    dom.Document document = parse(body);
    List<dom.Element> tables = document.getElementsByClassName(className);
    tables.map((e) {
      int length = e.getElementsByTagName("img").length;
      for (int i = 0; i < length; i++) {
        urls.insert(i, e.getElementsByTagName("img")[i].attributes['src']);
      }
    }).toList();
    return urls;
  }
}
