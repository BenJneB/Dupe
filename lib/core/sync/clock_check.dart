/// Device clock check (PLAN_V3 risk 6). The sync keeps the most recent write,
/// dated by the device clock: a device far ahead would win every conflict.
/// The app only warns; it never corrects the time.
abstract final class ClockCheck {
  /// Beyond this gap with the server, the device time is considered wrong.
  static const maxSkew = Duration(minutes: 2);

  /// At most one check per hour (one extra request).
  static const every = Duration(hours: 1);

  /// Device minus server when beyond [maxSkew], else null.
  static Duration? skew(DateTime device, DateTime server) {
    final gap = device.difference(server);
    return gap.abs() > maxSkew ? gap : null;
  }
}
