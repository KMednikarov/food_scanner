import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final _websites = [
    'https://google.com',
    'https://cloudflare.com',
    'https://opendns.com',
  ];

  @override
  Future<bool> get isConnected async {
    for (String website in _websites) {
      try {
        final result = await InternetAddress.lookup(website);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        return false;
      }
    }

    return false;
  }
}
