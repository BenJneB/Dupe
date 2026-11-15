import 'dart:async';

import 'package:dupe/features/home_widget/data/home_screen_widget.dart';

/// Records what the app shows on the widget; simulates launches and taps.
class FakeHomeScreenWidget implements HomeScreenWidget {
  new({this.launchedWith});

  final Uri? launchedWith;
  final shown = <String>[];
  final _taps = StreamController<Uri?>.broadcast();

  void tap(Uri link) => _taps.add(link);

  @override
  Future<Uri?> initialLaunch() async => launchedWith;

  @override
  Stream<Uri?> get taps => _taps.stream;

  @override
  Future<void> showCounts(String counts) async => shown.add(counts);
}
