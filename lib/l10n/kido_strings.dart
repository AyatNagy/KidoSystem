import 'package:flutter/material.dart';
import 'package:kido/Models/onboard_model.dart';
import 'app_localizations.dart';

class KidoStrings extends AppLocalizations {
  final bool isAr;

  KidoStrings.forLanguage(this.isAr) : super(isAr ? 'ar' : 'en');

  factory KidoStrings.fromLocale(Locale locale) {
    return KidoStrings.forLanguage(locale.languageCode == 'ar');
  }

  static KidoStrings of(BuildContext context) {
    return AppLocalizations.of(context)! as KidoStrings;
  }

  String _t(String en, String ar) => isAr ? ar : en;

  @override
  String get appTitle => _t('Kido', 'كيدو');

  @override
  String get playButton => _t("Let's Play!", 'هيا نلعب!');

  @override
  String get continueButton => _t('Continue', 'متابعة');

  @override
  String get skip => _t('Skip', 'تخطي');

  @override
  String get back => _t('Back', 'رجوع');

  @override
  String get success => _t('Success', 'نجاح');

  @override
  String get unknown => _t('Unknown', 'غير معروف');

  @override
  String get levelLabel => _t('Level', 'المستوى');

  @override
  String get locked => _t('Locked', 'مقفول');

  @override
  String get letsGo => _t("LET'S GO!", 'هيا بنا!');

  @override
  String get startTagline =>
      _t("Every Child's\nJourney to Their Star!", 'رحلة كل طفل\nنحو نجمه!');

  String get onboardLearnTitle => _t('Learn', 'تعلّم');

  String get onboardLearnDesc => _t(
        'Discover fun lessons with letters, numbers, shapes, and more!',
        'اكتشف دروساً ممتعة في الحروف والأرقام والأشكال والمزيد!',
      );

  String get onboardPlayTitle => _t('Play', 'العب');

  String get onboardPlayDesc => _t(
        'Enjoy interactive games and quizzes that make learning exciting.',
        'استمتع بألعاب تفاعلية واختبارات تجعل التعلّم ممتعاً.',
      );

  String get onboardConnectTitle => _t('Connect', 'تواصل');

  String get onboardConnectDesc => _t(
        "Track your child's progress and stay in touch.",
        'تابع تقدّم طفلك وابقَ على تواصل.',
      );

  String get onboardGuideTitle => _t('Guide', 'إرشاد');

  String get onboardGuideDesc => _t(
        'Assess levels and assign activities.',
        'قيّم المستويات وعيّن الأنشطة.',
      );

  @override
  String get login => _t('Login', 'تسجيل الدخول');

  @override
  String get signUp => _t('Sign Up', 'إنشاء حساب');

  @override
  String get email => _t('Email', 'البريد الإلكتروني');

  @override
  String get password => _t('Password', 'كلمة المرور');

  @override
  String get forgotPassword => _t('Forgot Password?', 'نسيت كلمة المرور؟');

  @override
  String get signIn => _t('Sign In', 'تسجيل الدخول');

  @override
  String get noAccountYet => _t("Don't have an account?", 'ليس لديك حساب؟');

  @override
  String get createAccount => _t('Create one', 'أنشئ حساباً');

  @override
  String get loginSuccess => _t('Login successful!', 'تم تسجيل الدخول بنجاح!');

  @override
  String get changeAppLanguage =>
      _t('Change application language', 'تغيير لغة واجهة التطبيق');

  @override
  String get editProfile => _t('Edit Profile', 'تعديل الملف الشخصي');

  @override
  String get updateInfo => _t('Update your personal info', 'تحديث معلوماتك الشخصية');

  @override
  String get languageTitle => _t('Language', 'اللغة');

  @override
  String get privacyTitle => _t('Privacy & Security', 'الخصوصية والأمان');

  @override
  String get privacySubtitle => _t('Manage your data', 'إدارة بياناتك');

  @override
  String get logoutButton => _t('LOG OUT', 'تسجيل الخروج');

  @override
  String get logoutDialogTitle => _t('Sign Out', 'تسجيل الخروج');

