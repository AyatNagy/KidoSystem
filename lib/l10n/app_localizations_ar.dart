// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كيدو';

  @override
  String get playButton => 'هيا نلعب!';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get updateInfo => 'تحديث معلوماتك الشخصية';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get privacyTitle => 'الخصوصية والأمان';

  @override
  String get privacySubtitle => 'إدارة بياناتك الشخصية';

  @override
  String get logoutButton => 'تسجيل الخروج';

  @override
  String get logoutDialogTitle => 'تسجيل الخروج';

  @override
  String get logoutDialogContent =>
      'هل أنت متأكد أنك تريد الخروج من تطبيق كيدو؟ كل شيء سينتظرك بأمان عند عودتك!';

  @override
  String get stayButton => 'البقاء';

  @override
  String get logoutConfirm => 'خروج';

  @override
  String get viewPhoto => 'عرض الصورة الحالية';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseGallery => 'اختيار من المعرض';
}
