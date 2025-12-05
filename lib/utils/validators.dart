class Validators {
  static final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$',
  );

  static bool isValid(String password) {
    return passwordRegex.hasMatch(password);
  }

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
    if (email == null || email.isEmpty) {
      return "Please enter your email!";
    }

    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email";
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter your password!";
    }

    if (!passwordRegex.hasMatch(password)) {
      return "Please enter a valid password";
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "Please enter your name!";
    }

    return null;
  }
}
