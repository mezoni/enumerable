part of '../enumerable.dart';

extension Enumerable<TSource> on Iterable<TSource> {
  /// Applies an accumulator function over a sequence.
  TSource aggregate(TSource Function(TSource, TSource) func) {
    if (func == null) {
      throw ArgumentError.notNull('func');
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

  /// Applies an accumulator function over a sequence. The specified seed value
  /// is used as the initial accumulator value.
  TAccumulate aggregate$1<TAccumulate>(
      TAccumulate seed, TAccumulate Function(TAccumulate, TSource) func) {
    if (func == null) {
      throw ArgumentError.notNull('func');
    }

    var acc = seed;
    final it = iterator;
    while (it.moveNext()) {
      acc = func(acc, it.current);
    }

    return acc;
  }

  /// Applies an accumulator function over a sequence. The specified seed value
  /// is used as the initial accumulator value, and the specified function is
  /// used to select the result value.
  TResult aggregate$2<TAccumulate, TResult>(
      TAccumulate seed,
      TAccumulate Function(TAccumulate, TSource) func,
      TResult Function(TAccumulate) resultSelector) {
    if (func == null) {
      throw ArgumentError.notNull('func');
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
    }

    var acc = seed;
    final it = iterator;
    while (it.moveNext()) {
      acc = func(acc, it.current);
    }

    return resultSelector(acc);
  }

  /// Determines whether all elements of a sequence satisfy a condition.
  bool all(bool Function(TSource) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull('predicate');
    }

    final it = iterator;
    while (it.moveNext()) {
      if (!predicate(it.current)) {
        return false;
      }
    }

    return true;
  }

  /// Determines whether a sequence contains any elements.
  /// Or determines whether any element of a sequence satisfies a condition if
  /// predicate was specified.
  bool any$1([bool Function(TSource) predicate]) {
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

  /// Appends a value to the end of the sequence.
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

  ///	Computes the average of a sequence.
  double average([num Function(TSource) selector]) {
    if (this is! Iterable<num>) {
      _errorUnableToCompute<TSource>('average');
    }

    var count = 0;
    num sum;
    if (selector == null) {
      final it = iterator as Iterator<num>;
      while (it.moveNext()) {
        final current = it.current;
        if (current != null) {
          sum ??= current;
          sum += current;
        }

        count++;
      }
    } else {
      final it = iterator;
      while (it.moveNext()) {
        final value = selector(it.current);
        if (value != null) {
          sum ??= value;
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

  /// Casts the elements to the specified type.
  Iterable<TResult> cast$1<TResult>() {
    Iterable<TResult> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        yield it.current as TResult;
      }
    }

    return generator();
  }

  /// Concatenates two sequences.
  Iterable<TSource> concat(Iterable<TSource> other) {
    if (other == null) {
      throw ArgumentError.notNull('other');
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

  /// Determines whether a sequence contains a specified element by using the
  /// default equality comparer.
  /// Or determines whether a sequence contains a specified element by using a
  /// specified IEqualityComparer<T>.
  bool contains$1(TSource value, [IEqualityComparer<TSource> comparer]) {
    comparer ??= EqualityComparer<TSource>();
    final it = iterator;
    while (it.moveNext()) {
      if (comparer.equals(it.current, value)) {
        return true;
      }
    }

    return false;
  }

  /// Returns the number of elements in a sequence.
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

  /// Returns the elements of an Iterable<T>, or a default valued collection if
  /// the sequence is empty.
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

  /// Returns distinct elements from a sequence.
  Iterable<TSource> distinct([IEqualityComparer<TSource> comparer]) {
    comparer ??= EqualityComparer<TSource>();
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

  /// Returns the element at a specified index in a sequence.
  TSource elementAt$1(int index) {
    if (index == null) {
      throw ArgumentError.notNull('index');
    }

    if (index < 0) {
      throw RangeError.value(index, 'index');
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

  /// Returns the element at a specified index in a sequence or a default value
  /// if the index is out of range.
  TSource elementAtOrDefault(int index) {
    TSource result;
    if (index == null) {
      throw ArgumentError.notNull('index');
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

  /// Produces the set difference of two sequences.
  Iterable<TSource> except(Iterable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw ArgumentError.notNull('other');
    }

    comparer ??= EqualityComparer<TSource>();
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

  /// Returns the first element of a sequence.
  TSource first$1([bool Function(TSource) predicate]) {
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

  /// Returns the first element of a sequence, or a default value if the
  /// sequence contains no elements.
  /// Or returns the first element of the sequence that satisfies a condition
  /// or a default value if no such element is found if predicate was
  /// specified.
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
      throw ArgumentError.notNull('keySelector');
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
      throw ArgumentError.notNull('keySelector');
    }

    if (elementSelector == null) {
      throw ArgumentError.notNull('elementSelector');
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
      throw ArgumentError.notNull('resultSelector');
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
      throw ArgumentError.notNull('keySelector');
    }

    if (elementSelector == null) {
      throw ArgumentError.notNull('elementSelector');
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
    }

    comparer ??= EqualityComparer<TKey>();
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

  /// Correlates the elements of two sequences based on equality of keys and
  /// groups the results.
  Iterable<TResult> groupJoin<TInner, TKey, TResult>(
      Iterable<TInner> inner,
      TKey Function(TSource) outerKeySelector,
      TKey Function(TInner) innerKeySelector,
      TResult Function(TSource, Iterable<TInner>) resultSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (inner == null) {
      throw ArgumentError.notNull('inner');
    }

    if (innerKeySelector == null) {
      throw ArgumentError.notNull('innerKeySelector');
    }

    if (outerKeySelector == null) {
      throw ArgumentError.notNull('outerKeySelector');
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
    }

    comparer ??= EqualityComparer<TKey>();
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
        innerValues ??= <TInner>[];
        yield resultSelector(current, innerValues);
      }
    }

    return generator();
  }

  /// Produces the set intersection of two sequences.
  Iterable<TSource> intersect(Iterable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw ArgumentError.notNull('other');
    }

    comparer ??= EqualityComparer<TSource>();
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

  /// Correlates the elements of two sequences based on matching keys.
  Iterable<TResult> join$1<TInner, TKey, TResult>(
      Iterable<TInner> inner,
      TKey Function(TSource) outerKeySelector,
      TKey Function(TInner) innerKeySelector,
      TResult Function(TSource, TInner) resultSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (inner == null) {
      throw ArgumentError.notNull('inner');
    }

    if (innerKeySelector == null) {
      throw ArgumentError.notNull('innerKeySelector');
    }

    if (outerKeySelector == null) {
      throw ArgumentError.notNull('outerKeySelector');
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
    }

    comparer ??= EqualityComparer<TKey>();
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

  /// Returns the last element of a sequence.
  /// Or returns the last element of a sequence that satisfies a specified
  /// condition if predicate was specified.
  TSource last$1([bool Function(TSource) predicate]) {
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

  /// Returns the last element of a sequence, or a default value if the
  /// sequence contains no elements.
  /// Or returns the last element of a sequence that satisfies a condition or a
  /// default value if no such element is found if predicate was specified.
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

  /// Returns the maximum value in a sequence of values.
  TSource max() {
    return (this as Iterable<num>).max$1<num>((e) => e) as TSource;
  }

  /// Invokes a transform function on each element of a sequence and returns
  /// the maximum value.
  TResult max$1<TResult extends num>(TResult Function(TSource) selector) {
    if (selector == null) {
      throw ArgumentError.notNull('selector');
    }

    return _computeNullable<TResult>('max', (r, v) => r < v ? v : r, selector);
  }

  /// Returns the minimum value in a sequence of values.
  TSource min() {
    return (this as Iterable<num>).min$1<num>((e) => e) as TSource;
  }

  /// Invokes a transform function on each element of a sequence and returns
  /// the minimum value.
  TResult min$1<TResult extends num>(TResult Function(TSource) selector) {
    return _computeNullable<TResult>('min', (r, v) => r > v ? v : r, selector);
  }

  /// Filters the elements of an Iterable<T> based on a specified type.
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

  /// Sorts the elements of a sequence in ascending order according to a key.
  IOrderedIterable<TSource> orderBy<TKey>(TKey Function(TSource) keySelector,
      [IComparer<TKey> comparer]) {
    return _OrderedIterable<TSource, TKey>(
        this, keySelector, comparer, false, null);
  }

  /// Sorts the elements of a sequence in ascending order according to a key.
  IOrderedIterable<TSource> orderByDescending<TKey>(
      TKey Function(TSource) keySelector,
      [IComparer<TKey> comparer]) {
    return _OrderedIterable<TSource, TKey>(
        this, keySelector, comparer, true, null);
  }

  /// Adds a value to the beginning of the sequence.
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

  /// Inverts the order of the elements in a sequence.
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

  /// Projects each element of a sequence into a new form.
  Iterable<TResult> select<TResult>(TResult Function(TSource) selector) {
    if (selector == null) {
      throw ArgumentError.notNull('selector');
    }

    Iterable<TResult> generator() sync* {
      final it = iterator;
      while (it.moveNext()) {
        yield selector(it.current);
      }
    }

    return generator();
  }

  /// Projects each element of a sequence into a new form by incorporating the
  /// element's index.
  Iterable<TResult> select$1<TResult>(TResult Function(TSource, int) selector) {
    if (selector == null) {
      throw ArgumentError.notNull('selector');
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
      throw ArgumentError.notNull('selector');
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
      throw ArgumentError.notNull('selector');
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
      throw ArgumentError.notNull('collectionSelector');
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
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
      throw ArgumentError.notNull('collectionSelector');
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
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

  /// Determines whether two sequences are equal by comparing the elements.
  bool sequenceEqual(Iterable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw ArgumentError.notNull('other');
    }

    comparer ??= EqualityComparer<TSource>();
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

  /// Returns the only element of a sequence, and throws an exception if there
  /// is not exactly one element in the sequence.
  /// Or returns the only element of a sequence that satisfies a specified
  /// condition, and throws an exception if more than one such element exists
  /// if predicate was specified.
  TSource single$1([bool Function(TSource) predicate]) {
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

  /// Returns the only element of a sequence, or a default value if the
  /// sequence is empty; this method throws an exception if there is more than
  /// one element in the sequence.
  /// Or returns the only element of a sequence that satisfies a specified
  /// condition or a default value if no such element exists; this method
  /// throws an exception if more than one element satisfies the condition if
  /// predicate was specified.
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

  /// Returns a new enumerable collection that contains the elements from
  /// source with the last count elements of the source collection omitted.
  Iterable<TSource> skipLast(int count) {
    if (count == null) {
      throw ArgumentError.notNull('count');
    }

    count = _math.max(0, count);
    return take$1(_math.max(0, length - count));
  }

  /// Bypasses a specified number of elements in a sequence and then returns
  /// the remaining elements.
  Iterable<TSource> skip$1(int count) {
    if (count == null) {
      throw ArgumentError.notNull('count');
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

  /// Bypasses elements in a sequence as long as a specified condition is true
  /// and then returns the remaining elements.
  Iterable<TSource> skipWhile$1(bool Function(TSource) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull('predicate');
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

  /// Bypasses elements in a sequence as long as a specified condition is true
  /// nd then returns the remaining elements. The element's index is used in
  /// the logic of the predicate function.
  Iterable<TSource> skipWhile$2(bool Function(TSource, int) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull('predicate');
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

  /// Computes the sum of a sequence of values.
  TSource sum() {
    return (this as Iterable<num>).sum$1<num>((e) => e) as TSource;
  }

  /// Computes the sum of the sequence of values that are obtained by invoking
  /// a transform function on each element of the input sequence.
  TResult sum$1<TResult extends num>(TResult Function(TSource) selector) {
    return _computeNullable<TResult>('sum', (r, v) => r + v, selector);
  }

  /// Returns a specified number of contiguous elements from the start of a
  /// sequence.
  Iterable<TSource> take$1(int count) {
    if (count == null) {
      throw ArgumentError.notNull('count');
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

  /// Returns a new enumerable collection that contains the last count elements
  /// from source.
  Iterable<TSource> takeLast(int count) {
    if (count == null) {
      throw ArgumentError.notNull('count');
    }

    return skip$1(_math.max(0, length - count));
  }

  /// Returns elements from a sequence as long as a specified condition is
  /// true.
  Iterable<TSource> takeWhile$1(bool Function(TSource) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull('predicate');
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

  /// Returns elements from a sequence as long as a specified condition is
  /// true. The element's index is used in the logic of the predicate function.
  Iterable<TSource> takeWhile$2(bool Function(TSource, int) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull('predicate');
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

  /// Creates a Map<T> from an Iterable<T>.
  Map<TKey, TSource> toMap<TKey>(TKey Function(TSource) keySelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull('keySelector');
    }

    comparer ??= EqualityComparer<TKey>();
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

  /// Creates a Set<T> from an Iterable<T>.
  HashSet<TSource> toHashSet([IEqualityComparer<TSource> comparer]) {
    comparer ??= EqualityComparer<TSource>();
    final result = HashSet<TSource>(
        equals: comparer.equals, hashCode: comparer.getHashCode);
    result.addAll(this);
    return result;
  }

  /// Creates a Lookup<T> from an Iterable<T>.
  Lookup<TKey, TSource> toLookup<TKey>(TKey Function(TSource) keySelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull('keySelector');
    }

    comparer ??= EqualityComparer<TKey>();
    final dict = LinkedHashMap<TKey, IGrouping<TKey, TSource>>(
        equals: comparer.equals, hashCode: comparer.getHashCode);
    final it = groupBy<TKey>(keySelector, comparer).iterator;
    while (it.moveNext()) {
      final current = it.current;
      dict[current.key] = current;
    }

    return Lookup<TKey, TSource>._internal(dict);
  }

  /// Creates a Lookup<T> from an Iterable<T>.
  Lookup<TKey, TElement> toLookup$1<TKey, TElement>(
      TKey Function(TSource) keySelector,
      TElement Function(TSource) elementSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull('keySelector');
    }

    if (elementSelector == null) {
      throw ArgumentError.notNull('elementSelector');
    }

    comparer ??= EqualityComparer<TKey>();
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

  /// Creates a Map<T> from an Iterable<T>.
  Map<TKey, TElement> toMap$1<TKey, TElement>(
      TKey Function(TSource) keySelector,
      TElement Function(TSource) elementSelector,
      [IEqualityComparer<TKey> comparer]) {
    if (keySelector == null) {
      throw ArgumentError.notNull('keySelector');
    }

    if (elementSelector == null) {
      throw ArgumentError.notNull('elementSelector');
    }

    comparer ??= EqualityComparer<TKey>();
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

  /// Produces the set union of two sequences.
  Iterable<TSource> union(Iterable<TSource> other,
      [IEqualityComparer<TSource> comparer]) {
    if (other == null) {
      throw ArgumentError.notNull('other');
    }

    comparer ??= EqualityComparer<TSource>();
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

  /// Filters a sequence of values based on a predicate.
  Iterable<TSource> where$1(bool Function(TSource) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull('predicate');
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

  /// Filters a sequence of values based on a predicate. Each element's index
  /// is used in the logic of the predicate function.
  Iterable<TSource> where$2(bool Function(TSource, int) predicate) {
    if (predicate == null) {
      throw ArgumentError.notNull('predicate');
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

  /// Applies a specified function to the corresponding elements of two
  /// sequences, producing a sequence of the results.
  Iterable zip<TSecond, TResult>(Iterable<TSecond> second,
      TResult Function(TSource, TSecond) resultSelector) {
    if (second == null) {
      throw ArgumentError.notNull('second');
    }

    if (resultSelector == null) {
      throw ArgumentError.notNull('resultSelector');
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
      TResult Function(TSource) selector) {
    TResult result;
    var first = true;
    final it = iterator;
    while (it.moveNext()) {
      final current = it.current;
      if (current == null) {
        continue;
      }

      final value = selector(current);
      result ??= value;
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
    return StateError('Sequence contains no elements');
  }

  StateError _errorMoreThanOneElement() {
    return StateError('Sequence contains more than one element');
  }

  StateError _errorUnableToCompute<TResult>(String operation) {
    return StateError("Unable to compute '$operation' of '$TResult' values");
  }
}
