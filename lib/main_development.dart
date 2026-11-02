import 'dart:async';

import 'package:tava/app/app.dart';
import 'package:tava/bootstrap.dart';

void main() {
  // Development uses the real Supabase project with Hive caching.
  unawaited(bootstrap(() => const App()));
}
