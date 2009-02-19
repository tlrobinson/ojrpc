@import <Foundation/Foundation.j>

@import "OJRPCClient.j"

function main(args, namedArgs)
{
    var capitalizer = [OJRPCClient objectWithURL:"/capitalizer"];
    
    alert([capitalizer caps:"bar"]);
}
