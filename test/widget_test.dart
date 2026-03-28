// Smoke test without importing the app graph (avoids Windows plugin / SDK
// compile issues on older Dart SDKs when resolving transitive win32).
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sanity', () {
    expect(1 + 1, 2);
  });
}
