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

  @override
  void initState() {
    super.initState();
    init();
    // getWebSiteData();
  }

  void init() async {
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
  String noticeBoard = '';
  String news = '';
  Applications applications = Applications();

  EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 20);

  final API api = API();

  int notifications = 3;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);

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
    }
    int imageCount = urls.length;

    dom.Document noticeBoardHtml = _dataHtml(noticeBoard);
    dom.Document newsHtml = _dataHtml(news);

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

    log('News; $newsMessages \n image: $newsImages \n date: $newsDate \n link: $newsLink');

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
                    quickAccess(apps),
                    Dimens.defaultMargin(scale: 0.6),
                    //title(text: 'notice board'),
                    //Dimens.defaultMargin(scale: 0.6),
                    homeNoticeBoard(context), homeNewsBoard(context)
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

  // Color titleColor(bool expanded) {
  //   var color = Colorz.primaryGreen;
  //   if (!expanded) {
  //     color = Colors.black54;
  //   }
  //   if (context.read<ThemeProvider>().isDarkMode) {
  //     color = Colors.white;
  //   }

  //   return color;
  // }

  // Widget homeNews(){

  // }

  Widget homeNewsBoard(context) {
    bool newsIsExpanded = true;
    final themeProvider = Provider.of<ThemeProvider>(context);
    Widget newsChild(int i) {
      void onTap(context) {
        openNews(context, newsData[i].url!, newsData[i].news!, newsData[i].image!);
      }

      return Column(
        children: [
          ListTile(
            dense: true,
            onTap: () async => onTap(context),
            leading: Txt(text: i + 1),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildNewsImage(newsData[i].image!),
                  const SizedBox(
                    height: 6,
                  ),
                  Txt(
                    text: newsData[i].news,
                    upperCaseFirst: true,
                    textAlign: TextAlign.start,
                    color: themeProvider.isDarkMode ? null : Colors.black,
                  ),
                ],
              ),
            ),
            horizontalTitleGap: 0,
            subtitle: Txt(
              text: newsData[i].date,
              textAlign: TextAlign.start,
              fullUpperCase: true,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right),
              color: themeProvider.isDarkMode ? Colors.white70 : null,
              onPressed: () async => onTap(context),
            ),
          ),
          const Divider()
        ],
      );
    }

    // log('expanded: $noticeIsExpanded');
    return Container(
      padding: padding,
      child: ListTileTheme(
        dense: true,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: const Color.fromRGBO(196, 196, 196, 0.6),
            unselectedWidgetColor: themeProvider.isDarkMode
                ? Colors.white
                : Colors.black54, // here for close state
            colorScheme: ColorScheme.light(
              primary:
                  themeProvider.isDarkMode ? Colors.white : Colorz.primaryGreen,
            ),
          ), //
          child: ExpansionTile(
            initiallyExpanded: newsIsExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                log('expanded: $expanded');
                newsIsExpanded = expanded;
                log('noticeIsExapanded:  $newsIsExpanded');
              });
            },
            title: const Txt(
              text: ' tum news',
              fullUpperCase: true,
            ),
            children: [
              for (int i = 0; i < newsData.length; i++) newsChild(i),
              TxtButton(
                text: 'read more',
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                onPressed: () =>
                    setState(() => notifications == noticeBoardData.length),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNewsImage(String url) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: CachedNetworkImage(
        placeholder: (_, __) {
          return const ShimmerWidget.circular(
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: double.infinity,
              height: 100);
        },
        width: double.infinity,
        height: 100,
        key: UniqueKey(),
        fit: BoxFit.cover,
        imageUrl: url,
      ),
    );
  }

  Widget homeNoticeBoard(context) {
    bool noticeIsExpanded = true;
    final themeProvider = Provider.of<ThemeProvider>(context);
    Widget noticeChild(int i) {
      void onTap(context) {
        openPDF(context, noticeBoardData[i].url!, noticeBoardData[i].notice!);
      }

      return Column(
        children: [
          ListTile(
            dense: true,
            onTap: () async => onTap(context),
            leading: Txt(text: i + 1),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Txt(
                text: noticeBoardData[i].notice,
                upperCaseFirst: true,
                textAlign: TextAlign.start,
                color: themeProvider.isDarkMode ? null : Colors.black,
              ),
            ),
            horizontalTitleGap: 0,
            subtitle: Txt(
              text: noticeBoardData[i].date,
              textAlign: TextAlign.start,
              fullUpperCase: true,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right),
              color: themeProvider.isDarkMode ? Colors.white70 : null,
              onPressed: () async => onTap(context),
            ),
          ),
          const Divider()
        ],
      );
    }

    // log('expanded: $noticeIsExpanded');
    return Container(
      padding: padding,
      child: ListTileTheme(
        dense: true,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: const Color.fromRGBO(196, 196, 196, 0.6),
            unselectedWidgetColor: themeProvider.isDarkMode
                ? Colors.white
                : Colors.black54, // here for close state
            colorScheme: ColorScheme.light(
              primary:
                  themeProvider.isDarkMode ? Colors.white : Colorz.primaryGreen,
            ),
          ), //
          child: ExpansionTile(
            initiallyExpanded: noticeIsExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                log('expanded: $expanded');
                noticeIsExpanded = expanded;
                log('noticeIsExapanded:  $noticeIsExpanded');
              });
            },
            title: const Txt(
              text: 'notice board',
              fullUpperCase: true,
            ),
            children: [
              for (int i = 0; i < notifications; i++) noticeChild(i),
              TxtButton(
                text: 'read more',
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                onPressed: () =>
                    setState(() => notifications == noticeBoardData.length),
              )
            ],
          ),
        ),
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
          placeholder: (_, __) {
          return const ShimmerWidget.rectangular(
              
              width: double.infinity,
              height: 200);
        },
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

  void openPDF(context, String url, String title,) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PDFScreen(url: url, title: title)));

          void openNews(context, String url, String title, String image) =>  Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewsPage(url: url, title: title,image: image)));
}
