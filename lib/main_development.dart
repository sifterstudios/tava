import 'package:injectable/injectable.dart';
import 'package:tava/app/app.dart';
import 'package:tava/bootstrap.dart';

void main() {
  // Development uses the real Supabase project with Hive caching.
  bootstrap(() => const App(), environment: Environment.prod);
}
