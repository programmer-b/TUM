part of 'package:tum/Widgets/widgets.dart';

class BrowserSearchBar extends StatelessWidget {
  const BrowserSearchBar({Key? key, required this.url}) : super(key: key);
  final String url;
  

  @override
  Widget build(BuildContext context) {
    // final controller = TextEditingController();
    final provider = Provider.of<TUMState>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          width: MediaQuery.of(context).size.width * 2 / 3,
          child:  TextField(
            //controller: TextEditingController()..text = provider.currentSearchItem,
            onChanged: (text) => provider.searchItem(text),
            decoration: const InputDecoration(
                hintStyle: TextStyle(fontSize: 12),
                labelText: 'search for unit "name" or "code"',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.blue),
                )),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: themeProvider.isDarkMode ? Colors.white : Colorz.primaryGreen),
            onPressed: () => provider.webViewController != null
                ? provider.webViewController!
                    .loadUrl(urlRequest: URLRequest(url: Uri.parse("$url/discover?query=${provider.currentSearchItem.trim().replaceAll(' ', '+')}")))
                : null,
            child: const Txt(
              text: 'Search',
            ))
      ],
    );
  }
}
