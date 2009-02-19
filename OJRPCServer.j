@import <Foundation/Foundation.j>

@implementation OJRPCServer : CPObject
{
}

+ (Function)serverForObject:(id)object
{
    return function(env) {
        
        try
        {
            var invocationData = [CPData dataWithString:(env["jack.input"].read())],
                invocation = [CPKeyedUnarchiver unarchiveObjectWithData:invocationData];
            
            [invocation invokeWithTarget:object];
            
            // FIXME: correctly propagate "undefined"
            if ([invocation returnValue] === undefined)
                [invocation setReturnValue:nil];
        
            [invocation setTarget:nil];
            invocationData = [CPKeyedArchiver archivedDataWithRootObject:invocation];
            
            return [200, { "Content-Type" : "text/plain" }, [invocationData string]];
        }
        catch (e)
        {
            var exception;
            if (e && e.isa && [e isKindOfClass:CPException])
                exception = e;
            else if (!e || (e.isa && [e respondsToSelector:@selector(encodeWithCoder:)]))
                exception = [CPException exceptionWithName:"OJRPCEncodedException" reason:nil userInfo:e];
            else
                exception = [CPException exceptionWithName:"OJRPCStringifiedException" reason:nil userInfo:String(e)];
            
            CPLog.warn("OJRPCServerException " + exception+ " for object " + object);
            
            var exceptionData = [CPKeyedArchiver archivedDataWithRootObject:exception];
            
            return [500, { "Content-Type" : "text/plain" }, [exceptionData string]];
        }
    }
}

@end
