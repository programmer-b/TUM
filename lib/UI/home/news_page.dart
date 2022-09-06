part of 'package:tum/UI/home/home.dart';

class NewsPage extends StatefulWidget {
  final String title;
  final String image;
  final String url;
  const NewsPage(
      {Key? key, required this.title, required this.image, required this.url})
      : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
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
    context.read<API>().init();
    context.read<API>().getHtml(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> newsPage = [
    //   buildImage(widget.image),
    //   Flexible(
    //     child: Consumer<API>(builder: (_, provider, __) {
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    //         child: provider.success ? Txt(text: 'hello') : skeletonContent(),
    //       );
    //     }),
    //   )
    // ];

    String newsHtml = '';

    return Consumer<API>(builder: (_, provider, __) {
      if (provider.success) {
        newsHtml = provider.htmlContent;
      }

      dom.Document newsData = _dataHtml(newsHtml);

      final newsMessages = newsData
          .querySelectorAll('#wrapper > section > div > div > div > p')
          .map((element) => element.innerHtml.trim())
          .toList();

      log('newsMessages: $newsMessages');
      return Scaffold(
        bottomNavigationBar: _bannerAd == null
            ? null
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _bannerAd!)),
        appBar: AppBar(
          title: Txt(
            text: widget.title,
            upperCaseFirst: true,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await api.getHtml(widget.url);
            log('getting content from urls: ');
          },
          child: ScrollableWidget(
            child: Column(children: <Widget>[
              buildImage(widget.image),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(8),
                child: provider.success
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Txt(
                            text: widget.title,
                            fullUpperCase: true,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          for (int i = 0; i < newsMessages.length; i++)
                            Column(
                              children: [
                                Txt(
                                  text: parse(newsMessages[i])
                                      .documentElement!
                                      .text,
                                ),
                                const SizedBox(height: 8)
                              ],
                            )
                        ],
                      )
                    : provider.hasError
                        ? const Txt(
                            text: 'Something went wrong',
                          )
                        : const Center(
                            child: MyProgressIndicator(),
                          ),
              )
            ]),
          ),
        ),
      );
    });
  }

  Widget skeletonContent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: const <Widget>[
              ShimmerWidget.rectangular(height: 17, width: 40),
              SizedBox(width: 13),
              ShimmerWidget.rectangular(height: 17, width: 40),
              SizedBox(width: 13),
              ShimmerWidget.rectangular(height: 17, width: 40),
            ],
          ),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(height: 17, width: 175),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(height: 17, width: 175),
          const SizedBox(height: 8),
          Row(
            children: const <Widget>[
              ShimmerWidget.rectangular(height: 17, width: 175),
              SizedBox(width: 13),
              ShimmerWidget.rectangular(height: 17, width: 125),
            ],
          ),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(height: 17, width: 175),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(height: 17, width: 175),
          const SizedBox(height: 8),
          const ShimmerWidget.rectangular(height: 17, width: 175),
          const SizedBox(height: 8),
          Row(
            children: const <Widget>[
              ShimmerWidget.rectangular(height: 17, width: 175),
              SizedBox(width: 13),
              ShimmerWidget.rectangular(height: 17, width: 125),
            ],
          ),
        ]);
  }
}
