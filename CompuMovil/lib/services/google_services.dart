import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleService {
  static final Logger _logger = Logger();
  static final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: ['email', 'profile']);

  static Future<bool> logIn() async {
    bool ok = false;
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        String idToken = auth.idToken ?? '';
        String accessToken = auth.accessToken ?? '';
        ok = idToken.isNotEmpty && accessToken.isNotEmpty;
        if (ok) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('idToken', idToken);
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('email', account.email);
          await prefs.setString('name', account.displayName ?? '');
          await prefs.setString('image', account.photoUrl ?? '');
        }
      }
    } catch (error, stackTrace) {
      ok = false;
      _logger.e(error);
      _logger.e(stackTrace.toString());
    }
    return ok;
  }

  static Future<void> logOut() async {
    try {
      // Cierra la sesión de Google
      await _googleSignIn.signOut();

      // Borra los datos de SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _logger.i("Usuario ha cerrado sesión");
    } catch (error, stackTrace) {
      _logger.e("Error cerrando sesión: $error");
      _logger.e(stackTrace.toString());
    }
  }
}
