import 'package:enumerable/enumerable.dart';

void main(List<String> args) {
  final numbers = [0, 1, 2];
  print(numbers.sum());

  final fruits = ['banana', 'ananas', 'apple'];
  print(fruits.orderBy((e) => e.length).thenBy((e) => e));

  print(fruits.groupBy((e) => e[0]));

  print(fruits.select((e) => e.length));

  print(fruits.select((e) => e.length).distinct());
}
