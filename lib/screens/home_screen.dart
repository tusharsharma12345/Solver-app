import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solver_app/providers/user_provider.dart';
import 'package:solver_app/screens/submit_question.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          child: TextField(
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text(user.email),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubmitQuestion()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
