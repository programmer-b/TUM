import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:tum/UI/setup/setup.dart';
import 'package:tum/Utils/utils.dart';
import 'package:tum/provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../Widgets/widgets.dart';

CounterStorage storage = CounterStorage();

final API api = API();
final TUMState tumState = TUMState();

class PDFScreen extends StatefulWidget {
  const PDFScreen({Key? key, required this.url, required this.title})
      : super(key: key);
  final String url;
  final String title;
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  Future<File> pdfFile(context,String url) async {
    String name = pdfFileName(url);
    final bool pdfDownloaded = await storage.directoryExists(name);

    if (pdfDownloaded) {
      return storage.localFile(name);
    } else {
      messenger.showSnackBar(context, 'Downloading. Please wait...');
      final file = await api.loadNetwork(url);
      return file;
    }
  }

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  late Future<File> file;

  @override
  void initState() {
    super.initState();
    file = pdfFile(context,widget.url);
    context.read<TUMState>().pdfInit();
  }

  void init(BuildContext context) {
    Provider.of<TUMState>(context, listen: false).pdfInit();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TUMState>(context);
    PDFViewController? controller = provider.controller;
    int? pages = provider.pages;
    int? indexPage = provider.indexPage;

    final text = '${indexPage + 1} of $pages';

    return Scaffold(
        appBar: AppBar(
          title: Txt(
            text: widget.title,
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
                      onRender: (_pages) => provider.pagesFunc(_pages ?? 0),
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
                : Center(
                    child: Text(errorMessage),
                  )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Share',
          onPressed: () async {
            await Share.share(widget.url);
          },
          child: const Icon(Icons.share),
        ));
  }
}