  @override
  String get logoutDialogContent => _t(
        'Are you sure you want to exit the Kido app? Everything will be safely waiting for your return!',
        'هل أنت متأكد من الخروج من تطبيق كيدو؟ كل شيء سينتظرك بأمان عند عودتك!',
      );

  @override
  String get stayButton => _t('Stay', 'البقاء');

  @override
  String get logoutConfirm => _t('Logout', 'خروج');

  @override
  String get viewPhoto => _t('View Current Photo', 'عرض الصورة الحالية');

  @override
  String get takePhoto => _t('Take a photo', 'التقاط صورة');

  @override
  String get chooseGallery => _t('Choose from gallery', 'اختيار من المعرض');

  @override
  String get welcomeBack => _t('Welcome back,', 'مرحباً بعودتك،');

  @override
  String get yourChildren => _t('Your Children', 'أطفالك');

  @override
  String get addChild => _t('Add Child', 'إضافة طفل');

  @override
  String get noChildrenYet => _t(
        'No children added yet.\nTap "Add Child" to get started!',
        'لم يتم إضافة أطفال بعد.\nاضغط على "إضافة طفل" للبدء!',
      );

  @override
  String get holdToEdit => _t('Hold to edit', 'علق للتعديل');

  @override
  String get needAdvice => _t('Need advice?', 'تحتاج إلى نصيحة؟');

  @override
  String get askAiProgress =>
      _t('Ask our AI about progress', 'اسأل الذكاء الاصطناعي عن التقدم');

  @override
  String get chat => _t('Chat', 'محادثة');

  @override
  String get navHome => _t('Home', 'الرئيسية');

  @override
  String get navDashboard => _t('Dashboard', 'اللوحة');

  @override
  String get navLearn => _t('Learn', 'تعلم');

  @override
  String get navProfile => _t('Profile', 'حسابي');

  @override
  String get chooseChild => _t('Choose a child', 'اختر طفلاً');

  @override
  String get selectChildHint =>
      _t('Select a profile to view their learning dashboard', 'اختر ملفاً لعرض لوحة التعلّم');

  @override
  String get dailyReminderSent =>
      _t('Daily reminder is on — great job staying consistent!', 'التذكير اليومي مفعّل — استمرار رائع!');

  @override
  String get dailyReminderScheduled =>
      _t('We will remind your child every day at 9:00 AM.', 'سنذكّر طفلك كل يوم الساعة 9:00 صباحاً.');

  @override
  String levelUnlocked(int level) =>
      _t('Congratulations! Level $level is unlocked!', 'مبروك! تم فتح المستوى $level!');

  @override
  String get startExploring => _t('Start Exploring!', 'ابدأ الاستكشاف!');

  @override
  String get hiParent => _t('Hi, Parent!', 'مرحباً ولي الأمر!');

  @override
  String get errorTitle => _t('Error', 'خطأ');

  @override
  String get googleLoginSuccess =>
      _t('Google Login successful!', 'تم تسجيل الدخول عبر Google بنجاح!');

  @override
  String get finalExam => _t('Final Exam', 'الاختبار النهائي');

  @override
  String get finalExamSubtitle =>
      _t('Test your mighty knowledge and level up!', 'اختبر معرفتك وارتقِ بالمستوى!');

  @override
  String get defaultKidName => _t('Kid', 'طفل');

  @override
  String get taskLabel => _t('Task', 'مهمة');

  @override
  String helloChild(String name) => _t('Hello, $name!', 'مرحباً، $name!');

  @override
  String get letsLearnFun => _t("Let's learn and have fun!", 'هيا نتعلم ونستمتع!');

  @override
  String get categories => _t('Categories', 'الفئات');

  @override
  String get dailyChallenge => _t('Daily Challenge', 'التحدي اليومي');

  @override
  String get level1ChallengeSubtitle => _t(
        'Counting, Sorting, Pegboard, Self-Care, feelings and senses',
        'العد، الفرز، اللوح، العناية الذاتية، المشاعر والحواس',
      );

  @override
  String get level2ChallengeSubtitle => _t(
        'Lines, Shapes, Sizes and Puzzle',
        'الخطوط، الأشكال، الأحجام والألغاز',
      );

