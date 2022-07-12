part of 'package:tum/UI/home/home.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<String> urlImages = [];
  List<NoticeBoardData> noticeBoardData = [];

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
  Applications applications = Applications();

  EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 20);

  final API api = API();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirebaseHelper>(context);
    if (provider.root != null) {
      urls = operations.getImagesFromClass(
          provider.root!.snapshot.child('Home/Content/').value.toString());
      noticeBoard = provider.root!.snapshot
          .child('NoticeBoard/Page_1/Content')
          .value
          .toString();
    }
    int imageCount = urls.length;
    dom.Document noticeBoardHtml = dom.Document.html(noticeBoard);

    final noticeMessages = noticeBoardHtml
        .querySelectorAll('.table > tbody:nth-child(2) > tr > td:nth-child(1)')
        .map((element) => element.innerHtml.trim())
        .toList();

    final noticeDates = noticeBoardHtml
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

    log(noticeUrls.toString() + '\n');

    setState(() => noticeBoardData = List.generate(
        noticeMessages.length,
        (index) => NoticeBoardData(
              date: noticeDates[index],
              notice: noticeMessages[index],
              url: noticeUrls[index],
            )));
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
                    homeNoticeBoard(context)
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

  Widget homeNoticeBoard(context) {
    bool noticeIsExpanded = true;
    final themeProvider = Provider.of<ThemeProvider>(context);
    Widget noticeChild(int i) {
      void onTap(context) {
        openPDF(context, noticeBoardData[i].url!, noticeBoardData[i].notice!);
      }

      ;
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
              for (int i = 0; i < noticeBoardData.length; i++) noticeChild(i)
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

  void openPDF(context, String url, String title) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PDFScreen(url: url, title: title)));
}
