part of 'package:tum/UI/home/home.dart';

enum TUMMenuItem { item1, item2, item3 }

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  List<String> urlImages = [];
  List<String> dashboardImagesData = [];
  List<NoticeBoardData> noticeBoardData = [];
  List<NewsData> newsData = [];
  List<DownloadsData> downloadsData = [];

  @override
  void initState() {
    super.initState();

    _createBannerAd();
    _createInterstitialAd();

    DailyNotificationsApi.init();
    DailyNotificationsApi.showScheduledNotification();
    listenNotifications();
    init();
    // getWebSiteData();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId,
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  Future<void> init() async {
    Future.delayed(Duration.zero, () {
      context.read<FirebaseHelper>().read();
      context.read<FirebaseHelper>().readMenu();
      context.read<API>().getContent(Urls.tumHome);
      context.read<TUMState>().updateScreenIndex(0);
    });

    await 120.seconds.delay;

    _showInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        log('$error');
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return appBar(context,
        actions: [
          MyIconButton(
            icon: Icons.search,
            onPressed: () =>
                showSearch(context: context, delegate: MySearchDelegate()),
            toolTip: "Search",
          ),
          MyIconButton(
            icon: Icons.notifications_outlined,
            onPressed: () => context
                .read<TUMState>()
                .navidateToScreen(context, '/notifications', 5),
            toolTip: "Notifications",
          ),
          PopupMenuButton<TUMMenuItem>(
              onSelected: (value) async {
                switch (value) {
                  case TUMMenuItem.item1:
                    const AccountSettings().launch(context,
                        pageRouteAnimation: PageRouteAnimation.Scale);
                    break;
                  case TUMMenuItem.item2:
                    context
                        .read<TUMState>()
                        .navidateToScreen(context, '/settings', 7);
                    break;
                  case TUMMenuItem.item3:
                    await PageDialog.yesOrNoDialog(context, 'Logout',
                        'Do you wish to logout this account?',
                        onPressed: () async {
                      if (!mounted) return;
                      Navigator.pop(context);

                      toast('Logged out successfully');

                      await context.read<FirebaseAuthProvider>().logOut();
                      if (!mounted) return;
                      Phoenix.rebirth(context);
                    });
                    break;
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: TUMMenuItem.item1,
                      child: Txt(
                        text: 'Profile',
                      ),
                    ),
                    const PopupMenuItem(
                      value: TUMMenuItem.item2,
                      child: Txt(
                        text: 'Settings',
                      ),
                    ),
                    const PopupMenuItem(
                      value: TUMMenuItem.item3,
                      child: Txt(
                        text: 'Logout',
                      ),
                    )
                  ])
        ],
        title: const Txt(text: "Home"));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    // final tumStateProvider = Provider.of<TUMState>(context);

    String databaseWebContent(String path) {
      return provider.root!.snapshot.child(path).value.toString();
    }

    dom.Document dataHtml(String html) {
      return dom.Document.html(html);
    }

    if (provider.root != null) {
      urls = operations.getImagesFromClass(databaseWebContent('Home/Content'));
      dashboardImages = databaseWebContent('Home/Content');
      noticeBoard = databaseWebContent('NoticeBoard/Page_1/Content');
      news = databaseWebContent('News/Page_1/Content');
      downloads = databaseWebContent('Downloads/Page_1/Content');
    }
    int imageCount = urls.length;

    dom.Document dashboardHtml = dataHtml(dashboardImages);
    dom.Document noticeBoardHtml = dataHtml(noticeBoard);
    dom.Document newsHtml = dataHtml(news);
    dom.Document downloadsHtml = dataHtml(downloads);

    final dashBoardImagesUrl = dashboardHtml
        .querySelectorAll('li.tp-revslider-slidesli > div > div')
        .map((element) => element.innerHtml.trim())
        .toList();

    log(' images url : $dashBoardImagesUrl');

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
            bottomNavigationBar: _bannerAd == null
                ? null
                : Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 52,
                    child: AdWidget(ad: _bannerAd!)),
            appBar: _appBar(context),
            drawer: const MyDrawer(),
            body: RefreshIndicator(
              onRefresh: () async {
                await api.getContent(Urls.tumHome);
                log('getting content from urls: ${Urls.tumHome}');
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

  void listenNotifications() => DailyNotificationsApi.onNotifications.stream
      .listen(onClickedNotifications);

  void onClickedNotifications(String? json) {
    final obj = jsonDecode(json!);
    if (obj['isSuccess']) {
      // OpenFile.open(obj['filePath']);
    }
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query.isEmpty ? close(context, null) : query = '',
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return const Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [
      'Dashboard',
      'Eregister',
      'Elearning',
      'Past papers',
      'News',
      'Notifications',
      'Downloads',
      'Settings',
      'Eregister settings',
      'Elearning settings',
      'Profile',
      'Account settings'
    ];

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final provider = Provider.of<TUMState>(context);
          return ListTile(
            title: Txt(text: suggestion),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              query = suggestion;
              showResults(context);
              switch (index) {
                case 0:
                  provider.navidateToScreen(context, '/home', index);
                  break;
                case 1:
                  provider.navidateToScreen(context, '/eregister', index);
                  break;
                case 2:
                  provider.navidateToScreen(context, '/elearning', index);
                  break;
                case 3:
                  provider.navidateToScreen(context, '/pastpapers', index);
                  break;
                case 4:
                  provider.navidateToScreen(context, '/news', index);
                  break;
                case 5:
                  provider.navidateToScreen(context, '/notifications', index);
                  break;
                case 6:
                  provider.navidateToScreen(context, '/downloads', index);
                  break;
                case 7:
                  provider.navidateToScreen(context, '/settings', index);
                  break;
                case 8:
                  const EregisterSettings().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Scale);
                  break;
                case 9:
                  const ElearningSettings().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Scale);
                  break;
                case 10:
                  const AccountSettings().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Scale);
                  break;
                case 11:
                  const AccountSettings().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Scale);
                  break;
                default:
                  provider.navidateToScreen(context, '/home', index);
                  break;
              }
            },
          );
        });
  }
}
