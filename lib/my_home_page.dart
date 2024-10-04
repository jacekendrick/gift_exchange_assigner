import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gift_exchange_assigner/models/person.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person> people = [
    Person(name: 'Person1', exclusions: ["Person2", "Person3"]),
    Person(name: 'Person2', exclusions: ["Person1", "Person4"]),
    Person(name: "Person5", exclusions: ["Person6", "Person1"]),
    Person(name: "Person6", exclusions: ["Person5", "Person7"]),
    Person(name: "Person4", exclusions: ["Person8"]),
    Person(name: "Person8", exclusions: ["Person3", "Person9"]),
    Person(name: "Person3", exclusions: ["Person8", "Person10"]),
    Person(name: "Person10", exclusions: ["Person7", "Person5"]),
    Person(name: "Person7", exclusions: ["Person10", "Person2"]),
    Person(name: "Person9", exclusions: ["Person6"]),
    Person(name: "Person11", exclusions: []),
  ];

  late List<Person> peopleNeedingGifter = List.from(people);
  List<Person> peopleWhoHaveAssignment = [];

  void _resetAssignments() {
    for (int i = 0; i < people.length; i++) {
      people[i].recipient = null;
    }
    peopleNeedingGifter = List.from(people);
    peopleWhoHaveAssignment = [];
  }

  void _makeAssignments() {
    _resetAssignments();
    for (int i = 0; i < people.length; i++) {
      _findAssignmentFor(people[i]);
    }

    setState(() {});
  }

  void _findAssignmentFor(Person personNeedingAssignment) {
    List<int> indecesTried = [];
    while (personNeedingAssignment.recipient == null) {
      if (indecesTried.length < peopleNeedingGifter.length) {
        int randomIndex = Random().nextInt(peopleNeedingGifter.length);
        if (!indecesTried.contains(randomIndex)) {
          indecesTried.add(randomIndex);
        }
        Person randomPerson = peopleNeedingGifter[randomIndex];
        if (personNeedingAssignment.canGiveTo(randomPerson)) {
          personNeedingAssignment.recipient = randomPerson;
          peopleNeedingGifter.remove(randomPerson);
          peopleWhoHaveAssignment.add(personNeedingAssignment);
        }
      }
      // If we've gone through the whole list and haven't found a match
      else {
        // We have to try to start mixing up the already-made assignments
        for (int i = 0; i < peopleWhoHaveAssignment.length; i++) {
          if (personNeedingAssignment
              .canGiveTo(peopleWhoHaveAssignment[i].recipient!)) {
            personNeedingAssignment.recipient =
                peopleWhoHaveAssignment[i].recipient;
            peopleWhoHaveAssignment.add(personNeedingAssignment);
            peopleWhoHaveAssignment[i].recipient = null;
            _findAssignmentFor(peopleWhoHaveAssignment[i]);
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        children: [
                          Text(people[index].name),
                          if (people[index].recipient != null)
                            Text(" ➡️ ${people[index].recipient!.name}"),
                        ],
                      ),
                    );
                  },
                  itemCount: people.length),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _makeAssignments,
        tooltip: 'Make assignments',
        backgroundColor: Colors.red,
        child: const Icon(Icons.card_giftcard),
      ),
    );
  }
}
