class QuestionAnswer {
  final String question;
  final String answer;
  final String uploaderId;

  QuestionAnswer({
    required this.question,
    required this.answer,
    required this.uploaderId,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question: json['question'],
      answer: json['answer'],
      uploaderId: json['uploader_id'],
    );
  }
   

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'uploader_id': uploaderId,
    };
  }
}
