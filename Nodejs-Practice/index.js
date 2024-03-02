let http = require('http');

http.createServer(function (req, res) {
  res.write('My first Node.js server');
  res.end();
}).listen(7000, function(){
 console.log("server started at 7000");
});
