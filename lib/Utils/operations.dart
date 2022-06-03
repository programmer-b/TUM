part of 'package:tum/Utils/utils.dart';

class Operations {
  int countWords(String string) {
    final RegExp regExp = RegExp(r"[\w-._]+");
    final Iterable matches = regExp.allMatches(string);
    return matches.length;
  }

  bool isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNo);
  }

  int letterOccurrence({required String string, required String letter}) {
    final regExp = RegExp(letter);
    return regExp.allMatches(string).length;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  bool validRegistrationNumber({required String val}) {
    if (letterOccurrence(string: val.toLowerCase(), letter: '/') == 2 &&
        val.length > 10 &&
        isNumeric(val.lastChars(4))) {
      return true;
    }
    return false;
  }
}
