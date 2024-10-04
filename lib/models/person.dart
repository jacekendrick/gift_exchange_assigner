class Person {
  String name;
  List<String>? exclusions;
  Person? recipient;

  Person({required this.name, this.exclusions, this.recipient});

  bool canGiveTo(Person person) {
    if (exclusions == null) {
      return true;
    }
    return !exclusions!.contains(person.name) && name != person.name;
  }
}
