import 'package:injectable/injectable.dart';
import 'package:tava/app/app.dart';
import 'package:tava/bootstrap.dart';

void main() {
  bootstrap(() => const App(), environment: Environment.prod);
}
