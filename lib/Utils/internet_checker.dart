part of 'package:tum/Utils/utils.dart';

class InternetChecker{
   Future<bool> checkInternetAccess() {
    /// We use a mix of IPV4 and IPV6 here in case some networks only accept one of the types.
    /// Only tested with an IPV4 only network so far (I don't have access to an IPV6 network).
    final List<InternetAddress> dnss = [
      InternetAddress('8.8.8.8', type: InternetAddressType.IPv4), // Google
      InternetAddress('1.1.1.1', type: InternetAddressType.IPv4), // CloudFlare
      InternetAddress('208.67.222.222', type: InternetAddressType.IPv4), // OpenDNS
      InternetAddress('180.76.76.76', type: InternetAddressType.IPv4), // Baidu
    ];

    final Completer<bool> completer = Completer<bool>();

    int callsReturned = 0;
    void onCallReturned(bool isAlive) {
      if (completer.isCompleted) return;

      if (isAlive) {
        completer.complete(true);
      } else {
        callsReturned++;
        if (callsReturned >= dnss.length) {
          completer.complete(false);
        }
      }
    }

    for (var dns in dnss) {
      _pingDns(dns).then(onCallReturned);
    }

    return completer.future;
  }

  Future<bool> _pingDns(InternetAddress dnsAddress) async {
    const int dnsPort = 53;
    const Duration timeout = Duration(seconds: 3);

    Socket socket;
    socket = await Socket.connect(dnsAddress, dnsPort, timeout: timeout);
    try {
      
      socket.destroy();
      return true;
    } on SocketException {
      socket.destroy();
    }
    return false;
  }
}