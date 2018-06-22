var server = require("./createServer.js");

server.createServer(9001, function()
{
	// MED
	for( var i =0 ; i < 3000000; i++ )
	{
		i/2;
	}
});