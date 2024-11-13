import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? email;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      imageUrl = prefs.getString('image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        if (imageUrl != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imageUrl!),
          ),
        const SizedBox(height: 20),
        if (name != null)
          Text(
            name!,
            style: const TextStyle(fontSize: 20),
          ),
        if (email != null)
          Text(
            email!,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        const SizedBox(height: 30),
      ],
    );
  }
}
