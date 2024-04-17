// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:ui_login/CustomAppBar.dart';

class Person {
  String name;
  String contact;
  bool isPredefined;
  String image; // Image path

  Person(this.name, {required this.contact, required this.image, this.isPredefined = false});
}

class Emergency extends StatefulWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  // String? selectedRole = 'Admin';
  // Gender? selectedGender;
  String? image = 'assets/images/policeicon.png';

  List<Person> persons = [
    Person('POLICE',
        contact: '+91 89674 18564',
        image: 'assets/images/policeicon.png',
        isPredefined: true),
    Person('Ambulance',
        contact: '+91 90624 35655',
        image: 'assets/images/ambulanceicon.png',
        isPredefined: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "EMERGENCY CONTACTS",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                var person = persons[index];
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 91, 89, 89),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, top: 6),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(person.image), // Use image path
                            radius: 30,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${person.name}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${person.contact}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                          Spacer(),
                          if (!person.isPredefined)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                _confirmDelete(context, person);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddDialog(context);
              },
              child: SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 30, // Increased icon size
                      color: Colors.black,
                    ),
                    Text(
                      'ADD ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
              ),
              SizedBox(height: 10),
              // DropdownButtonFormField<String>(
              //   value: selectedRole,
              //   onChanged: (value) {
              //     setState(() {
              //       selectedRole = value;
              //     });
              //   },
              //   items: [
              //     DropdownMenuItem(
              //       value: 'Admin',
              //       child: Text('Admin'),
              //     ),
              //     DropdownMenuItem(
              //       value: 'Guest',
              //       child: Text('Guest'),
              //     ),
              //   ],
              //   decoration: InputDecoration(labelText: 'Role'),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Add the new person to the list
                  persons.add(Person(
                    nameController.text,
                    contact: contactController.text,
                    image:
                        'assets/images/familyicon.png', // Use a single image for newly added users
                  ));
                  // Clear the text fields after adding a person
                  nameController.clear();
                  contactController.clear();
                  // selectedRole = null;
                  // selectedGender = null;
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Person person) {
    // If the person is predefined, display a message that it cannot be deleted
    if (person.isPredefined) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cannot Delete'),
            content: Text('The selected user cannot be deleted.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // If the person is not predefined, proceed with deletion confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete', style: TextStyle(color: Colors.black)),
          content: Text('Are you sure you want to delete ${person.name}?',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  persons.remove(person); // Remove the person
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
