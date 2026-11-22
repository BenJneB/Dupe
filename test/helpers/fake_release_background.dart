import 'package:dupe/features/releases/data/release_background.dart';
import 'package:dupe/features/releases/data/release_settings.dart';

/// Records the background schedules instead of calling WorkManager.
class FakeReleaseBackground implements ReleaseBackground {
  final scheduled = <ReleaseOptions>[];

  @override
  Future<void> schedule(ReleaseOptions options) async => scheduled.add(options);
}
