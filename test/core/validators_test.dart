import 'package:flutter_test/flutter_test.dart';
import 'package:tava/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('rejects invalid format', () {
      expect(Validators.email('not-an-email'), isNotNull);
    });

    test('accepts valid email', () {
      expect(Validators.email('player@tava.app'), isNull);
    });
  });

  group('Validators.password', () {
    test('enforces minimum length', () {
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });
  });
}
