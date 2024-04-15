const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const auth = require("../middleware/auth");
const question_answer = require("../models/question_answer");
const authRouter = express.Router();
//search route
authRouter.post("/api/get_question_answer", async (req,res)=>{
    try {
      
       let sentence = req.body.question;
       sentence = sentence.replace(/[^\w\s]/gi, '');
       //break the question into array of string tokens.
       let arrayOfStrings = sentence.split(" ");
       let lowerCaseArrayofquestion = arrayOfStrings.map(str => str.toLowerCase());
       let itDevelopmentWords = [
           "algorithm", "API", "agile", "analytics", "Android", "Apache", "app", "architecture", "array", "artificial intelligence",
           "AWS", "backend", "big data", "blockchain", "bug", "byte", "C#", "C++", "cloud", "code",
           "compiler", "computing", "CSS", "database", "debugging", "deep learning", "DevOps", "Docker", "encryption", "frontend",
           "framework", "function", "GitHub", "HTML", "HTTP", "JavaScript", "JSON", "Java", "Linux", "machine learning",
           "Microsoft", "mobile", "MySQL", "network", "node.js", "object-oriented", "open source", "operating system", "PHP",
           "Python", "programming", "React", "REST", "Ruby", "server", "software", "SQL", "stack", "Swift",
           "testing", "UI", "UX", "version control", "virtual machine", "web", "XML",
           // Add more words as needed...
         ];
         let lowerCaseArrayofstoredwords = itDevelopmentWords.map(str => str.toLowerCase());
         let matchingWords = [];

         lowerCaseArrayofquestion.forEach(word => {
             if (lowerCaseArrayofstoredwords.includes(word)) {
                 matchingWords.push(word);
               }
             }
);
if(matchingWords.length===0){
   res.status(201).json({ message: "Cannot find your questions." });
 }
 else{
    let result_question = await question_answer.find({identity_key: matchingWords[0]});
    if(result_question){
        res.json(result_question);
    }
    else{
        res.json({msg:"No data found"});
    }
    
 }
       
    } catch (error) {
       res.status(500).json({ error: error.message });
    }
});
//upload question route
authRouter.post("/api/upload_question_answer", async (req,res)=>{
     try {
        let {question,answer,uploader_id}=req.body;
        let sentence = req.body.question;
        sentence = sentence.replace(/[^\w\s]/gi, '');
        //break the question into array of string tokens.
        let arrayOfStrings = sentence.split(" ");
        let lowerCaseArrayofquestion = arrayOfStrings.map(str => str.toLowerCase());
        let itDevelopmentWords = [
            "algorithm", "API", "agile", "analytics", "Android", "Apache", "app", "architecture", "array", "artificial intelligence",
            "AWS", "backend", "big data", "blockchain", "bug", "byte", "C#", "C++", "cloud", "code",
            "compiler", "computing", "CSS", "database", "debugging", "deep learning", "DevOps", "Docker", "encryption", "frontend",
            "framework", "function", "GitHub", "HTML", "HTTP", "JavaScript", "JSON", "Java", "Linux", "machine learning",
            "Microsoft", "mobile", "MySQL", "network", "node.js", "object-oriented", "open source", "operating system", "PHP",
            "Python", "programming", "React", "REST", "Ruby", "server", "software", "SQL", "stack", "Swift",
            "testing", "UI", "UX", "version control", "virtual machine", "web", "XML",
            // Add more words as needed...
          ];
          let lowerCaseArrayofstoredwords = itDevelopmentWords.map(str => str.toLowerCase());
          let matchingWords = [];

          lowerCaseArrayofquestion.forEach(word => {
              if (lowerCaseArrayofstoredwords.includes(word)) {
                  matchingWords.push(word);
                }
              }
);
if(matchingWords.length===0){
    res.status(201).json({ message: "Cannot upload your question" });
  }
  else{
    let qa = new question_answer({
        question,
        answer,
        uploader_id,
        identity_key:matchingWords[0]
    });
   qa= await qa.save();
    res.json(qa);
  }
        
     } catch (error) {
        res.status(500).json({ error: error.message });
     }
});
authRouter.post("/api/signup", async (req, res) => {
    try {
        const { name, email, password } = req.body;
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res
                .status(400)
                .json({ msg: "User with same email already exist!" });
        }
        const hashedPassword = await bcryptjs.hash(password, 8);
        let user = new User({
            email,
            password: hashedPassword,
            name,
        });
        user = await user.save();
        res.json(user);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
authRouter.post("/api/signin", async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ msg: "User with this email doesnt exist!" });
        }
        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: "Incorrect password" });
        }
        const token = jwt.sign({ id: user._id }, "passwordKey");
        res.json({ token, ...user._doc });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});
authRouter.post("/tokenIsValid", async (req, res) => {
    try {
        const token = req.header("x-auth-token");
        if (!token) {
            return res.json(false);
        }
        else {
            const verified = jwt.verify(token, "passwordKey");
            if (!verified) {
                return res.json(false);
            }
            else {
                const user = await User.findById(verified.id);
                if (!user) { return res.json(false); }
                else {
                    res.json(true);
                   
                }
            }
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
// get user data
authRouter.get("/", auth, async (req, res) => {
    const user = await User.findById(req.user);
    res.json({ ...user._doc, token: req.token });
});
module.exports = authRouter;
