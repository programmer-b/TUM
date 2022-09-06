import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:tum/Utils/utils.dart';
import 'package:tum/provider/provider.dart';
import '../../Widgets/widgets.dart';

CounterStorage storage = CounterStorage();

final API api = API();
final TUMState tumState = TUMState();

class PDFScreen extends StatefulWidget {
  const PDFScreen(
      {Key? key, required this.url, this.title, this.requireDownload = false})
      : super(key: key);
  final String url;
  final String? title;
  final bool requireDownload;
  @override
  // ignore: library_private_types_in_public_api
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  Future<File> pdfFile(context, String url) async {
    String name = pdfFileName(url);
    final bool pdfDownloaded = await storage.directoryExists(name);

    if (pdfDownloaded && !widget.requireDownload) {
      return storage.localFile(name);
    } else {
      log('downloading pdf file $name');
      final file = await api.loadNetwork(url);
      return file;
    }
  }

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  late Future<File> file;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId,
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
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

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _createInterstitialAd();
    file = pdfFile(context, widget.url);
    context.read<TUMState>().pdfInit();
  }

  void init(BuildContext context) {
    Provider.of<TUMState>(context, listen: false).pdfInit();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TUMState>(context);
    final api = Provider.of<API>(context);
    PDFViewController? controller = provider.controller;
    int? pages = provider.pages;
    int? indexPage = provider.indexPage;

    final text = '${indexPage + 1} of $pages';

    return Scaffold(
        bottomNavigationBar: _bannerAd == null
            ? null
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _bannerAd!)),
        appBar: AppBar(
          title: Txt(
            text: widget.title ?? 'NOTICE',
            upperCaseFirst: true,
          ),
          actions: pages >= 2
              ? [
                  Center(child: Txt(text: text)),
                  MyIconButton(
                    icon: Icons.chevron_left,
                    iconSize: 32,
                    onPressed: () {
                      final page = indexPage == 0 ? pages : indexPage - 1;
                      controller!.setPage(page);
                    },
                  ),
                  MyIconButton(
                    icon: Icons.chevron_right,
                    iconSize: 32,
                    onPressed: () {
                      final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                      controller!.setPage(page);
                    },
                  )
                ]
              : null,
        ),
        body: Stack(
          children: [
            FutureBuilder<File>(
                future: file,
                builder: (_, AsyncSnapshot<File> snaphot) {
                  if (snaphot.connectionState == ConnectionState.done &&
                      snaphot.hasData) {
                    return PDFView(
                      filePath: snaphot.data!.path,
                      pageSnap: false,
                      enableSwipe: true,
                      // swipeHorizontal: true,
                      defaultPage: currentPage!,
                      preventLinkNavigation:
                          false, // if set to true the link is handled in flutter
                      onRender: (pages) => provider.pagesFunc(pages ?? 0),
                      onError: (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                        log(error.toString());
                      },
                      onPageError: (page, error) {
                        setState(() {
                          errorMessage = '$page: ${error.toString()}';
                        });
                        log('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) =>
                          provider.controllerFunc(pdfViewController),
                      onLinkHandler: (String? uri) {
                        log('goto uri: $uri');
                      },
                      onPageChanged: (int? page, int? total) {
                        provider.indexPageFunc(page ?? 0);
                      },
                    );
                  }
                  return const Center(child: null);
                }),
            errorMessage.isEmpty
                ? !provider.pdfReady
                    ? const Center(
                        child: MyProgressIndicator(),
                      )
                    : Container()
                : TUMBrowser(
                    title: widget.title ?? 'NOTICE',
                    url: widget.url,
                  )
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'Download',
              tooltip: 'Download',
              onPressed: () async {
                api.init();
                await api.download(widget.url, widget.title ?? 'NOTICE');
                _showInterstitialAd();
                if (api.hasError && mounted) {
                  messenger.showSnackBar(context, 'something went wrong');
                }
                // var dir = await getExternalStorageDirectory();
                // if (mounted) {
                //   final currentFile = await pdfFile(context, widget.url);
                //   if (await requestPermission(Permission.storage)) {
                //     storage.moveFile(currentFile, dir!.path);
                //   }
                // }
                // await FlutterDownloader.enqueue(
                //   url: widget.url,
                //   fileName: widget.title,
                //   saveInPublicStorage: true,
                //   savedDir: (await getExternalStorageDirectory())!.path,
                //   showNotification:
                //       true, // show download progress in status bar (for Android)
                //   openFileFromNotification:
                //       true, // click on notification to open downloaded file (for Android)
                // );
              },
              child: api.downloading
                  ? Txt(
                      text: api.progress,
                    )
                  : const Icon(Icons.download),
            ),
            const SizedBox(height: 13),
            FloatingActionButton(
              heroTag: 'Share',
              tooltip: 'Share',
              onPressed: () async {
                await FlutterShare.share(title: 'PDF link', text: widget.url);
              },
              child: const Icon(Icons.share),
            ),
          ],
        ));
  }
}
