import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Reads a recorded API response from test/fixtures/.
String fixture(String path) => File('test/fixtures/$path').readAsStringSync();

/// Dio adapter answering from fixtures; records requested URIs.
class FakeHttpAdapter implements HttpClientAdapter {
  /// Rules: first rule whose matcher matches the full URI answers.
  final rules = <({bool Function(Uri) match, int status, String body})>[];
  final requests = <Uri>[];

  void on(bool Function(Uri) match, String body, {int status = 200}) =>
      rules.add((match: match, status: status, body: body));

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options.uri);
    for (final rule in rules) {
      if (rule.match(options.uri)) {
        return ResponseBody.fromString(
          rule.body,
          rule.status,
          headers: {
            Headers.contentTypeHeader: [
              if (rule.body.trimLeft().startsWith('<'))
                'application/xml; charset=utf-8'
              else
                'application/json; charset=utf-8',
            ],
          },
        );
      }
    }
    return ResponseBody.fromString(jsonEncode({'error': 'no rule'}), 404);
  }

  @override
  void close({bool force = false}) {}
}

Dio fakeDio(FakeHttpAdapter adapter) => Dio()..httpClientAdapter = adapter;
