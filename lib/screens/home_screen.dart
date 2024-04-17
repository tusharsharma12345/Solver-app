import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solver_app/models/queston_answer.dart';
import 'package:solver_app/providers/user_provider.dart';
import 'package:solver_app/screens/login_screen.dart';
import 'package:solver_app/screens/submit_question.dart';
import 'package:solver_app/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QuestionAnswer> questionanswer = [];
  Future<List<QuestionAnswer>> getQuestionAnswer(String search_question) async {
    try {
      questionanswer = [];
      var url = Uri.parse('${Constants.uri}/api/get_question_answer');

      // Define your POST body data

      // Make the POST request
      var response = await http.post(
        url,
        body: jsonEncode({
          'question': search_question,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Check if the request was successful

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            print(response.body);
            var data = jsonDecode(response.body.toString());
            for (Map<String, dynamic> i in data) {
              questionanswer.add(QuestionAnswer.fromJson(i));
            }
            print(questionanswer);

            showSnackBar(context, "Successfully received");
          });
      return questionanswer;
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {});
      return questionanswer;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    questionanswer = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    questionanswer = [];
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    TextEditingController search_question = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          child: TextField(
            controller: search_question,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      print("Tapped");
                      questionanswer = [];
                      if (search_question.text.isNotEmpty) {
                        getQuestionAnswer(search_question.text.toString());
                      } else {
                        questionanswer = [];
                        showSnackBar(context, "Enter question to search");
                      }
                    },
                    icon: Icon(Icons.search)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('x-auth-token');
                if (token != null) {
                  prefs.setString('x-auth-token', '');
                  // Navigator.of(context).pop();
                   Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
         

                }
              },
            ),
          ),
        ],
      ),
      body: questionanswer.length == 0
          ? Center(child: Text(user.email))
          : ListView.builder(
              itemCount: questionanswer.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.redAccent,
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Q${index + 1} " +
                                  questionanswer[index].question),
                            )),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.greenAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("A${index + 1} " +
                                  questionanswer[index].answer),
                            )),
                      ],
                    ),
                  ),
                );
              }),
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
