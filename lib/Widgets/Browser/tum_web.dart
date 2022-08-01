part of 'package:tum/Widgets/widgets.dart';

class TUMBrowser extends StatelessWidget {
  const TUMBrowser({Key? key, required this.url, required this.title})
      : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TUMState>(context);

    if (provider.sslError) {}

    return Column(
      children: [
        Visibility(
          visible: provider.browserIsLoading,
          child: Container(
              child: provider.progress < 1.0
                  ? LinearProgressIndicator(
                      value: provider.progress, color: Colors.white)
                  : Container()),
        ),
        Expanded(
          child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(url)),
              onWebViewCreated: (InAppWebViewController controller) {
                provider.setBrowserController(controller);
              },
              onLoadStart: (_, url) {
                log('load started $url');
                provider.onPageStarted();
              },
              onLoadStop: (controller, url) {
                log('load stoped $url');
                provider.onPageFinished();

                
              },
              onReceivedServerTrustAuthRequest: (_, challenge) async {
                // log('$challenge');
                await Future.delayed(Duration.zero, () async {
                  await dialog.showMyDialog(context,
                      title: "TUM $title portal",
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
