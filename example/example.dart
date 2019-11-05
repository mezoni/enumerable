import 'package:enumerable/enumerable.dart';

void main(List<String> args) {
  final numbers1 = [0, 1, 2, 1, 0];
  final numbers2 = [1, 2, 3, 2, 1];
  final alphanums = ['one', 1, 'two', 2];
  print(pets.select((p) => p.age).aggregate((a, v) => a + v));
  print(pets.all((p) => p.age < 5));
  print(numbers1.append(3));
  print(pets.any((p) => p.age > 2));
  print(pets.average((p) => p.age));
  print(pets.concat([Pet("xyz", 99)]));
  print(pets.contains(pets.elementAtOrDefault(2)));
  print(pets.count((p) => p.age < 2));
  print(pets.defaultIfEmpty());
  print(pets.select((p) => p.age).distinct());
  print(pets.elementAt$1(1));
  print(pets.elementAtOrDefault(10));
  print(pets.except(pets.where((p) => p.age == 1)));
  print(pets.first$1((p) => p.age > 1));
  print(pets.firstOrDefault((p) => p.age > 4));
  print(pets.groupBy((p) => p.owner));
  print(petOwners.groupJoin(pets, (o) => o, (i) => i.owner, (o, i) => [o, i]));
  print(numbers1.intersect(numbers2));
  print(petOwners.join$1(pets, (o) => o, (i) => i.owner, (o, i) => [o, i]));
  print(pets.last$1((p) => p.age == 1));
  print(pets.lastOrDefault((p) => p.age > 4));
  print(pets.max$1((p) => p.age));
  print(pets.min$1((p) => p.age));
  print(alphanums.ofType<String>());
  print(pets.orderBy((p) => p.age));
  print(pets.orderByDescending((p) => p.age));
  print(numbers1.prepend(-1));
  print(pets.select((p) => p.name));
  print(petOwners.selectMany((p) => p.pets));
  print(numbers1.sequenceEqual(numbers2));
  print(alphanums.single$1((e) => e == 1));
  print(alphanums.singleOrDefault((e) => e == 3));
  print(alphanums.skip$1(2));
  print(numbers1.skipWhile$1((e) => e < 2));
  print(numbers1.sum());
  print(alphanums.take$1(2));
  print(numbers1.takeWhile$1((e) => e < 2));
  print(pets.toLookup((p) => p.owner));
  print(numbers1.union(numbers2));
  print(numbers1.where$1((e) => e != 0));
  print([0, 1, 2].zip(['one', 'two', 'three'], (x, y) => [x, y]));
  print(pets.orderByDescending((p) => p.age).thenBy((p) => p.name));
}

final petOwners = [
  PetOwner("a")..pets = [Pet("a1", 1)],
  PetOwner("b")..pets = [Pet("b1", 1), Pet("b2", 2)],
  PetOwner("c")..pets = [Pet("c1", 1), Pet("c2", 2), Pet("c3", 3)],
]..toList().forEach((petOwner) {
    for (final pet in petOwner.pets) {
      pet.owner = petOwner;
    }
  });

final pets = petOwners.selectMany((e) => e.pets);

class Person {
  int age;

  String firstName;

  String lastName;
}

class Pet {
  int age;

  String name;

  PetOwner owner;

  Pet(this.name, this.age);

  String toString() => name;

  operator ==(other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Pet) {
      return other.name == name && other.age == age;
    }

    return false;
  }
}

class PetOwner {
  String name;

  Iterable<Pet> pets;

  PetOwner(this.name);

  String toString() => name;

  operator ==(other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is PetOwner) {
      return other.name == name;
    }

    return false;
  }
}
