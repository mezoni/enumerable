part of '../enumerable.dart';

abstract class ILookup<TKey, TElement>
    implements Iterable<IGrouping<TKey, TElement>> {
  @override
  int get length;

  Iterable<TElement> operator [](TKey key);

  bool containsKey(TKey key);
}

class Lookup<TKey, TElement> extends Iterable<IGrouping<TKey, TElement>>
    implements ILookup<TKey, TElement> {
  IGrouping<TKey, TElement> _current;

  final Map<TKey, IGrouping<TKey, TElement>> _groupings;

  Lookup._internal(this._groupings);

  IGrouping<TKey, TElement> get current {
    return _current;
  }

  @override
  Iterator<IGrouping<TKey, TElement>> get iterator {
    return _groupings.values.iterator;
  }

  @override
  int get length {
    return _groupings.length;
  }

  @override
  Iterable<TElement> operator [](TKey key) {
    var grouping = _groupings[key];
    if (grouping != null) {
      return grouping;
    }

    return <TElement>[];
  }

  Iterable<TResult> applyResultSelector<TResult>(
      TResult Function(TKey, Iterable<TElement>) resultSelector) {
    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
    }

    return select<TResult>((g) => resultSelector(g.key, g));
  }

  @override
  bool containsKey(TKey key) {
    return _groupings.containsKey(key);
  }
}
