import 'package:dupe/features/releases/data/release_notifications.dart';

/// Records the release notifications instead of showing them.
class FakeReleaseNotifications implements ReleaseNotifications {
  final shown = <int>[];

  @override
  Future<void> show(int count) async => shown.add(count);
}
