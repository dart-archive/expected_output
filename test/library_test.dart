// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library expected_output.test.recursive_test;

import 'package:expected_output/expected_output.dart';
import 'package:test/test.dart';

void main() {
  test('finds test cases when passed a library Symbol', () {
    var iterator = dataCasesUnder(
            library: #expected_output.test.recursive_test,
            subdirectory: 'recursive_data',
            recursive: false)
        .iterator;
    iterator.moveNext();
    var dataCase = iterator.current;

    expect(dataCase.directory, 'recursive_data');
    expect(dataCase.file, 'foo');
    expect(dataCase.description, 'line 2: data case in the primary directory');

    var iteratorIsEmpty = !iterator.moveNext();
    expect(iteratorIsEmpty, isTrue);
  });

  test('finds test cases when passed a library Symbol, and subdirectories', () {
    var iterator = dataCasesUnder(
            library: #expected_output.test.recursive_test,
            subdirectory: 'recursive_data/deep',
            recursive: false)
        .iterator;
    iterator.moveNext();
    var dataCase = iterator.current;

    expect(dataCase.directory, 'deep');
    expect(dataCase.file, 'bar');
    expect(dataCase.description, 'line 2: a deeper data case');

    var iteratorIsEmpty = !iterator.moveNext();
    expect(iteratorIsEmpty, isTrue);
  });
}
