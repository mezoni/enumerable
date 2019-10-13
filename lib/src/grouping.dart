part of '../enumerable.dart';

abstract class IGrouping<TKey, TElement> implements Iterable<TElement> {
  TKey get key;
}

class _Grouping<TKey, TElement> extends Iterable<TElement>
    implements IGrouping<TKey, TElement> {
  Iterable<TElement> _elements;

  TKey _key;

  _Grouping(TKey key, this._elements) {
    _key = key;
  }

  Iterator<TElement> get iterator {
    return _elements.iterator;
  }

  TKey get key => _key;
}
