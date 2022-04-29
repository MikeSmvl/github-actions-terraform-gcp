let express = require('express')
let app = express()

app.get('/', (req,res) => {
  res.status(200).send('Hello world!');
});

exports.app = app;