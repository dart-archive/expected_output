// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library expected_output.test.simple_test;

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
        .findLibrary(#expected_output.test.simple_test)
        .uri
        .toFilePath());
    iterator = dataCases(directory: p.join(testDir, 'simple_data')).iterator;
  });

  setUp(() {
    iteratorIsEmpty = !iterator.moveNext();
    dataCase = iterator.current;
  });

  test('parses case w/o a description', () {
    expect(dataCase.directory, 'simple_data');
    expect(dataCase.file, 'cases');
    expect(dataCase.description, 'line 2');
    expect(dataCase.testDescription, 'simple_data cases line 2');
    expect(dataCase.input, 'input 1\n');
    expect(dataCase.expectedOutput, 'output 1\n');
    expect(dataCase.skip, false);
  });

  test('parses case w/ whitespace after >>>', () {
    expect(
        dataCase.description, 'line 6: description with a space in the front.');
  });

  test('parses case w/o whitespace after >>>', () {
    expect(dataCase.description,
        'line 10: description without a space in the front.');
  });

  test('parses case w/ multiple whitespace after >>>', () {
    expect(dataCase.description,
        'line 14: description with a few spaces in the front.');
  });

  test('parses case w/ multiline input and output', () {
    expect(dataCase.input, 'input\nfive\n');
    expect(dataCase.expectedOutput, 'output\nfive\n');
  });

  test('parses case w/ skip description', () {
    expect(dataCase.description, 'line 24: skip: don\'t run this test');
    expect(dataCase.skip, true);
  });

  test('parses case w/o a description', () {
    expect(dataCase.directory, 'simple_data');
    expect(dataCase.file, 'cases2');
    expect(dataCase.description, 'line 2: a second unit file');
    expect(dataCase.testDescription,
        'simple_data cases2 line 2: a second unit file');
  });

  test('the dataCases iterator is empty at the end', () {
    expect(iteratorIsEmpty, isTrue);
  });
}
