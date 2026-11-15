import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dupe/core/network/network_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Wi-Fi or cable is unmetered, even with a VPN on top', () {
    const kindOf = PlatformNetworkStatus.kindOf;
    expect(kindOf([ConnectivityResult.wifi]), NetworkKind.unmetered);
    expect(kindOf([ConnectivityResult.ethernet]), NetworkKind.unmetered);
    expect(
      kindOf([ConnectivityResult.vpn, ConnectivityResult.wifi]),
      NetworkKind.unmetered,
    );
    expect(kindOf([ConnectivityResult.mobile]), NetworkKind.metered);
    expect(kindOf([ConnectivityResult.vpn]), NetworkKind.metered);
    expect(kindOf([ConnectivityResult.none]), NetworkKind.none);
    expect(kindOf([]), NetworkKind.none);
  });
}
