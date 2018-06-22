var http      = require('http');
var httpProxy = require('http-proxy');
//var exec = require('child_process').exec;
var request = require("request");
//var fs = require('fs');
var Random = require('random-js');
var redis = require('redis')

var client = redis.createClient(6379, '127.0.0.1', {})
var CANARY_PROB = 0.7;
var nodes = ['http://slave1','http://slave2']
var TARGET = null;
rand = new Random(Random.engines.mt19937().seed(0));

 var options = {};

// Create your proxy server and set the target in the options.
//

  var proxy   = httpProxy.createProxyServer(options);


//

//
// Create your target server
//

http.createServer(function (req, res) {
        client.get("canaryFlag", function(err, value) {
        if (value === "true") {
          if (rand.bool(CANARY_PROB)) {
            console.log("processing request through canary server");
            proxy.web( req, res, {target: nodes[1] } );  
          }
          else{
            console.log("processing request through production server");
            proxy.web( req, res, {target: nodes[0] } );
          }
        }
        else {
          console.log("processing request through production server");
          proxy.web( req, res, {target: nodes[0] } );
        }
      });



}).listen(9000);




