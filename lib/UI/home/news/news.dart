part of 'package:tum/UI/home/home.dart';

class News extends StatefulWidget {
  const News({Key? key, this.initialIndex}) : super(key: key);
  final int? initialIndex;

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  late TabController controller;

  BannerAd? _bannerAd;

  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId,
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  @override
  void initState() {
    _createBannerAd();
    init();
    super.initState();
  }

  void init() async {
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  dom.Document noticeBoardHtml = _dataHtml(noticeBoard);
  dom.Document newsHtml = _dataHtml(news);

  @override
  Widget build(BuildContext context) {
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
    });
    log("index: ${widget.initialIndex}");
    return WillPopScope(
      onWillPop: () async {
        return await pushPage(context, const DashBoard());
      },
      child: DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          bottomNavigationBar: _bannerAd == null
              ? null
              : Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: 52,
                  child: AdWidget(ad: _bannerAd!)),
          appBar: _appBar(context),
          drawer: const MyDrawer(),
          body: TabBarView(
              controller: controller,
              children: const <Widget>[NoticeBoard(), NewsContent()]),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return appBar(context,
        bottom: TabBar(
          controller: controller,
          tabs: const [
            Tab(text: 'NOTICE BOARD'),
            Tab(
              text: 'NEWS',
            )
          ],
        ),
        // actions: [
        //   MyIconButton(
        //     icon: Icons.more_vert,
        //     onPressed: () {},
        //     toolTip: "More options",
        //   )
        // ],
        title: const Txt(text: "News"));
  }
}
