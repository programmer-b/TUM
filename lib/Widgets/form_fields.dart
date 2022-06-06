part of 'package:tum/Widgets/widgets.dart';

class FieldForm {
  emailField(TextEditingController email, FirebaseAuthProvider provider,
      {dynamic Function(String)? onChanged}) {
    return MyTextField(
        validator: (value) {
          if (provider.dataError && provider.emailError != '') {
            return provider.emailError;
          }
          return null;
        },
        onChanged: onChanged,
        controller: email,
        label: 'Your email address',
        hint: 'Email address',
        prefixIcon: Icons.email);
  }

  passwordField(BuildContext context, TextEditingController password,
      FirebaseAuthProvider provider, bool hidePassword,
      {Widget? suffixIcon,
      dynamic Function(String)? onChanged,
      String? confirmPassword,
      bool confirm = false}) {
    return MyTextField(
      validator: (value) {
        if (confirm) {
          if (value != confirmPassword) {
            return 'Password does not match';
          }
        }
        if (provider.dataError && provider.passwordError != '') {
          return provider.passwordError;
        }
        return null;
      },
      onChanged: onChanged,
      obscureText: hidePassword,
      controller: password,
      autoCorrect: false,
      isPassword: hidePassword,
      label: confirm ? 'Confirm password' : 'Password',
      hint: confirm ? 'Confirm password' : 'Password',
      prefixIcon: Icons.lock,
      suffixIcon: suffixIcon,
    );
  }
}
