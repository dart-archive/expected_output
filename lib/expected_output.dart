import 'dart:io';
import 'dart:mirrors';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

// TODO(srawlins): add a recursive option
/// Parse and yield data cases (each a [DataCase]) from [directory].
///
/// By default, only read data cases from files with a `.unit` extension.
Iterable<DataCase> dataCases({
  String directory,
  String extension: 'unit',
}) sync* {
  var entries =
      new Directory(directory).listSync(recursive: false, followLinks: false);
  for (var entry in entries) {
    if (!entry.path.endsWith(extension)) {
      continue;
    }

    var file =
        p.basename(entry.path).replaceFirst(new RegExp('\.$extension\$'), '');

    // Explicitly create a File, in case the entry is a Link.
    var lines = new File(entry.path).readAsLinesSync();

    var i = 0;
    while (i < lines.length) {
      var description =
          lines[i++].replaceFirst(new RegExp(r'>>>\s*'), '').trim();
      if (description == '') {
        description = 'line ${i+1}';
      } else {
        description = 'line ${i+1}: $description';
      }

      var input = '';
      while (!lines[i].startsWith('<<<')) {
        input += lines[i++] + '\n';
      }

      var expectedOutput = '';
      while (++i < lines.length && !lines[i].startsWith('>>>')) {
        expectedOutput += lines[i] + '\n';
      }

      var dataCase = new DataCase(
          directory: p.basename(directory),
          file: file,
          description: description,
          input: input,
          expectedOutput: expectedOutput);
      yield dataCase;
    }
  }
}

/// Parse and yield data cases (each a [DataCase]) from the directory containing
/// [library].
///
/// By default, only read data cases from files with a `.unit` extension.
///
/// The typical use case of this method is to declare a library at the top of a
/// Dart test file, then reference the symbol with a pound sign. Example:
///
/// ```dart
/// library my_package.test.this_test;
///
/// import 'package:expected_output/expected_output.dart';
/// import 'package:test/test.dart';
///
/// void main() {
///   for (var dataCase in dataCasesUnder(library: #my_package.test.this_test)) {
///     // ...
///   }
/// }
/// ```
Iterable<DataCase> dataCasesUnder(
    {Symbol library, String extension: 'unit'}) sync* {
  var directory =
      p.dirname(currentMirrorSystem().findLibrary(library).uri.toFilePath());
  for (var dataCase
      in expectedOutputs(directory: directory, extension: extension)) {
    yield dataCase;
  }
}

/// All of the data pertaining to a particular test case, namely the [input] and
/// [expectedOutput].
class DataCase {
  final String directory;
  final String file;
  final String description;
  final String input;
  final String expectedOutput;

  DataCase(
      {this.directory,
      this.file,
      this.description,
      this.input,
      this.expectedOutput});

  /// A good standard description for `test()`, derived from the data directory,
  /// the particular data file, and the test case description.
  String get testDescription => [directory, file, description].join(' ');
}
