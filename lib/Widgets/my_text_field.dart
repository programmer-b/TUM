part of 'package:tum/Widgets/widgets.dart';

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
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.initialText,
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
  final TextCapitalization textCapitalization;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final String? initialText;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextFormField(
        initialValue: initialText,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        enableSuggestions: enableSuggestions,
        autocorrect: autoCorrect,
        validator: validator,
        onSaved: onSaved,
        controller: controller,
        obscureText: obscureText,
        cursorColor: themeProvider.isPreDarkMode ? Colors.white : Colors.black,
        decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            prefixIcon: Icon(prefixIcon,
                color:
                    themeProvider.isPreDarkMode ? Colors.white70 : Colors.black54),
            label: Txt(text: label),
            focusColor: Colorz.primaryGreen,
            border: const OutlineInputBorder(borderSide: BorderSide(width: 2)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.green)),
            fillColor: fillColor,
            hintStyle: TextStyle(
                color:
                    themeProvider.isPreDarkMode ? Colors.white70 : Colors.black54),
            labelStyle: TextStyle(
                color: themeProvider.isPreDarkMode
                    ? Colors.white70
                    : Colors.black54)));
  }
}
