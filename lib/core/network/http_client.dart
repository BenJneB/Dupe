import 'package:dio/dio.dart';

const appName = 'Dupe/0.2';

/// Identifies the app to public APIs. No personal data by default; Open
/// Library adds the contact configured in env.json (OPEN_LIBRARY_CONTACT).
const userAgent = '$appName (personal book collection app)';

/// Shared HTTP client for metadata sources.
Dio createHttpClient() => Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {'User-Agent': userAgent},
  ),
);
