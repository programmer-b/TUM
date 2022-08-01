part of 'package:tum/Utils/utils.dart';

class PageDialog {
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
              text: negativeAction!,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TxtButton(text: positiveAction!, onPressed: onPressed),
          ],
        );
      },
    );
  }
}
