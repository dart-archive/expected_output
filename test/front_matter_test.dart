// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library expected_output.test.front_matter_test;

import 'dart:mirrors';

import 'package:expected_output/expected_output.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  Iterator iterator;
  var dataCase;
  var iteratorIsEmpty;

  setUpAll(() {
    // Locate the "test" directory. Use mirrors so that this works with the test
    // package, which loads this suite into an isolate.
    var testDir = p.dirname(currentMirrorSystem()
        .findLibrary(#expected_output.test.front_matter_test)
        .uri
        .toFilePath());
    iterator = dataCases(directory: p.join(testDir, 'front_matter')).iterator;
  });

  setUp(() {
    iteratorIsEmpty = !iterator.moveNext();
    dataCase = iterator.current;
  });

  test('parses front matter as a string', () {
    expect(dataCase.directory, 'front_matter');
    expect(dataCase.file, 'data');
    expect(dataCase.description, 'line 4: data case 1');
    expect(dataCase.front_matter,
        'This is front matter.\n' 'It can span several lines.\n');
  });

  test('parses case w/ whitespace after >>>', () {
    expect(dataCase.description, 'line 8: data case 2');
    expect(dataCase.front_matter,
        'This is front matter.\n' 'It can span several lines.\n');
  });

  test('the dataCases iterator is empty at the end', () {
    expect(iteratorIsEmpty, isTrue);
  });
}
