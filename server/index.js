const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const PORT = process.env.PORT||3000;
const app = express();
app.use(express.json());
app.use(cors());
app.use(authRouter);
const DB = "mongodb+srv://tushar2110026:jSV09s5ipI6yqXv5@cluster0.7qbf3aw.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
mongoose.connect(DB).then(
    ()=>{
        console.log("Connection Successful with db");
    }
).catch((e)=>{
    console.log(e);
})
app.listen(PORT, "0.0.0.0", ()=>{
   console.log('Connected at port',PORT);
});