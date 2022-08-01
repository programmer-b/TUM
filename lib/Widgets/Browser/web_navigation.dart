part of 'package:tum/Widgets/widgets.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TUMState>(context);
    bool webViewReady = provider.webViewController != null;
    final controller = provider.webViewController;

    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: !webViewReady
              ? null
              : () async {
                  if (await controller!.canGoBack()) {
                    await controller.goBack();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No back history item')),
                    );
                    return;
                  }
                },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, ),
          onPressed: !webViewReady
              ? null
              : () async {
                  if (await controller!.canGoForward()) {
                    await controller.goForward();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No forward history item')),
                    );
                    return;
                  }
                },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: !webViewReady
              ? null
              : () {
                  controller!.reload();
                },
        ),
      ],
    );
  }
}