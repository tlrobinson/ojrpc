// this stuff will be automatic eventually
var JACK_BASE = "jack/";
$LOAD_PATH = JACK_BASE + "lib";
load(JACK_BASE + "core.js");

@import <Foundation/Foundation.j>
@import "../OJRPCServer.j"

CPLogRegister(CPLogPrint);

@implementation Capitalizer : CPObject
{
}

- (CPString)caps:(CPString)aString
{
    var result = aString.toUpperCase();
    CPLog.info("%s => %s", aString, result);
    return result;
}

@end


var capitalizer = [[Capitalizer alloc] init];

var map = {};

map["/capitalizer"] = [OJRPCServer serverForObject:capitalizer];

// Setup Jack to serve the capitalizer at /capitialize, and the sample client + OJRPCClient.j

var Jack = require("jack");

map["/"] = Jack.File(".");
map["/OJRPCClient.j"] = Jack.File("../OJRPCClient.j");

Jack.Handler.Simple.run(Jack.CommonLogger(Jack.URLMap(map)));
