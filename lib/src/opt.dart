import 'exception/chained_exception.dart';

/// A container object which may or may not contain a non-null value
///
abstract class Opt<T extends Object> {
  @Deprecated('Use None')
  const factory Opt.empty() = None;
  @Deprecated('Use Some')
  const factory Opt.value(T value) = Some;

  factory Opt.any(T? value) => value == null ? None<T>() : Some(value);

  bool has();
  T get();
  T? nullable();
  T valueOrDefault(T def);

  /// If this opt contains value, returns Opt with mapped value.
  ///
  /// If this opt contains no value, returns casted Opt withoud value
  /// and mapper function is not called.
  ///
  /// Does not change context i.e. `Some.map() -> Some`, `None.map() -> None()`
  Opt<U> map<U extends Object>(U Function(T) mapper);

  /// If this opt contains value, returns binded Opt.
  ///
  /// If this opt contains no value, returns casted Opt withoud value
  /// and binder function is not called.
  ///
  /// Can change context from Some to None, i.e. `Some.bind() -> Some/None`, `None.bind() -> None`
  Opt<U> bind<U extends Object>(Opt<U> Function(T) binder);
}

extension OptionalObjectX<T extends Object> on T? {
  Opt<T> asOpt() => Opt<T>.any(this);
}

class None<T extends Object> implements Opt<T> {
  const None();

  @override
  bool has() => false;

  @override
  Never get() => throw const ChainedException.origin(
        'Opt.get() has been called without verifying that Opt.has() returned true!',
      );

  @override
  T? nullable() => null;

  @override
  T valueOrDefault(T def) => def;

  @override
  None<U> map<U extends Object>(U Function(T p1) mapper) => None<U>();

  @override
  None<U> bind<U extends Object>(Opt<U> Function(T p1) binder) => None<U>();
}

class Some<T extends Object> implements Opt<T> {
  final T _value;
  const Some(this._value);

  @override
  bool has() => true;

  @override
  T get() => _value;

  @override
  T? nullable() => _value;

  @override
  T valueOrDefault(T def) => _value;

  @override
  Some<U> map<U extends Object>(U Function(T p1) mapper) => Some(mapper(get()));

  @override
  Opt<U> bind<U extends Object>(Opt<U> Function(T p1) binder) => binder(get());
}
