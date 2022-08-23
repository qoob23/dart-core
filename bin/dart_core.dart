import 'package:dart_core/dart_core.dart';

void main() {
  try {
    throw ChainedException.context(
      ChainedException.context(
        ChainedException.origin('Initial cause', vars: {
          'MyVar': 123,
          'MyComplexVar': {'Subvar1': 1, 'Subvar2': 2}
        }),
        'Additional context',
        vars: {'ContextVar': 'SomeString'},
      ),
      'Another Context',
    );
  } on ChainedException catch (e, st) {
    print(e.print(st));
  }
}
