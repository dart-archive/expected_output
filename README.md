Keep multiline test case inputs and outputs out of your Dart test code, and
write them directly as text files.

## Example

Take the following test case for String's `toUpperCase()`:

```dart
void main() {
  test('Works on multiline strings', () {
    var input = r'''This is the first line.
This is another line.

This is another paragraph.''';

    var expectedOutput = r'''THIS IS THE FIRST LINE.
THIS IS ANOTHER LINE.

THIS IS ANOTHER PARAGRAPH.''';

    expect(input.toUpperCase(), equals(expectedOutput));
  });
}
```

Multiline strings break the visual flow of code indentations. Additionally, when
newline characters are important, you may not be able to just write a newline
after `r'''`, or before the closing `''';`, which makes it hard to scan for
where multiline Strings begin and end. Instead, let's add write this test case,
and a few more, in a separate text file:

```none
>>> Works on simple strings
This is a single line.
<<<
THIS IS A SINGLE LINE.
>>> Does nothing to upper case strings
THIS IS ALREADY UPPER CASE.
<<<
THIS IS ALREADY UPPER CASE.
>>> Works on multiline strings
This is the first line.
This is another line.

This is another paragraph.
<<<
THIS IS THE FIRST LINE.
THIS IS ANOTHER LINE.

THIS IS ANOTHER PARAGRAPH.
```

We can quickly create tests over these data cases with some Dart:

```dart
library touppercase.tests;

void main() {
  for (var dataCase in dataCasesUnder(library: #touppercase.tests)) {
    test(dataCase.testDescription, () {
      var actualOutput = dataCase.input.toUpperCase();
      expect(actualOutput, equals(dataCase.expectedOutput));
    });
  }
}
```

If our test is located at `to_upper_case_package/test/to_upper_case_test.dart`,
then `dataCasesUnder` will look for files ending in `.unit` in the same
directory as the `library`. So our text file with the test cases should be,
perhaps, `to_upper_case_package/test/cases.unit`.

## When to use

This package is not very broad purposed, and is probably appropriate for only
very specific functionality testing. It has been very useful for testing
packages that primarily transform one block of text into another block of text.

This package is also mostly useful when the different ways to configure the
processing is very limited. In these cases, the Dart code that receives the test
cases and asserts over them can be very brief, and developers can focus on just
writing the data test cases.

This package is also most useful when whitespace is _ever_ significant. In cases
like this, multiline strings cannot fake indentation, and it may be harder for
the developer to track whitespace when writing a test case. In contrast, it is
probably much easier to write input and expected output in simple text blocks
in simple text files. Examples would include a Markdown parser that needs to
parse indented list continuations or indented code blocks, and text formatters
that need to test specific indentation in the output.

Disclaimer: this is not an official Google product.
