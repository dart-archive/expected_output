// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library expected_output.test.individual_file_test;

import 'dart:mirrors';

import 'package:expected_output/expected_output.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  // Locate the "test" directory. Use mirrors so that this works with the test
  // package, which loads this suite into an isolate.
  var testDir = p.dirname(currentMirrorSystem()
      .findLibrary(#expected_output.test.individual_file_test)
      .uri
      .toFilePath());
  testDir = p.join(testDir, 'individual_files');

  test('looks for data cases in individual files', () {
    var iterator = dataCasesInFile(path: p.join(testDir, 'a.unit')).iterator;
    iterator.moveNext();
    var dataCase = iterator.current;

    expect(dataCase.directory, endsWith('individual_files'));
    expect(dataCase.file, 'a');
    expect(dataCase.description, 'line 2: description 1');

    iterator.moveNext();
    dataCase = iterator.current;

    expect(dataCase.directory, endsWith('individual_files'));
    expect(dataCase.file, 'a');
    expect(dataCase.description, 'line 6: description 2');

    var iteratorIsEmpty = !iterator.moveNext();
    expect(iteratorIsEmpty, isTrue);
  });

  test('looks for data cases in individual files', () {
    var iterator = dataCasesInFile(path: p.join(testDir, 'b.unit')).iterator;
    iterator.moveNext();
    var dataCase = iterator.current;

    expect(dataCase.directory, endsWith('individual_files'));
    expect(dataCase.file, 'b');
    expect(dataCase.description, 'line 2: description 3');

    iterator.moveNext();
    dataCase = iterator.current;

    expect(dataCase.directory, endsWith('individual_files'));
    expect(dataCase.file, 'b');
    expect(dataCase.description, 'line 6: description 4');

    var iteratorIsEmpty = !iterator.moveNext();
    expect(iteratorIsEmpty, isTrue);
  });
}
