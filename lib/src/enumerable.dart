part of '../enumerable.dart';

extension Enumerable<TSource> on Iterable<TSource> {
  TSource aggregate(TSource Function(TSource, TSource) func) {
    if (func == null) {
      throw ArgumentError.notNull("func");
    }

    var cond = false;
    TSource result;
    final it = iterator;
    while (it.moveNext()) {
      if (cond) {
        result = func(result, it.current);
      } else {
        result = it.current;
        cond = true;
      }
    }

    if (!cond) {
      throw _errorEmptySequence();
    }

    return result;
  }

  TAccumulate aggregate$1<TAccumulate>(
      TAccumulate seed, TAccumulate Function(TAccumulate, TSource) func) {
    if (func == null) {
      throw ArgumentError.notNull("func");
    }

    var acc = seed;
    final it = iterator;
    while (it.moveNext()) {
      acc = func(acc, it.current);
    }

    return acc;
  }

  TResult aggregate$2<TAccumulate, TResult>(
      TAccumulate seed,
      TAccumulate Function(TAccumulate, TSource) func,
      TResult Function(TAccumulate) resultSelector) {
    if (func == null) {
      throw ArgumentError.notNull("func");
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull("resultSelector");
    }

    var acc = seed;
    final it = iterator;
    while (it.moveNext()) {
      acc = func(acc, it.current);
    }

    return resultSelector(acc);
  }

  bool all(bool Function(TSource) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull("predicate");
    }

    final it = iterator;
    while (it.moveNext()) {
      if (!predicate(it.current)) {
        return false;
      }
    }

