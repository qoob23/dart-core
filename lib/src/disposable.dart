import 'dart:async';

import 'package:meta/meta.dart';

abstract class Disposable {
  @mustCallSuper
  FutureOr<void> dispose();
}
