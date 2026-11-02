import 'dart:async';

import 'package:tava/app/app.dart';
import 'package:tava/bootstrap.dart';

void main() {
  unawaited(bootstrap(() => const App()));
}
