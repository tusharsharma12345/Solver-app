import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:solver_app/utils/constants.dart';
import 'package:solver_app/utils/utils.dart';

import '../providers/user_provider.dart';

class SubmitQuestion extends StatefulWidget {
  const SubmitQuestion({super.key});

  @override
  State<SubmitQuestion> createState() => _SubmitQuestionState();
}

class _SubmitQuestionState extends State<SubmitQuestion> {
  TextEditingController question = TextEditingController();
  TextEditingController answer = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: null,
                controller: question,
                decoration: InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
              ),
              SizedBox(height: 20.0),
              TextField(
                maxLines: null,
                controller: answer,
                decoration: InputDecoration(
                    labelText: 'Answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
              ),
              SizedBox(height: 20.0),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (question.text.isNotEmpty &&
                            answer.text.isNotEmpty) {
                          var url = Uri.parse(
                              '${Constants.uri}/api/upload_question_answer');

                          // Define your POST body data

                          // Make the POST request
                          var response = await http.post(
                            url,
                            body: jsonEncode({
                              'question': question.text,
                              'answer': answer.text,
                              'uploader_id': user.id,
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
                                showSnackBar(context, "Successfully Uploaded");
                              });
                          Navigator.of(context).pop();
                        } else {
                          showSnackBar(context, "Enter all fields");
                        }
                      },
                      child: Text("Upload Solution")))
            ],
          ),
        ),
      ),
    );
  }
}
