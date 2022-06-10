part of 'package:tum/Constants/constants.dart';

class Dimens {
  static double profileIconSize = 40;
  static Widget titleBodyGap({double scale = 1.0}) {
    return SizedBox(
      height: 20 * scale,
    );
  }

  static Widget textFieldGap({double scale = 1.0}) {
    return SizedBox(
      height: 15 * scale,
    );
  }

  static Widget titleTextFieldGap({double scale = 1.0}) {
    return SizedBox(
      height: 20 * scale,
    );
  }

  static Widget textFieldButtonGap({double scale = 1.0}) {
    return SizedBox(
      height: 30 * scale,
    );
  }

  static Widget buttonButtonGap({double scale = 1.0}) {
    return SizedBox(
      height: 20 * scale,
    );
  }

  static Widget textToTextGap({double scale = 1.0}) {
    return SizedBox(
      height: 15 * scale,
    );
  }

  static Widget pushCentered({double scale = 1.0}) {
    return SizedBox(
      height: 50 * scale,
    );
  }

  static Widget progressToText({double scale = 1.0}) {
    return SizedBox(
      height: 10 * scale,
    );
  }
}
