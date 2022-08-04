part of 'package:tum/Widgets/widgets.dart';

class TUMBrowser extends StatelessWidget {
  const TUMBrowser({Key? key, required this.url, required this.title})
      : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TUMState>(context);

    //Future.delayed(Duration.zero, () => provider.browserInit());

    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
            useOnDownloadStart: true),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ));

    final internet = InternetChecker();

    

    return provider.loadingError
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Txt(
                    text: 'Internet Error',
                    fontWeight: FontWeight.bold,
                    fontSize: 44),
                const SizedBox(height: 10),
                MyButton(
                  text: 'Retry',
                  width: 70,
                  onPressed: () => provider.webViewController != null
                      ? provider.webViewController!.reload()
                      : null,
                )
              ],
            ),
          )
        : Column(
            children: [
              if (title == 'Past papers')
                Visibility(
                  visible: provider.browserFinishedLoading,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    child: BrowserSearchBar(url: url),
                  ),
                ),
              Visibility(
                visible: provider.browserIsLoading,
                child: LinearProgressIndicator(
                  minHeight: 5,
                  value: provider.progress,
                ),
              ),
              Expanded(
                child: InAppWebView(
                    initialOptions: options,
                    initialUrlRequest: URLRequest(url: Uri.parse(url)),
                    onWebViewCreated: (InAppWebViewController controller) {
                      debugPrint("web created");
                      provider.setBrowserController(controller);
                    },
                    onLoadStart: (_, url) {
                      //log('load started $url');
                      provider.onPageStarted();
                    },
                    onLoadError: (controller, url, code, message) {
                      debugPrint("error while loading $url: $message");
                      provider.onPageLoadError();
                      log("error");
                    },
                    onLoadHttpError:
                        (controller, url, statusCode, description) {
                      provider.onPageLoadError();
                      debugPrint(
                          "error while loading $url: $statusCode: $description");
                    },
                    onLoadStop: (controller, url) {
                      // log('load stoped $url');
                      provider.onPageFinished();
                    },
                    onDownloadStartRequest: (controller, url) async {
                      if (title == "Elearning") {
                        //messenger.showSnackBar(context, "Downloads not supported.");
                        await FlutterDownloader.enqueue(
                          url: "${url.url}",
                          fileName: url.suggestedFilename ?? "PDF file",
                          saveInPublicStorage: true,
                          savedDir: (await getExternalStorageDirectory())!.path,
                          showNotification:
                              true, // show download progress in status bar (for Android)
                          openFileFromNotification:
                              true, // click on notification to open downloaded file (for Android)
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (
                              _,
                            ) =>
                                    PDFScreen(
                                        requireDownload: true,
                                        url: url.url.toString(),
                                        title: url.suggestedFilename ??
                                            "PDF file")));
                      }
                      log("${url.url}");
                    },
                    onProgressChanged: (_, progress) =>
                        provider.onProgressChanged(progress),
                    onReceivedServerTrustAuthRequest: (_, challenge) async {
                      // log('$challenge');
                      await Future.delayed(Duration.zero, () async {
                        await dialog.showMyDialog(context,
                            title: "TUM $title",
                            message1: "Do you want to proceed?",
                            negativeAction: "cancel",
                            positiveAction: "proceed", onPressed: () {
                          provider.onReceivedSSLError(proceed: true);
                          Navigator.pop(context);
                          log('returning to proceed');
                        });
                      });

                      return ServerTrustAuthResponse(
                          action: provider.sslProceed
                              ? ServerTrustAuthResponseAction.PROCEED
                              : ServerTrustAuthResponseAction.CANCEL);
                    }),
              ),
            ],
          );
  }
}
