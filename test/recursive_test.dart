// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library expected_output.test.recursive_test;

import 'dart:mirrors';

import 'package:expected_output/expected_output.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('looks for data cases recursively', () {
    // Locate the "test" directory. Use mirrors so that this works with the test
    // package, which loads this suite into an isolate.
    var testDir = p.dirname(currentMirrorSystem()
        .findLibrary(#expected_output.test.recursive_test)
        .uri
        .toFilePath());
    var iterator =
        dataCases(directory: p.join(testDir, 'recursive_data')).iterator;
    iterator.moveNext();
    var dataCase = iterator.current;

    expect(dataCase.directory, 'recursive_data');
    expect(dataCase.file, 'foo');
    expect(dataCase.description, 'line 2: data case in the primary directory');

    iterator.moveNext();
    dataCase = iterator.current;

    expect(dataCase.directory, 'recursive_data/deep');
    expect(dataCase.file, 'bar');
    expect(dataCase.description, 'line 2: a deeper data case');

    iterator.moveNext();
    dataCase = iterator.current;

    expect(dataCase.directory, 'recursive_data/deep/deeper');
    expect(dataCase.file, 'baz');
    expect(dataCase.description, 'line 2: deeper test case');

    var iteratorIsEmpty = !iterator.moveNext();
    expect(iteratorIsEmpty, isTrue);
  });

  test('looks for data cases non-recursively', () {
    // Locate the "test" directory. Use mirrors so that this works with the test
    // package, which loads this suite into an isolate.
    var testDir = p.dirname(currentMirrorSystem()
        .findLibrary(#expected_output.test.recursive_test)
        .uri
        .toFilePath());
    var iterator = dataCases(
            directory: p.join(testDir, 'recursive_data'), recursive: false)
        .iterator;
    iterator.moveNext();
    var dataCase = iterator.current;

    expect(dataCase.directory, 'recursive_data');
    expect(dataCase.file, 'foo');
    expect(dataCase.description, 'line 2: data case in the primary directory');

    var iteratorIsEmpty = !iterator.moveNext();
    expect(iteratorIsEmpty, isTrue);
  });
}
