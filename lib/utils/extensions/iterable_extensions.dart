part of 'extensions.dart';

extension IterableX<T> on Iterable<T> {
  /// Returns a new iterable with the elements of this iterable that are not in [other].
  Iterable<T> difference(Iterable<T> other) {
    final otherSet = other.toSet();
    return where((element) => !otherSet.contains(element));
  }

  /// Returns a new iterable with the elements of this iterable that are in [other].
  Iterable<T> intersection(Iterable<T> other) {
    final otherSet = other.toSet();
    return where((element) => otherSet.contains(element));
  }

  /// Returns a new [Set] containing all elements of the original iterable,
  /// with the specified [element] toggled:
  /// - If [element] is present, it will be removed.
  /// - If [element] is absent, it will be added.
  ///
  /// This method does not modify the original iterable.
  ///
  /// Example:
  /// ```dart
  /// final list = [1, 2, 3];
  /// final toggled = list.toggle(2); // {1, 3}
  /// final toggledAgain = list.toggle(4); // {1, 2, 3, 4}
  /// ```
  Set<T> toggle(T element) {
    final set_ = toSet();
    if (set_.contains(element)) {
      set_.remove(element);
    } else {
      set_.add(element);
    }

    if (this is Set<T>) {
      return set_;
    } else {
      return set_.toSet();
    }
  }
}
