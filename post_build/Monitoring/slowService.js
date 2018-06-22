var server = require("./createServer.js");

server.createServer(9002, function()
{
	// SLOW	
    var seconds = 1;
    var waitTill = new Date(new Date().getTime() + seconds * 1000);
    while(waitTill > new Date()){}
});