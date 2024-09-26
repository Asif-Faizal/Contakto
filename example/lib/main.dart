import 'package:contactor/contactor.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, String>> _contacts = [];

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }
  
Future<void> fetchContacts() async {
    List<Map<String, String>> contacts = [];
    try {
        contacts = await ContactFetcher.getContacts();
    } on PlatformException {
        print('Failed to fetch contacts.');
    }

    if (!mounted) return;

    setState(() {
        _contacts = contacts;
    });
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: fetchContacts,
                child: const Text('Fetch Contacts'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return ListTile(
                      title: Text(contact['name'] ?? 'Unknown'),
                      subtitle: Text(contact['number'] ?? 'No number'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}