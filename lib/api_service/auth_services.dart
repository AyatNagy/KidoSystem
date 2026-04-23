import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthServices {
  //static const String baseUrl = "https://kidosystem.duckdns.org/api";
  static const String baseUrl = "http://localhost:3000/api";
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleAuthServices() {
    _intitGoogleSignIn();
  }

  void _intitGoogleSignIn() {
    const String andriodId =
        '686443808938-jpmtgejjocnjv4r4kqenra6bl81idofq.apps.googleusercontent.com';
    const String iosId =
        '686443808938-vfnub1ra1u9hb2oama1kn8j2ijnkaafj.apps.googleusercontent.com';
    const String webId =
        '686443808938-7odsj4cb51r1pse92ecrrt81vbsssj6m.apps.googleusercontent.com';
    _googleSignIn.initialize(clientId: andriodId, serverClientId: webId);

    _googleSignIn.attemptLightweightAuthentication();
  }

  Future<Map<String, dynamic>?> signinWithGoogle() async {
    final dio = Dio();
    final url = '$baseUrl/auth/google';

    try {
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();
      if (account == null) return null;
      GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) return null;

      final response = await dio.post(
        url,
        data: {"idToken": idToken},
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) {
            return status! < 500; // Don't throw for 4xx errors
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("Google Login Successful: ${data['user']}");
        return data;
      } else {
        print("Google Login Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          "Error during Google login: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        print("Error during Google login: ${e.message}");
      }
      return null;
    } catch (error) {
      print("Error during Google login: $error");
      return null;
    }
  }
}
