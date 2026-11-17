import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_status.g.dart';

/// What the current connection costs: Wi-Fi or cable (unmetered), mobile
/// data or unknown (metered), or no connection.
enum NetworkKind {
  unmetered,
  metered,
  none;

  /// Whether background downloads may run on this connection
  /// ([wifiOnly]: not on mobile data).
  bool allows({required bool wifiOnly}) => switch (this) {
    unmetered => true,
    metered => !wifiOnly,
    none => false,
  };
}

/// Current connection and its changes. Overridden in tests.
abstract interface class NetworkStatus {
  Future<NetworkKind> current();

  Stream<NetworkKind> get changes;
}

class PlatformNetworkStatus implements NetworkStatus {
  new([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<NetworkKind> current() async =>
      kindOf(await _connectivity.checkConnectivity());

  @override
  Stream<NetworkKind> get changes =>
      _connectivity.onConnectivityChanged.map(kindOf).distinct();

  /// A VPN alone is counted as metered: it may run over mobile data.
  static NetworkKind kindOf(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      return NetworkKind.unmetered;
    }
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      return NetworkKind.none;
    }
    return NetworkKind.metered;
  }
}

@Riverpod(keepAlive: true)
NetworkStatus networkStatus(Ref ref) => PlatformNetworkStatus();
