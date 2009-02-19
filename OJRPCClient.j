@import <Foundation/Foundation.j>

@implementation OJRPCClient : CPObject
{
    CPString _url;
}

+ (id)objectWithURL:(CPString)aURL
{
    return [[self alloc] initWithURL:aURL];
}

- (id)initWithURL:(CPString)aURL
{
    if (self = [super init])
    {
        _url = aURL;
    }
    return self;
}

- (void)forwardInvocation:(CPInvocation)anInvocation
{
    [anInvocation setTarget:nil];
    var invocationData = [CPKeyedArchiver archivedDataWithRootObject:anInvocation];
    
    var request = [CPURLRequest requestWithURL:_url];
    [request setHTTPBody:[invocationData string]];
    [request setHTTPMethod:"POST"];
    
    var resultData = [CPURLConnection sendSynchronousRequest:request returningResponse:nil error:nil],
        result = [CPKeyedUnarchiver unarchiveObjectWithData:resultData];
    
    if (result && result.isa)
    {
        if ([result isKindOfClass:CPInvocation])
        {
            [anInvocation setReturnValue:[result returnValue]];
            return;
        }
        else if ([result isKindOfClass:CPException])
        {
            if ([result name] === "OJRPCEncodedException" || [result name] === "OJRPCStringifiedException")
                throw [result userInfo];
            else
                [result raise];
        }
    }
    
    [CPException raise:"OJRPCException" reason:"Unknown OJRPC Error"];
}

- (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
    return YES;
}
    
@end
