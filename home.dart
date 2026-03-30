import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  @override
  void initState() {
    super.initState();
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Home'))),
      body: Container(
        color: Colors.blue.shade100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello, $name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.home, color: Colors.blue, size: 60),
              const SizedBox(height: 40),
              ElevatedButton(
                child: const Text('Log Out'),
                onPressed: () async {
                  var pref = await SharedPreferences.getInstance();
                  await pref.setBool('KEYLOGIN', false);
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getValue() async {
    var pref = await SharedPreferences.getInstance();
    var nameV = pref.getString('name');
    setState(() {
      name = nameV ?? "Dear";
    });
  }
}
