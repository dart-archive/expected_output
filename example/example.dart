// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
