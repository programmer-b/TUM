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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    if (provider.root != null) {
      urls = operations.getImagesFromClass(
          provider.root!.snapshot.child('Home/Content/').value.toString());
    }
    int itemCount = urls.length;
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
                buildCarousel(urls, itemCount),
                const SizedBox(
                  height: 12,
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   width: double.infinity,
                //   child: const Txt(
                //     text: 'apps',
                //     fullUpperCase: true,
                //     textAlign: TextAlign.start,
                //   ),
                // ),
                SizedBox(
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
                )
                //quickAccess(provider),
              ],
            ));
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

  Widget quickAccess(FirebaseHelper provider) {
    log(provider.root!.snapshot.child('Applications').value.toString());
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Expanded(
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              return const Center();
            },
            separatorBuilder: (_, __) {
              return const Center();
            },
            itemCount: 0),
      ),
    );
  }
}
