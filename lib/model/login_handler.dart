import 'package:appartapp/entities/user.dart';
import 'package:appartapp/enums/enum_gender.dart';
import 'package:appartapp/enums/enum_loginresult.dart';
import 'package:appartapp/exceptions/connection_exception.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class LoginHandler {
  static const String urlStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/login";

  static const String urlInvalidateStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/invalidatesession";

  static const String signupUrlStr =
      "http://10.0.2.2/appart-1.0-SNAPSHOT/api/signup";

  static Future<List> doLoginWithGoogleToken(
      fb.User user, String accessToken) async {
    String? idToken = await user.getIdToken();

    if (idToken==null) {
      throw ConnectionException();
    }

    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        urlStr,
        data: {"idtoken": idToken, "accesstoken": accessToken},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          return [null, LoginResult.wrong_credentials];
        } else {
          return [null, LoginResult.server_error];
        }
      } else {
        Map responseMap = response.data;
        User user = User.fromMap(responseMap);

        return [user, LoginResult.ok];
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.cancel) {
        throw ConnectionException();
      }
      if (e.response?.statusCode == 401) {
        return [null, LoginResult.wrong_credentials];
      }
      return [null, LoginResult.server_error];
    }
  }

  static Future<void> invalidateSession() async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.get(
        urlInvalidateStr,
      );

      if (response.statusCode != 200) {
        throw ConnectionException();
      }
    } on DioException {
      throw ConnectionException();
    }
  }

  static Future<List> doLogin(String email, String password) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        urlStr,
        data: {"email": email, "password": password},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          return [null, LoginResult.wrong_credentials];
        } else {
          return [null, LoginResult.server_error];
        }
      } else {
        Map responseMap = response.data;
        User user = User.fromMap(responseMap);

        return [user, LoginResult.ok];
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.cancel) {
        throw ConnectionException();
      }
      if (e.response?.statusCode == 401) {
        return [null, LoginResult.wrong_credentials];
      }
      return [null, LoginResult.server_error];
    }
  }

  static Future<List> doLoginWithCookies() async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        urlStr,
        //data: {"email": email, "password": password},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          return [null, LoginResult.wrong_credentials];
        } else {
          return [null, LoginResult.server_error];
        }
      } else {
        Map responseMap = response.data;
        User user = User.fromMap(responseMap);

        return [user, LoginResult.ok];
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.cancel) {
        throw ConnectionException();
      }
      if (e.response?.statusCode == 401) {
        return [null, LoginResult.wrong_credentials];
      }
      return [null, LoginResult.server_error];
    }
  }

  static void doSignup(
      Function(String) updateUi,
      String email,
      String password,
      String name,
      String surname,
      DateTime birthday,
      Gender gender,
      Function(User) onComplete,
      Function onError) async {
    var dio = RuntimeStore().dio; //ok
    try {
      Response response = await dio.post(
        signupUrlStr,
        data: {
          "email": email,
          "password": password,
          "name": name,
          "surname": surname,
          "birthday": birthday.millisecondsSinceEpoch.toString(),
          "gender": gender.toShortString()
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      if (response.statusCode == 200) {
        Map responseMap = response.data;
        User user = User.fromMap(responseMap);

        onComplete(user);
      } else if (response.statusCode == 500) {
        updateUi("Impossibile iscriversi. Scegli altre credenziali.");
      } else {
        onError();
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 500) {
        updateUi("Impossibile iscriversi. Scegli altre credenziali.");
      } else {
        onError();
      }
    }
  }
}
