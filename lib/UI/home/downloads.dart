part of 'package:tum/UI/home/home.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  dom.Document downloadsHtml = _dataHtml(downloads);
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId,
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    final downloadsTitle = downloadsHtml
        .querySelectorAll('.table > tbody > tr > td:nth-child(3)')
        .map((element) => element.innerHtml.trim())
        .toList();

    final downloadsUrl = downloadsHtml
        .querySelectorAll('.table > tbody > tr > td > a')
        .map((element) => 'https://www.tum.ac.ke${element.attributes['href']}')
        .toList();

    setState(() {
      downloadsData = List.generate(
          downloadsTitle.length,
          (index) => DownloadsData(
                title: downloadsTitle[index],
                url: downloadsUrl[index],
              ));
    });
    return WillPopScope(
      onWillPop: () async {
        return await pushPage(context, const DashBoard());
      },
      child: Scaffold(
        bottomNavigationBar: _bannerAd == null
            ? null
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _bannerAd!)),
        appBar: _appBar(context),
        drawer: const MyDrawer(),
        body: ScrollableWidget(
                child: homeDownloadsBoard(context,
                    downloadsData: downloadsData,
                    length: downloadsData.length,
                    readmore: false))
            .paddingAll(16),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return appBar(context,
        // actions: [
        //   MyIconButton(
        //     icon: Icons.more_vert,
        //     onPressed: () {},
        //     toolTip: "More options",
        //   )
        // ],
        title: const Txt(text: "Downloads"));
  }
}
