// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library expected_output.test.custom_extension_test;

import 'dart:mirrors';

import 'package:expected_output/expected_output.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('parses case w/o a description', () {
    // Locate the "test" directory. Use mirrors so that this works with the test
    // package, which loads this suite into an isolate.
    var testDir = p.dirname(currentMirrorSystem()
        .findLibrary(#expected_output.test.custom_extension_test)
        .uri
        .toFilePath());
    var iterator = dataCases(
            directory: p.join(testDir, 'custom_extension'), extension: 'data')
        .iterator;
    iterator.moveNext();
    var dataCase = iterator.current;

    expect(dataCase.directory, 'custom_extension');
    expect(dataCase.file, 'cases');
    expect(dataCase.description, 'line 2: this file has a custom extension');
    expect(dataCase.testDescription,
        'custom_extension cases line 2: ' 'this file has a custom extension');
    expect(dataCase.input, 'the input\n');
    expect(dataCase.expectedOutput, 'the output\n');
    expect(dataCase.skip, false);

    var iteratorIsEmpty = !iterator.moveNext();
    expect(iteratorIsEmpty, isTrue);
  });
}
