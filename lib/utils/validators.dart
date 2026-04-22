import 'package:kido/utils/password_rules.dart';

class Validators {
  static final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // static final passwordRegex = RegExp(
  //   r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$',
  // );
  final nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  // static bool isValid(String password) {
  //   return passwordRegex.hasMatch(password);
  // }

  static int getPasswordStrength(String password) {
    int c = 0;

    if (password.length >= 8) c++;
    if (RegExp(r'[A-Z]').hasMatch(password)) c++;
    if (RegExp(r'[0-9]').hasMatch(password)) c++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) c++;

    return c;
  }

  //final phoneRegex=RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$');

  static String? validateEmail(String? email) {
    final trimmedEmail = email?.trim();

    if (trimmedEmail == null || trimmedEmail.isEmpty) {
      return "Please enter your email!";
    }

    if (!emailRegex.hasMatch(trimmedEmail)) {
      return "Please enter a valid email";
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter your password!";
    }

    if (!PasswordPolicy.isValid(password)) {
      return "Password does not meet requirements";
    }
    return null;
  }

  static String? validateLoginPassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter your password!";
    }
    return null;
  }

  static String? validateName(String? name) {
    final trimmed = name?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return "Please enter your full name!";
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
      return "Please do not enter special characters";
    }

    if (trimmed.length < 2) {
      return "Name is too short";
    }

    return null;
  }

  static String? validateUsername(String? username) {
    final trimmed = username?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return "Please enter a username!";
    }
    if (trimmed.length < 3) {
      return "Username must be at least 3 characters";
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      return "Username can only contain letters, numbers, and underscore";
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    final trimmed = phone?.trim();
    final phoneRegex = RegExp(
      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
    );

    if (trimmed == null || trimmed.isEmpty) {
      return "Please enter your phone number!";
    }
    if (!phoneRegex.hasMatch(trimmed)) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter the child's age!";
    }
    final age = int.tryParse(value);
    if (age == null || age <= 0) {
      return "Please enter a valid age";
    }
    return null;
  }
}
