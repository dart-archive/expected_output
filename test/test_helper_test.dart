// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library expected_output.test.recursive_test;

import 'package:expected_output/expected_output.dart';
import 'package:test/test.dart';

void main() {
  group('testDataCasesUnder', () {
    var testDataCaseCount = 0;

    testDataCasesUnder(
        library: #expected_output.test.recursive_test,
        subdirectory: 'recursive_data',
        testBody: (DataCase dataCase) {
          expect(dataCase.description, isNotEmpty);
          testDataCaseCount++;
        });

    // TODO(srawlins): This is brittle; it super depends on the test cases
    // above being run _before_ this test case. Not good. Find a way to
    // test the test framework from within the test framework.
    test('declares all recursive tests', () {
      expect(testDataCaseCount, 3);
    });
  });

  group('testDataCasesUnder', () {
    var testDataCaseCount = 0;

    testDataCasesUnder(
        library: #expected_output.test.recursive_test,
        subdirectory: 'recursive_data',
        recursive: false,
        testBody: (DataCase dataCase) {
          expect(dataCase.description, isNotEmpty);
          testDataCaseCount++;
        });

    test('declares all immediate tests', () {
      expect(testDataCaseCount, 1);
    });
  });
}