  @override
  String get level3ChallengeSubtitle => _t(
        'Family, Letters, Numbers, Fruits, Vegetables and Animals',
        'العائلة، الحروف، الأرقام، الفواكه، الخضروات والحيوانات',
      );

  @override
  String get skillTest => _t('Skill Test', 'اختبار المهارات');

  @override
  String get proveSkills => _t('Prove your skills!', 'أثبت مهاراتك!');

  @override
  String get startTest => _t('START TEST', 'ابدأ الاختبار');

  @override
  String get dashboard => _t('Dashboard', 'لوحة التحكم');

  @override
  String get learningJourney => _t('Learning Journey', 'رحلة التعلّم');

  @override
  String get accuracy => _t('Accuracy', 'الدقة');

  @override
  String get badges => _t('Badges', 'الشارات');

  @override
  String get everythingLooksGreat =>
      _t('Everything looks great today!', 'كل شيء يبدو رائعاً اليوم!');

  @override
  String get progressSaved => _t('Progress saved!', 'تم حفظ التقدّم!');

  @override
  String get progressSaveFailed =>
      _t('Could not save progress. Check connection.', 'تعذّر حفظ التقدّم. تحقق من الاتصال.');

  @override
  String get childNotLinked => _t(
        'Child not linked — open from Home with a child profile.',
        'الطفل غير مربوط — افتح من الرئيسية بملف طفل.',
      );

  @override
  String get noChildrenDashboard => _t(
        'No children linked yet.\nAdd a child from the Home tab first.',
        'لا يوجد أطفال بعد.\nأضف طفلاً من تبويب الرئيسية أولاً.',
      );

  @override
  String categoryTitle(String key) {
    switch (key.toLowerCase()) {
      case 'letters':
        return _t('Letters', 'الحروف');
      case 'numbers':
        return _t('Numbers', 'الأرقام');
      case 'veggie':
      case 'vegetables':
        return _t('Vegetables', 'الخضروات');
      case 'fruits':
        return _t('Fruits', 'الفواكه');
      case 'feelings':
      case 'emotions':
        return _t('Emotions', 'المشاعر');
      case 'pegboard':
        return _t('PegBoard', 'اللوح');
      case 'family':
        return _t('Family', 'العائلة');
      case 'animals':
        return _t('Animals', 'الحيوانات');
      case 'shapes':
        return _t('Shapes', 'الأشكال');
      case 'lines':
        return _t('Lines', 'الخطوط');
      case 'sizes':
        return _t('Sizes', 'الأحجام');
      case 'puzzle':
        return _t('Puzzle', 'الألغاز');
      case 'counting':
        return _t('Counting', 'العد');
      case 'sorting':
        return _t('Sorting', 'الفرز');
      case 'clean up':
        return _t('Clean Up', 'الترتيب');
      case 'senses':
        return _t('Senses', 'الحواس');
      case 'self-care':
        return _t('Self-Care', 'العناية الذاتية');
      default:
        return key;
    }
  }

  List<OnboardModel> get onboardPages => [
        OnboardModel(
          image: 'assets/images/learn.jpeg',
          title: onboardLearnTitle,
          color: const Color(0xFF6A37A8),
          desc: onboardLearnDesc,
          gradientColors: const [Color(0xFFD1A6FF), Color(0xFF6A37A8), Color(0xFF4C148F)],
        ),
        OnboardModel(
          image: 'assets/images/play.png',
          title: onboardPlayTitle,
          color: const Color(0xFF277D8D),
          desc: onboardPlayDesc,
          gradientColors: const [Color(0xFF75E6F0), Color(0xFF277D8D), Color(0xFF0E4C58)],
        ),
        OnboardModel(
          image: 'assets/images/connect.png',
          title: onboardConnectTitle,
          color: const Color(0xFFCC5E33),
          desc: onboardConnectDesc,
          gradientColors: const [Color(0xFFFFB482), Color(0xFFCC5E33), Color(0xFF8A2F07)],
        ),
        OnboardModel(
          image: 'assets/images/guide.jpeg',
          title: onboardGuideTitle,
          color: const Color(0xFF2E8B57),
          desc: onboardGuideDesc,
          gradientColors: const [Color(0xFF9AF7C2), Color(0xFF2E8B57), Color(0xFF0F5E33)],
        ),
      ];
}