    return true;
  }

  bool any$([bool Function(TSource) predicate]) {
    if (predicate == null) {
      return iterator.moveNext();
    }

    final it = iterator;
    while (it.moveNext()) {
      if (predicate(it.current)) {
        return true;
      }
    }

    return false;
  }

  Iterable<TSource> append(TSource element) {
    Iterable<TSource> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        yield it.current;
      }

      yield element;
    }

    return generator();
  }

  double average([num Function(TSource) selector]) {
    if (this is! Iterable<num>) {
      _errorUnableToCompute<TSource>("average");
    }

    var count = 0;
    num sum;
    if (selector == null) {
      final it = iterator as Iterator<num>;
      while (it.moveNext()) {
        final current = it.current;
        if (current != null) {
          if (sum == null) {
            sum = current;
          }

          sum += current;
        }

        count++;
      }
    } else {
      final it = iterator;
      while (it.moveNext()) {
        final value = selector(it.current);
        if (value != null) {
          if (sum == null) {
            sum = value;
          }
          sum += value;
        }

        count++;
      }
    }

    if (count > 0 && sum != null) {
      return sum / count;
    }

    return sum as double;
  }

  Iterable<TResult> cast$<TResult>() {
    Iterable<TResult> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        yield it.current as TResult;
      }
    }

    return generator();
  }

  Iterable<TSource> concat(Iterable<TSource> other) {
    if (other == null) {
      throw ArgumentError.notNull("other");
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      while (it.moveNext()) {
        yield it.current;
      }

      it = other.iterator;
      while (it.moveNext()) {
        yield it.current;
      }
    }

    return generator();
  }

  bool contains$(TSource value, [IEqualityComparer<TSource> comparer]) {
    if (comparer == null) {
      comparer = EqualityComparer<TSource>();
    }

    final it = iterator;
    while (it.moveNext()) {
      if (comparer.equals(it.current, value)) {
        return true;
      }
    }

    return false;
  }

  int count([bool Function(TSource) predicate]) {
    var count = 0;
    if (predicate == null) {
      if (this is List<TSource>) {
        final list = this as List<TSource>;
        return list.length;
      }

      var it = iterator;
      while (it.moveNext()) {
        count++;
      }
    } else {
      final it = iterator;
      while (it.moveNext()) {
        if (predicate(it.current)) {
          count++;
        }
      }
    }

    return count;
  }

  Iterable<TSource> defaultIfEmpty([TSource defaultValue]) {
    Iterable<TSource> generator() sync* {
      var empty = true;
      final it = iterator;
      while (it.moveNext()) {
        empty = false;
        yield it.current;
      }

      if (empty) {
        yield defaultValue;
      }
    }

    return generator();
  }

  Iterable<TSource> distinct([IEqualityComparer<TSource> comparer]) {
    if (comparer == null) {
      comparer = EqualityComparer<TSource>();
    }

    Iterable<TSource> generator() sync* {
      final hashSet =
          HashSet(equals: comparer.equals, hashCode: comparer.getHashCode);
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (hashSet.add(current)) {
          yield current;
        }
      }
    }

    return generator();
  }

  TSource elementAt$(int index) {
    if (index == null) {
      throw ArgumentError.notNull("index");
    }

    if (index < 0) {
      throw RangeError.value(index, "index");
    }

    if (this is List<TSource>) {
      final list = this as List<TSource>;
      return list[index];
    }

    var counter = 0;
    final it = iterator;
    while (it.moveNext()) {
      if (counter++ == index) {
        return it.current;
      }
    }

    throw RangeError.range(index, 0, counter - 1);
  }

  TSource elementAtOrDefault(int index) {
    TSource result;
    if (index == null) {
      throw ArgumentError.notNull("index");
    }

    if (index < 0) {
      return result;
    }

    if (this is List<TSource>) {
      final list = this as List<TSource>;
      if (index + 1 > list.length) {
        return result;
      }

      return list[index];
    }

    var counter = 0;
    final it = iterator;
    while (it.moveNext()) {
      if (counter++ == index) {
        return it.current;
      }
    }

    return result;
  }

  Iterable<TSource> except(Iterable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw ArgumentError.notNull("other");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TSource>();
    }

    Iterable<TSource> generator() sync* {
      final hashSet = other.toHashSet(comparer);
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (!hashSet.contains(current)) {
          yield current;
        }
      }
    }

    return generator();
  }

  TSource first$([bool Function(TSource) predicate]) {
    final it = iterator;
    if (predicate == null) {
      if (it.moveNext()) {
        return it.current;
      }
    } else {
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          return current;
        }
      }
    }

    throw _errorEmptySequence();
  }

  TSource firstOrDefault([bool Function(TSource) predicate]) {
    TSource result;
    final it = iterator;
    if (predicate == null) {
      if (it.moveNext()) {
        return it.current;
      }
    } else {
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          return current;
        }
      }
    }

    return result;
  }

  Iterable<IGrouping<TKey, TSource>> groupBy<TKey>(
      TKey Function(TSource) keySelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull("keySelector");
    }

    IGrouping<TKey, TSource> resultSelector(
        TKey key, Iterable<TSource> elements) {
      return _Grouping(key, elements);
    }

    return groupBy$3<TKey, TSource, IGrouping<TKey, TSource>>(
        keySelector, (e) => e, resultSelector);
  }

  Iterable<IGrouping<TKey, TElement>> groupBy$1<TKey, TElement>(
      TKey Function(TSource) keySelector,
      TElement Function(TSource) elementSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull("keySelector");
    }

    if (elementSelector == null) {
      throw ArgumentError.notNull("elementSelector");
    }

    IGrouping<TKey, TElement> resultSelector(
        TKey key, Iterable<TElement> elements) {
      return _Grouping(key, elements);
    }

    return groupBy$3<TKey, TElement, IGrouping<TKey, TElement>>(
        keySelector, elementSelector, resultSelector);
  }

  Iterable<TResult> groupBy$2<TKey, TResult>(TKey Function(TSource) keySelector,
      TResult Function(TKey, Iterable<TSource>) resultSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (resultSelector == null) {
      throw ArgumentError.notNull("resultSelector");
    }

    return groupBy$3<TKey, TSource, TResult>(
        keySelector, (e) => e, resultSelector);
  }

  Iterable<TResult> groupBy$3<TKey, TElement, TResult>(
      TKey Function(TSource) keySelector,
      TElement Function(TSource) elementSelector,
      TResult Function(TKey, Iterable<TElement>) resultSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull("keySelector");
    }

    if (elementSelector == null) {
      throw ArgumentError.notNull("elementSelector");
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull("resultSelector");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TKey>();
    }

    Iterable<TResult> generator() sync* {
      final map = LinkedHashMap<TKey, List<TElement>>(
          equals: comparer.equals, hashCode: comparer.getHashCode);
      final it = iterator;
      while (it.moveNext()) {
        final value = it.current;
        final key = keySelector(value);
        final element = elementSelector(value);
        var elements = map[key];
        if (elements == null) {
          elements = <TElement>[];
          map[key] = elements;
        }

        elements.add(element);
      }

      for (final key in map.keys) {
        yield resultSelector(key, map[key]);
      }
    }

    return generator();
  }

  Iterable<TResult> groupJoin<TInner, TKey, TResult>(
      Iterable<TInner> inner,
      TKey Function(TSource) outerKeySelector,
      TKey Function(TInner) innerKeySelector,
      TResult Function(TSource, Iterable<TInner>) resultSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (inner == null) {
      throw ArgumentError.notNull("inner");
    }

    if (innerKeySelector == null) {
      throw ArgumentError.notNull("innerKeySelector");
    }

    if (outerKeySelector == null) {
      throw ArgumentError.notNull("outerKeySelector");
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull("resultSelector");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TKey>();
    }

    Iterable<TResult> generator() sync* {
      final dict = LinkedHashMap<TKey, List<TInner>>(
          equals: comparer.equals, hashCode: comparer.getHashCode);
      final it = inner.iterator;
      while (it.moveNext()) {
        final current = it.current;
        final key = innerKeySelector(current);
        var elements = dict[key];
        if (elements == null) {
          elements = <TInner>[];
          dict[key] = elements;
        }

        elements.add(current);
      }

      final it2 = iterator;
      while (it2.moveNext()) {
        final current = it2.current;
        final key = outerKeySelector(current);
        var innerValues = dict[key];
        if (innerValues == null) {
          innerValues = <TInner>[];
        }

        yield resultSelector(current, innerValues);
      }
    }

    return generator();
  }

  Iterable<TSource> intersect(Iterable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw ArgumentError.notNull("other");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TSource>();
    }

    Iterable<TSource> generator() sync* {
      final second = other.toHashSet(comparer);
      final output = HashSet<TSource>(
          equals: comparer.equals, hashCode: comparer.getHashCode);
      var it = second.iterator;
      while (it.moveNext()) {
        second.add(it.current);
      }

      it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (second.contains(current)) {
          if (output.add(current)) {
            yield current;
          }
        }
      }
    }

    return generator();
  }

  Iterable<TResult> join$<TInner, TKey, TResult>(
      Iterable<TInner> inner,
      TKey Function(TSource) outerKeySelector,
      TKey Function(TInner) innerKeySelector,
      TResult Function(TSource, TInner) resultSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (inner == null) {
      throw ArgumentError.notNull("inner");
    }

    if (innerKeySelector == null) {
      throw ArgumentError.notNull("innerKeySelector");
    }

    if (outerKeySelector == null) {
      throw ArgumentError.notNull("outerKeySelector");
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull("resultSelector");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TKey>();
    }

    Iterable<TResult> generator() sync* {
      final innerMap = LinkedHashMap<TKey, List<TInner>>(
          equals: comparer.equals, hashCode: comparer.getHashCode);
      final it = inner.iterator;
      while (it.moveNext()) {
        final innerValue = it.current;
        final key = innerKeySelector(innerValue);
        var elements = innerMap[key];
        if (elements == null) {
          elements = <TInner>[];
          innerMap[key] = elements;
        }

        elements.add(innerValue);
      }

      final it2 = iterator;
      while (it2.moveNext()) {
        final outerValue = it2.current;
        final key = outerKeySelector(outerValue);
        var innerValues = innerMap[key];
        if (innerValues != null) {
          for (final innerValue in innerValues) {
            yield resultSelector(outerValue, innerValue);
          }
        }
      }
    }

    return generator();
  }

  TSource last$([bool Function(TSource) predicate]) {
    final it = iterator;
    var length = 0;
    TSource result;
    if (predicate == null) {
      while (it.moveNext()) {
        length++;
        result = it.current;
      }
    } else {
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          length++;
          result = current;
        }
      }
    }

    if (length == 0) {
      throw _errorEmptySequence();
    }

    return result;
  }

  TSource lastOrDefault([bool Function(TSource) predicate]) {
    final it = iterator;
    TSource result;
    if (predicate == null) {
      while (it.moveNext()) {
        result = it.current;
      }
    } else {
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          result = current;
        }
      }
    }

    return result;
  }

  TSource max() {
    return (this as Iterable<num>).max$1<num>((e) => e) as TSource;
  }

  TResult max$1<TResult extends num>(TResult selector(TSource element)) {
    if (selector == null) {
      throw ArgumentError.notNull("selector");
    }

    return _computeNullable<TResult>("max", (r, v) => r < v ? v : r, selector);
  }

  TSource min() {
    return (this as Iterable<num>).min$1<num>((e) => e) as TSource;
  }

  TResult min$1<TResult extends num>(TResult selector(TSource element)) {
    return _computeNullable<TResult>("min", (r, v) => r > v ? v : r, selector);
  }

  Iterable<TResult> ofType<TResult>() {
    Iterable<TResult> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (current is TResult) {
          yield current;
        }
      }
    }

    return generator();
  }

  IOrderedIterable<TSource> orderBy<TKey>(TKey Function(TSource) keySelector,
      [IComparer<TKey> comparer]) {
    return _OrderedIterable<TSource, TKey>(
        this, keySelector, comparer, false, null);
  }

  IOrderedIterable<TSource> orderByDescending<TKey>(
      TKey Function(TSource) keySelector,
      [IComparer<TKey> comparer]) {
    return _OrderedIterable<TSource, TKey>(
        this, keySelector, comparer, true, null);
  }

  Iterable<TSource> prepend(TSource element) {
    Iterable<TSource> generator() sync* {
      yield element;
      final it = iterator;
      while (it.moveNext()) {
        yield it.current;
      }
    }

    return generator();
  }

  Iterable<TSource> reverse() {
    Iterable<TSource> generator() sync* {
      List<TSource> list;
      if (this is List<TSource>) {
        list = this as List<TSource>;
      } else {
        list = toList();
      }

      final length = list.length;
      for (var i = length - 1; i >= 0; i--) {
        yield list[i];
      }
    }

    return generator();
  }

  Iterable<TResult> select<TResult>(TResult Function(TSource) selector) {
    if (selector == null) {
      throw ArgumentError.notNull("selector");
    }

    Iterable<TResult> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        yield selector(it.current);
      }
    }

    return generator();
  }

  Iterable<TResult> select$1<TResult>(TResult Function(TSource, int) selector) {
    if (selector == null) {
      throw ArgumentError.notNull("selector");
    }

    Iterable<TResult> generator() sync* {
      var index = 0;
      final it = iterator;
      while (it.moveNext()) {
        yield selector(it.current, index++);
      }
    }

    return generator();
  }

  Iterable<TResult> selectMany<TResult>(
      Iterable<TResult> Function(TSource) selector) {
    if (selector == null) {
      throw ArgumentError.notNull("selector");
    }

    Iterable<TResult> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        final it2 = selector(current).iterator;
        while (it2.moveNext()) {
          yield it2.current;
        }
      }
    }

    return generator();
  }

  Iterable<TResult> selectMany$1<TResult>(
      Iterable<TResult> Function(TSource, int) selector) {
    if (selector == null) {
      throw ArgumentError.notNull("selector");
    }

    Iterable<TResult> generator() sync* {
      var index = 0;
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        final it2 = selector(current, index++).iterator;
        while (it2.moveNext()) {
          yield it2.current;
        }
      }
    }

    return generator();
  }

  Iterable<TResult> selectMany$2<TCollection, TResult>(
      Iterable<TCollection> Function(TSource) collectionSelector,
      TResult Function(TSource, TCollection) resultSelector) {
    if (collectionSelector == null) {
      throw ArgumentError.notNull("collectionSelector");
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull("resultSelector");
    }

    Iterable<TResult> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        final it2 = collectionSelector(current).iterator;
        while (it2.moveNext()) {
          yield resultSelector(current, it2.current);
        }
      }
    }

    return generator();
  }

  Iterable<TResult> selectMany$3<TCollection, TResult>(
      Iterable<TCollection> Function(TSource, int) collectionSelector,
      TResult Function(TSource, TCollection) resultSelector) {
    if (collectionSelector == null) {
      throw ArgumentError.notNull("collectionSelector");
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull("resultSelector");
    }

    Iterable<TResult> generator() sync* {
      var index = 0;
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        final it2 = collectionSelector(current, index++).iterator;
        while (it2.moveNext()) {
          yield resultSelector(current, it2.current);
        }
      }
    }

    return generator();
  }

  bool sequenceEqual(Iterable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw ArgumentError.notNull("other");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TSource>();
    }

    if (this is List && other is List) {
      final list1 = this as List;
      final list2 = other as List;
      if (list1.length != list2.length) {
        return false;
      }
    }

    final it1 = iterator;
    final it2 = other.iterator;
    while (true) {
      final moved1 = it1.moveNext();
      final moved2 = it2.moveNext();
      if (moved1 && moved2) {
        if (!comparer.equals(it1.current, it2.current)) {
          return false;
        }
      } else {
        if (moved1 != moved2) {
          return false;
        } else {
          break;
        }
      }
    }

    return true;
  }

  TSource single$([bool Function(TSource) predicate]) {
    TSource result;
    final it = iterator;
    if (predicate == null) {
      if (!it.moveNext()) {
        throw _errorEmptySequence();
      }

      result = it.current;
      if (it.moveNext()) {
        throw _errorMoreThanOneElement();
      }
    } else {
      var found = false;
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          if (found) {
            throw _errorMoreThanOneElement();
          }

          found = true;
          result = current;
        }
      }

      if (!found) {
        throw _errorEmptySequence();
      }
    }

    return result;
  }

  TSource singleOrDefault([bool Function(TSource) predicate]) {
    TSource result;
    final it = iterator;
    if (predicate == null) {
      if (!it.moveNext()) {
        return result;
      }

      result = it.current;
      if (it.moveNext()) {
        throw _errorMoreThanOneElement();
      }
    } else {
      var found = false;
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          if (found) {
            throw _errorMoreThanOneElement();
          }

          found = true;
          result = current;
        }
      }

      if (!found) {
        return result;
      }
    }

    return result;
  }

  Iterable<TSource> skip(int count) {
    if (count == null) {
      throw ArgumentError.notNull("count");
    }

    Iterable<TSource> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        if (count-- <= 0) {
          yield it.current;
          break;
        }
      }

      while (it.moveNext()) {
        yield it.current;
      }
    }

    return generator();
  }

  Iterable<TSource> skipWhile(bool Function(TSource) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (!predicate(current)) {
          yield current;
          break;
        }
      }

      while (it.moveNext()) {
        yield it.current;
      }
    }

    return generator();
  }

  Iterable<TSource> skipWhile$1(bool Function(TSource, int) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var index = 0;
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (!predicate(current, index++)) {
          yield current;
          break;
        }
      }

      while (it.moveNext()) {
        yield it.current;
      }
    }

    return generator();
  }

  TSource sum() {
    return (this as Iterable<num>).sum$1<num>((e) => e) as TSource;
  }

  TResult sum$1<TResult extends num>(TResult selector(TSource element)) {
    return _computeNullable<TResult>("sum", (r, v) => r + v, selector);
  }

  Iterable<TSource> take$(int count) {
    if (count == null) {
      throw ArgumentError.notNull("count");
    }

    Iterable<TSource> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        if (count-- > 0) {
          yield it.current;
        } else {
          break;
        }
      }
    }

    return generator();
  }

  Iterable<TSource> takeWhile$(bool Function(TSource) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        if (predicate(it.current)) {
          yield it.current;
        } else {
          break;
        }
      }
    }

    return generator();
  }

  Iterable<TSource> takeWhile$1(bool Function(TSource, int) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var index = 0;
      final it = iterator;
      while (it.moveNext()) {
        if (predicate(it.current, index++)) {
          yield it.current;
        } else {
          break;
        }
      }
    }

    return generator();
  }

  Map<TKey, TSource> toMap<TKey>(TKey Function(TSource) keySelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull("keySelector");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TKey>();
    }

    final result = LinkedHashMap<TKey, TSource>(
        equals: comparer.equals, hashCode: comparer.getHashCode);
    final it = iterator;
    while (it.moveNext()) {
      final current = it.current;
      final key = keySelector(current);
      result[key] = current;
    }

    return result;
  }

  Map<TKey, TElement> toMap$1<TKey, TElement>(
      TKey Function(TSource) keySelector,
      TElement Function(TSource) elementSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull("keySelector");
    }

    if (elementSelector == null) {
      throw ArgumentError.notNull("elementSelector");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TKey>();
    }

    final result = LinkedHashMap<TKey, TElement>(
        equals: comparer.equals, hashCode: comparer.getHashCode);
    final it = iterator;
    while (it.moveNext()) {
      final current = it.current;
      final key = keySelector(current);
      result[key] = elementSelector(current);
    }

    return result;
  }

  HashSet<TSource> toHashSet([IEqualityComparer<TSource> comparer]) {
    if (comparer == null) {
      comparer = EqualityComparer<TSource>();
    }

    final result = HashSet<TSource>(
        equals: comparer.equals, hashCode: comparer.getHashCode);
    result.addAll(this);
    return result;
  }

  Lookup<TKey, TSource> toLookup<TKey>(TKey Function(TSource) keySelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull("keySelector");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TKey>();
    }

    final dict = LinkedHashMap<TKey, IGrouping<TKey, TSource>>(
        equals: comparer.equals, hashCode: comparer.getHashCode);
    final it = groupBy<TKey>(keySelector, comparer).iterator;
    while (it.moveNext()) {
      final current = it.current;
      dict[current.key] = current;
    }

    return Lookup<TKey, TSource>._internal(dict);
  }

  Lookup<TKey, TElement> toLookup$1<TKey, TElement>(
      TKey Function(TSource) keySelector,
      TElement Function(TSource) elementSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull("keySelector");
    }

    if (elementSelector == null) {
      throw ArgumentError.notNull("elementSelector");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TKey>();
    }

    final dict = LinkedHashMap<TKey, IGrouping<TKey, TElement>>(
        equals: comparer.equals, hashCode: comparer.getHashCode);
    final it = groupBy$1<TKey, TElement>(keySelector, elementSelector, comparer)
        .iterator;
    while (it.moveNext()) {
      final current = it.current;
      dict[current.key] = current;
    }

    return Lookup<TKey, TElement>._internal(dict);
  }

  Iterable<TSource> union(Iterable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw ArgumentError.notNull("other");
    }

    if (comparer == null) {
      comparer = EqualityComparer<TSource>();
    }

    Iterable<TSource> generator() sync* {
      var it = iterator;
      final hashSet =
          HashSet(equals: comparer.equals, hashCode: comparer.getHashCode);
      while (it.moveNext()) {
        final current = it.current;
        if (hashSet.add(current)) {
          yield current;
        }
      }

      it = other.iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (hashSet.add(current)) {
          yield current;
        }
      }
    }

    return generator();
  }

  Iterable<TSource> where$(bool Function(TSource) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current)) {
          yield current;
        }
      }
    }

    return generator();
  }

  Iterable<TSource> whereEx$1(bool Function(TSource, int) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull("predicate");
    }

    Iterable<TSource> generator() sync* {
      var index = 0;
      final it = iterator;
      while (it.moveNext()) {
        final current = it.current;
        if (predicate(current, index++)) {
          yield current;
        }
      }
    }

    return generator();
  }

  Iterable zip<TSecond, TResult>(Iterable<TSecond> second,
      TResult Function(TSource, TSecond) resultSelector) {
    if (second == null) {
      throw ArgumentError.notNull("second");
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull("resultSelector");
    }

    Iterable<TResult> generator() sync* {
      final it1 = iterator;
      final it2 = second.iterator;
      while (it1.moveNext() && it2.moveNext()) {
        yield resultSelector(it1.current, it2.current);
      }
    }

    return generator();
  }

  TResult _computeNullable<TResult extends num>(
      String name,
      TResult Function(TResult, TResult) func,
      TResult selector(TSource element)) {
    TResult result;
    var first = true;
    final it = iterator;
    while (it.moveNext()) {
      final current = it.current;
      if (current == null) {
        continue;
      }

      final value = selector(current);
      if (result == null) {
        result = value;
      }

      if (value != null) {
        if (!first) {
          result = func(result, value);
        } else {
          first = false;
        }
      }
    }

    return result;
  }

  StateError _errorEmptySequence() {
    return StateError("Sequence contains no elements");
  }

  StateError _errorMoreThanOneElement() {
    return StateError("Sequence contains more than one element");
  }

  StateError _errorUnableToCompute<TResult>(String operation) {
    return StateError("Unable to compute '$operation' of '$TResult' values");
  }
}
