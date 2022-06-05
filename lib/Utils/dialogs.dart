part of 'package:tum/Utils/utils.dart';

class PageDialog {
  void progress(BuildContext context, String title, String subTitle) {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ListTile(
            leading: const CircularProgressIndicator(),
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
}
