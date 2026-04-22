class PasswordRule {
  final String message;
  final bool Function(String) isValid;

  const PasswordRule({required this.message, required this.isValid});
}

class PasswordPolicy {
  static final List<PasswordRule> rules = [
    PasswordRule(
      message: "At least 8 characters",
      isValid: (pass) => pass.length >= 8,
    ),
    PasswordRule(
      message: "At least one uppercase letter",
      isValid: (pass) => RegExp(r'[A-Z]').hasMatch(pass),
    ),
    PasswordRule(
      message: "At least one lowercase letter",
      isValid: (pass) => RegExp(r'[a-z]').hasMatch(pass),
    ),
    PasswordRule(
      message: "At least one number",
      isValid: (pass) => RegExp(r'[0-9]').hasMatch(pass),
    ),
    PasswordRule(
      message: "At least one special character",
      isValid: (pass) => RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pass),
    ),
  ];

  static bool isValid(String password) {
    return rules.every((rule) => rule.isValid(password));
  }

  static List<PasswordRule> unmetRules(String password) {
    return rules.where((r) => !r.isValid(password)).toList();
  }
}
