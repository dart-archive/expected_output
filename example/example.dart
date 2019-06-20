library touppercase.tests;

import 'package:expected_output/expected_output.dart';
import 'package:test/test.dart';

void main() {
  for (var dataCase in dataCasesUnder(library: #touppercase.tests)) {
    test(dataCase.testDescription, () {
      var actualOutput = dataCase.input.toUpperCase();
      expect(actualOutput, equals(dataCase.expectedOutput));
    });
  }
}
