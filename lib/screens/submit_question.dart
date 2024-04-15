import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SubmitQuestion extends StatefulWidget {
  const SubmitQuestion({super.key});

  @override
  State<SubmitQuestion> createState() => _SubmitQuestionState();
}

class _SubmitQuestionState extends State<SubmitQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
              ),
              SizedBox(height: 20.0),
              TextField(
                maxLines: null,
                keyboardType: TextInputType.emailAddress,
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
                      onPressed: () {}, child: Text("Upload Solution")))
            ],
          ),
        ),
      ),
    );
  }
}
