part of 'package:tum/UI/home/home.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<String> urlImages = [];

  @override
  void initState() {
    super.initState();
    init();
    // getWebSiteData();
  }

  void init() {
    context.read<FirebaseHelper>().read();
    context.read<FirebaseHelper>().readMenu();
    context.read<API>().getContent(Urls.tumHome);
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

  List<String?> urls = [];

  Applications applications = Applications();
  EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    if (provider.root != null) {
      urls = operations.getImagesFromClass(
          provider.root!.snapshot.child('Home/Content/').value.toString());
    }
    int imageCount = urls.length;

    // log(provider.root?.snapshot.child('Home/Content/').value.toString() ??
    //     "null");
    final apps = Provider.of<FirebaseHelper>(context).apps;
    return provider.home == null || provider.root == null
        ? scaffoldIndicator()
        : Scaffold(
            appBar: _appBar(context),
            drawer: const MyDrawer(),
            body: Column(
              children: [
                buildCarousel(urls, imageCount),
                Dimens.titleBodyGap(scale: 0.6),
                quickAccess(apps),
                Dimens.defaultMargin(scale: 0.6),
                title(text: 'notice board'),
              ],
            ));
  }

  Widget title({String? text}) {
    return Container(
      padding: padding,
      width: double.infinity,
      child: Txt(
        text: text,
        fullUpperCase: true,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget buildCarousel(List<String?> urls, int itemCount) {
    return CarouselSlider.builder(
      options: CarouselOptions(
          height: 200,
          autoPlay: true,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 10)),
      itemCount: itemCount,
      itemBuilder: (context, index, realIndex) {
        final urlImage = urls[index];
        return buildImage(urlImage!, index);
      },
    );
  }

  Widget buildImage(String urlImage, int index) {
    final url = Urls.tumHome + urlImage;
    return Container(
        color: Colors.grey,
        child: CachedNetworkImage(
          key: UniqueKey(),
          width: double.infinity,
          fit: BoxFit.cover,
          imageUrl: url,
        ));
  }

  Widget quickAccess(List<dynamic> apps) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return ApplicationIconButton(
              icon: getIconUsingPrefix(name: apps[index]['icon']),
              name: apps[index]['name'],
              onTap: () {},
            );
          },
          itemCount: apps.length),
    );
  }
}
