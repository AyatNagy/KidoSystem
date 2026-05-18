import 'package:kido/api_service/api_services.dart';
import 'package:kido/config/cache_helper.dart';
import 'package:kido/config/child_credentials_store.dart';

/// Ensures [LocalStorage] has a child JWT for progress APIs.
class ChildSessionService {
  ChildSessionService._();

  static Future<bool> ensureLoggedIn(int childId) async {
    if (childId <= 0) return false;

    final existingId = await LocalStorage.getChildId();
    final token = await LocalStorage.getChildToken();
    if (token != null && existingId == childId) return true;

    final creds = await ChildCredentialsStore.forChild(childId);
    if (creds == null) return false;

    final res = await ApiService.loginChild(
      creds['username']!,
      creds['password']!,
    );
    return res != null && res['success'] == true;
  }
}
