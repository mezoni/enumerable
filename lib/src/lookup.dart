part of '../enumerable.dart';

abstract class ILookup<TKey, TElement>
    implements Iterable<IGrouping<TKey, TElement>> {
  int get length;

  Iterable<TElement> operator [](TKey key);

  bool containsKey(TKey key);
}

class Lookup<TKey, TElement> extends Iterable<IGrouping<TKey, TElement>>
    implements ILookup<TKey, TElement> {
  IGrouping<TKey, TElement> _current;

  Map<TKey, IGrouping<TKey, TElement>> _groupings;

  Lookup._internal(this._groupings);

  IGrouping<TKey, TElement> get current {
    return _current;
  }

  Iterator<IGrouping<TKey, TElement>> get iterator {
    return _groupings.values.iterator;
  }

  int get length {
    return _groupings.length;
  }

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
      throw ArgumentError.notNull("resultSelector");
    }

    return select<TResult>((g) => resultSelector(g.key, g));
  }

  bool containsKey(TKey key) {
    return _groupings.containsKey(key);
  }
}
