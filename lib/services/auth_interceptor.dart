import 'package:http_interceptor/http_interceptor.dart';
import 'package:three_youth_app/managers/account_manager.dart';

class AuthInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData? data}) async {
    return data!;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData? data}) async {
    if (data!.headers!.containsKey('x-logout')) {
      AccountManager().logout();
    }
    return data;
  }
}
