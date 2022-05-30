part of 'package:tum/Utils/utils.dart';

class Messenger{
  void showSnackBar(BuildContext context, String message, {Duration duration = const Duration(seconds: 3),}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
        label: 'OK',
        onPressed: (){},
      ),
    ));
  }

  void showToast(String message){
    Fluttertoast.showToast(
        msg: message,  // message
        toastLength: Toast.LENGTH_LONG, // length
        gravity: ToastGravity.BOTTOM,    // location
        timeInSecForIosWeb: 2             // duration
    );

  }
}