part of 'package:tum/tum.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    this.isPassword = false,
    this.enableSuggestions = false,
    this.validator,
    this.onSaved,
    this.hint,
    this.label,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.autoCorrect = true,
    this.obscureText = false,
    this.controller,
    this.onChanged,
  }) : super(key: key);
  final bool isPassword;
  final bool enableSuggestions;
  final bool autoCorrect;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final String? hint;
  final String? label;
  final Color? fillColor;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextFormField(
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        enableSuggestions: enableSuggestions,
        autocorrect: autoCorrect,
        validator: validator,
        onSaved: onSaved,
        controller: controller,
        obscureText: obscureText,
        cursorColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
        decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            prefixIcon: Icon(prefixIcon,
                color:
                    themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
            label: Txt(text: label),
            focusColor: Colorz.primaryGreen,
            border: const OutlineInputBorder(borderSide: BorderSide(width: 2)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.green)),
            fillColor: fillColor,
            hintStyle: TextStyle(
                color:
                    themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
            labelStyle: TextStyle(
                color: themeProvider.isDarkMode
                    ? Colors.white70
                    : Colors.black54)));
  }
}
