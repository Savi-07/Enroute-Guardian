import 'package:flutter/material.dart';
import 'package:ui_login/CustomAppBar.dart';
import 'package:ui_login/LoginPage.dart';
import 'package:ui_login/Profile.dart';

class Person {
  String name;
  String details;
  Gender gender;
  bool isPredefined;

  Person(this.name, this.details,
      {required this.gender, this.isPredefined = false});
}

enum Gender { male, female }

class AddUsers extends StatefulWidget {
  const AddUsers({Key? key}) : super(key: key);

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  TextEditingController nameController = TextEditingController();
  Gender? selectedGender;
  String? selectedRole = 'Guest'; // Default value for selectedRole

  List<Person> persons = [
    Person('Sahil Kumar Singh', 'Super Admin',
        gender: Gender.male, isPredefined: true),
    Person('Labanya Roy', 'Admin', gender: Gender.female, isPredefined: false),
    Person('Pushkar Pan', 'Guest', gender: Gender.male, isPredefined: false),
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
              "ADMIN CONTROL PANEL",
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
                  child: GestureDetector(
                    onTap: () {
                      // Check if the person is predefined or not
                      if (person.isPredefined) {
                        // Navigate to the profile section
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()),
                        );
                      } else {
                        // Navigate to the login page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 91, 89, 89),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14, top: 6),
                        child: Row(
                          children: [
                            Icon(
                              person.gender == Gender.male
                                  ? Icons.man
                                  : Icons.woman,
                              size: 45, // Increased icon size
                              color: Colors.white,
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
                                  '${person.details}',
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
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black38
            ),
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
              DropdownButtonFormField<String>(
                value: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem(
                    value: 'Guest',
                    child: Text('Guest'),
                  ),
                ],
                decoration: InputDecoration(labelText: 'Role'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<Gender>(
                value: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: Gender.male,
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: Gender.female,
                    child: Text('Female'),
                  ),
                ],
                decoration: InputDecoration(labelText: 'Gender'),
              ),
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
                    selectedRole ??
                        'Guest', // Use a default value if selectedRole is null
                    gender: selectedGender ?? Gender.male,
                  ));
                  // Clear the text fields after adding a person
                  nameController.clear();
                  selectedRole =
                      null; // Reset selectedRole after adding a person
                  selectedGender = null;
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
