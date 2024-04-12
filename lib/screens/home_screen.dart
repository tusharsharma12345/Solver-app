import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solver_app/providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Center(
        child: Text(user.email),
      ),
    );
  }
}