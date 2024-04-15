const mongoose = require("mongoose");
const questionanswer = mongoose.Schema({
    question: {
        required: true,
        type: String,
        trim: true,
    },
    answer: {
        required: true,
        type: String,
        trim: true,
    },
    uploader_id: {
        required: true,
        type: String,
    },
    identity_key:{
        required: true,
        type: String,
    }
});
const question_answer = mongoose.model("Question_answer", questionanswer);
module.exports = question_answer;