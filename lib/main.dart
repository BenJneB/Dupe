import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dupe/app/app.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/logging/log_observer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    appLog.error('flutter', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    appLog.error('uncaught', error, stack);
    return true;
  };
  unawaited(_attachLogFile());
  runApp(const ProviderScope(observers: [LogObserver()], child: DupeApp()));
}

Future<void> _attachLogFile() async {
  try {
    final dir = await getApplicationSupportDirectory();
    await appLog.attach(File(p.join(dir.path, 'dupe_log.jsonl')));
  } on Object catch (e) {
    appLog.warning('log', e);
  }
}
