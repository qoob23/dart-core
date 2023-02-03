import 'dart:convert';

import 'package:dart_core/dart_core.dart';

part 'formatted_exception.dart';

abstract class ChainedException implements Exception {
  final Map<String, dynamic> _vars;
  const ChainedException._(this._vars);

  /// Creates origin exception
  const factory ChainedException.origin(
    String message, {
    Map<String, dynamic> vars,
  }) = _ChainedOrigin;

  /// Creates origin from exception from other library
  const factory ChainedException.foreign(
    Object foreignException,
    String context, {
    Map<String, dynamic> vars,
  }) = _ForeignOrigin;

  /// Adds context to previous exception
  const factory ChainedException.context(
    ChainedException origin,
    String context, {
    Map<String, dynamic> vars,
  }) = _ChainedContext;

  @nonVirtual
  String print(StackTrace stackTrace) =>
      _FormattedChainedException(this).print(trace: stackTrace);

  @override
  @Deprecated('Use print')
  String toString() => _FormattedChainedException(this).print(trace: null);

  /// Original exception
  Opt<ChainedException> _origin();

  /// Problem or context
  String _message();
}

class _ChainedOrigin extends ChainedException {
  final String _msg;
  const _ChainedOrigin(this._msg, {Map<String, dynamic> vars = const {}})
      : super._(vars);

  @override
  String _message() => _msg;

  @override
  Opt<ChainedException> _origin() => None();
}

class _ForeignOrigin extends ChainedException {
  final Object _foreignException;
  final String _context;
  const _ForeignOrigin(
    this._foreignException,
    this._context, {
    Map<String, dynamic> vars = const {},
  }) : super._(vars);

  @override
  String _message() => '''
$_context

Original exception:
$_foreignException''';

  @override
  @alwaysThrows
  Opt<ChainedException> _origin() => None();
}

class _ChainedContext extends ChainedException {
  final ChainedException _originException;
  final String _context;
  const _ChainedContext(
    this._originException,
    this._context, {
    Map<String, dynamic> vars = const {},
  }) : super._(vars);

  @override
  String _message() => _context;

  @override
  Opt<ChainedException> _origin() => Some(_originException);
}
