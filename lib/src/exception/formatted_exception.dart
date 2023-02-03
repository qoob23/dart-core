part of 'chained_exception.dart';

class _FormattedChainedException {
  final ChainedException _ex;

  const _FormattedChainedException(this._ex);

  String print({required StackTrace? trace}) {
    final buffer = StringBuffer();
    buffer.writeln();
    buffer.writeln('--------------------- Exception ---------------------');
    printTo(buffer, _ex, trace);
    buffer.writeln('-----------------------------------------------------');
    return buffer.toString();
  }

  void printTo(
    StringBuffer output,
    ChainedException ex,
    StackTrace? stackTrace, [
    int indent = 0,
  ]) {
    final prefix = '${'██' * indent} ';
    void printPrefixed(String str) => output.writeln('$prefix$str');

    ex._message().split('\n').forEach(printPrefixed);

    if (ex._vars.isNotEmpty) {
      final json = const JsonEncoder.withIndent('  ')
          .convert(ex._vars)
          .split('\n')
          .map((s) => s.endsWith('{') ? s.substring(0, s.length - 1) : s)
          .toList()
        ..removeWhere(
            (s) => s.trim() == '{' || s.trim() == '}' || s.trim() == '');

      printPrefixed('');
      printPrefixed('Vars:');
      json.forEach(printPrefixed);
    }

    final origin = ex._origin();
    if (origin.has()) {
      output.writeln();
      printTo(output, origin.get(), stackTrace, indent + 1);
    } else if (stackTrace != null) {
      output.writeln('Trace:');
      output.write(stackTrace);
    }
  }
}
