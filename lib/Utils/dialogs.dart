part of 'package:tum/Utils/utils.dart';

class PageDialog {
  static Future yesOrNoDialog(BuildContext context, String title, String body,
      {final Function()? onPressed}) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text(
                'Ok',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : 'Cancel';
  }

  void progress(BuildContext context, String title, String subTitle,
      {bool dismissable = false}) {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      barrierDismissible: dismissable,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ListTile(
            leading: const MyProgressIndicator(),
            title: Txt(
              text: title,
            ),
            subtitle: Txt(
              text: subTitle,
            ),
          ),
        );
      },
    );
  }

  void alert(BuildContext context, var message, {ArtSweetAlertType? type}) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: type ?? ArtSweetAlertType.info,
          title: message,
        ));
  }

  Future<void> showMyDialog(context,
      {String? title,
      String? message1,
      String? message2,
      String? positiveAction,
      String? negativeAction,
      dynamic Function()? onPressed}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Txt(text: title),
          content: Txt(
            text: message1 ?? '',
          ),
          actions: <Widget>[
            TxtButton(
                textColor: Colorz.primaryGreen,
                text: positiveAction!,
                onPressed: onPressed),
          ],
        );
      },
    );
  }
}
