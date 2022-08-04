part of 'package:tum/UI/home/home.dart';

class PastPapers extends StatefulWidget {
  const PastPapers({Key? key}) : super(key: key);

  @override
  State<PastPapers> createState() => _PastPapersState();
}

class _PastPapersState extends State<PastPapers> {
  late String url;
  String _rootData(path) {
    return context
        .read<FirebaseHelper>()
        .root!
        .snapshot
        .child('$path')
        .value
        .toString();
  }

  @override
  void initState() {
    super.initState();
    url = _rootData('PastPapers/initialUrl');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await pushPage(context, const DashBoard());
      },
      child: Scaffold(
        appBar: browserAppBar(context, "Past papers"),
        drawer: const MyDrawer(),
        body: TUMBrowser(url: url, title: "Past papers"),
      ),
    );
  }

 
}
