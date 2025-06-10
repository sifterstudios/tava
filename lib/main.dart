import 'package:tava/app/app.dart';
import 'package:tava/bootstrap.dart';

void main() {
  bootstrap(() => const App(), 'prod');
}