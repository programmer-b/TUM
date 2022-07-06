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

  static String getFirstWord(String inputString) {
    List<String> wordList = inputString.split(" ");
    if (wordList.isNotEmpty) {
      return wordList[0];
    } else {
      return ' ';
    }
  }

  static String getLastWord(String inputString) {
    List<String> wordList = inputString.split(' ');
    if (wordList.isNotEmpty) {
      log(wordList.toString() + " " + wordList.length.toString());
      return wordList.last;
    } else {
      return ' ';
    }
  }

  static String firstAndLastName(String inputString) {
    inputString = getWithoutSpaces(inputString);
    log('Input String : $inputString');
    return getFirstWord(inputString) + ' ' + getLastWord(inputString);
  }

  static String getWithoutSpaces(String s) {
    String tmp = s.substring(0, s.length - 0);
    while (tmp.startsWith(' ')) {
      tmp = tmp.substring(1);
    }
    while (tmp.endsWith(' ')) {
      tmp = tmp.substring(0, tmp.length -1);
    }

    return tmp;
  }

  List<String?> getImagesFromClass(String body) {
    List<String?> urls = [];
    dom.Document document = parse(body);
    log('$document');
    List<dom.Element> imageUrls = document.getElementsByClassName("hide");
    imageUrls.map((element) {
      int length = element.getElementsByTagName("img").length;
      for (int i = 0; i < length; i++) {
        urls.insert(i, element.getElementsByTagName("img")[i].attributes['src']);
      }
    }).toList();
    return urls;
  }
}
