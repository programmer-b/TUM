part of 'package:tum/UI/home/home.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<String> urlImages = [];
  List<NoticeBoardData> noticeBoardData = [];
  List<NewsData> newsData = [];
  List<DownloadsData> downloadsData = [];

  @override
  void initState() {
    super.initState();
    init();
    // getWebSiteData();
  }

  void init() async {
    Future.delayed(Duration.zero, () {
      context.read<FirebaseHelper>().read();
      context.read<FirebaseHelper>().readMenu();
      context.read<API>().getContent(Urls.tumHome);
      context.read<TUMState>().updateScreenIndex(0);
    });
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    // final tumStateProvider = Provider.of<TUMState>(context);

    String _databaseWebContent(String path) {
      return provider.root!.snapshot.child(path).value.toString();
    }

    dom.Document _dataHtml(String html) {
      return dom.Document.html(html);
    }

    if (provider.root != null) {
      urls =
          operations.getImagesFromClass(_databaseWebContent('Home/Content/'));
      noticeBoard = _databaseWebContent('NoticeBoard/Page_1/Content');
      news = _databaseWebContent('News/Page_1/Content');
      downloads = _databaseWebContent('Downloads/Page_1/Content');
    }
    int imageCount = urls.length;

    dom.Document noticeBoardHtml = _dataHtml(noticeBoard);
    dom.Document newsHtml = _dataHtml(news);
    dom.Document downloadsHtml = _dataHtml(downloads);

    final downloadsTitle = downloadsHtml
        .querySelectorAll('.table > tbody > tr > td:nth-child(3)')
        .map((element) => element.innerHtml.trim())
        .toList();

    final downloadsUrl = downloadsHtml
        .querySelectorAll('.table > tbody > tr > td > a')
        .map((element) => 'https://www.tum.ac.ke${element.attributes['href']}')
        .toList();
    // log('downloadsTitle: $downloadsTitle \n downloadsUrl $downloadsUrl');

    final newsMessages = newsHtml
        .querySelectorAll('#w0 > div > div > h2 > a')
        .map((element) => element.innerHtml.trim())
        .toList();

    final newsImages = newsHtml
        .querySelectorAll('#w0 > div > div > figure > img')
        .map((element) => 'https://www.tum.ac.ke${element.attributes['src']}')
        .toList();

    final newsDate = newsHtml
        .querySelectorAll('#w0 > div > div > ul > li > a > span')
        .map((element) => element.innerHtml.trim())
        .toList();

    final newsLink = newsHtml
        .querySelectorAll('#w0 > div > div > h2 > a')
        .map((element) => 'https://www.tum.ac.ke${element.attributes['href']}')
        .toList();

    // log('News; $newsMessages \n image: $newsImages \n date: $newsDate \n link: $newsLink');

    final noticeMessages = noticeBoardHtml
        .querySelectorAll('.table > tbody:nth-child(2) > tr > td:nth-child(1)')
        .map((element) => element.innerHtml.trim())
        .toList();

    final noticeDate = noticeBoardHtml
        .querySelectorAll('.table > tbody:nth-child(2) > tr > td:nth-child(2)')
        .map((element) => element.innerHtml.trim())
        .toList();

    final noticeUrls = noticeBoardHtml
        .querySelectorAll(
            '.table > tbody:nth-child(2) > tr > td:nth-child(3) > a')
        .map((element) => 'https://www.tum.ac.ke${element.attributes['href']}')
        .toList();
    // log('length: ${noticeMessages.length}');
    // for (final notice in noticeMessages) {
    //   log('notice: $notice');
    // }

    setState(() {
      noticeBoardData = List.generate(
          noticeMessages.length,
          (index) => NoticeBoardData(
                date: noticeDate[index],
                notice: noticeMessages[index],
                url: noticeUrls[index],
              ));
      newsData = List.generate(
          newsMessages.length,
          (index) => NewsData(
                date: newsDate[index],
                news: newsMessages[index],
                url: newsLink[index],
                image: newsImages[index],
              ));

      downloadsData = List.generate(
          downloadsTitle.length,
          (index) => DownloadsData(
                title: downloadsTitle[index],
                url: downloadsUrl[index],
              ));
    });
    // log(provider.root?.snapshot.child('Home/Content/').value.toString() ??
    //     "null");
    final apps = Provider.of<FirebaseHelper>(context).apps;
    return provider.home == null || provider.root == null
        ? scaffoldIndicator()
        : Scaffold(
            appBar: _appBar(context),
            drawer: const MyDrawer(),
            body: RefreshIndicator(
              onRefresh: () async {
                await api.getContent(Urls.tumHome);
                log('getting content from urls: ' + Urls.tumHome);
              },
              child: ScrollableWidget(
                child: Column(
                  children: [
                    buildCarousel(urls, imageCount),
                    Dimens.titleBodyGap(scale: 0.6),
                    quickAccess(context, apps),
                    Dimens.defaultMargin(scale: 0.6),
                    //title(text: 'notice board'),
                    //Dimens.defaultMargin(scale: 0.6),
                    homeNoticeBoard(context,
                        noticeBoardData: noticeBoardData, length: 3),
                    homeNewsBoard(context, newsdata: newsData, length: 3),
                    homeDownloadsBoard(context,
                        downloadsData: downloadsData, length: 3),
                  ],
                ),
              ),
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
        return buildImage(Urls.tumHome + urlImage!);
      },
    );
  }

  Widget quickAccess(BuildContext context, List<dynamic> apps) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return index > 0
                ? ApplicationIconButton(
                    icon: getIconUsingPrefix(name: apps[index]['icon']),
                    name: apps[index]['name'],
                    onTap: () => context
                        .read<TUMState>()
                        .navidateToScreen(context, apps[index]['url'], index))
                : const Center();
          },
          itemCount: apps.length),
    );
  }
}
