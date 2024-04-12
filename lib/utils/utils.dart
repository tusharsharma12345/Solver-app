import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

void httpErrorHandle(
    {required http.Response response,
    required BuildContext context,
    required VoidCallback onSuccess}) {
  if (response.statusCode == 200) {
    onSuccess();
  } else if(response.statusCode==400) {
    showSnackBar(context, jsonDecode(response.body)['msg']);
  }
  else if(response.statusCode==500){
        showSnackBar(context, jsonDecode(response.body)['error']);
  }
  else{
        showSnackBar(context, (response.body));

  }
}
