import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solver_app/providers/user_provider.dart';
import 'package:solver_app/screens/home_screen.dart';
import 'package:solver_app/screens/signup_screen.dart';
import 'package:solver_app/services/auth_services.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: Provider.of<UserProvider>(context).user.token.isEmpty
          ? LoginScreen()
          : HomeScreen(),
    );
  }
}
