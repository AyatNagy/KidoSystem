// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kido';

  @override
  String get playButton => 'Let\'s Play!';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get updateInfo => 'Update your personal info';

  @override
  String get languageTitle => 'Language';

  @override
  String get privacyTitle => 'Privacy & Security';

  @override
  String get privacySubtitle => 'Manage your data';

  @override
  String get logoutButton => 'LOG OUT';

  @override
  String get logoutDialogTitle => 'Sign Out';

  @override
  String get logoutDialogContent =>
      'Are you sure you want to exit the Kido app? Everything will be safely waiting for your return!';

  @override
  String get stayButton => 'Stay';

  @override
  String get logoutConfirm => 'Logout';

  @override
  String get viewPhoto => 'View Current Photo';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseGallery => 'Choose from gallery';
}
