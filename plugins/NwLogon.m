//
//  NwLogon.m
//  HCM
//
//  Created byon 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NwLogon.h"

@implementation NwLogon
@synthesize callbackID , user , pwd , urllogon ;

CDVPluginResult* pluginResult;


-(void)logon:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options  
{
    // The first argument in the arguments parameter is the callbackID.
    // We use this to send data back to the successCallback or failureCallback
    // through PluginResult.   
    self.callbackID = [arguments pop];
    
    // Get the string that javascript sent us 
    self.user = [arguments objectAtIndex:0];                 
    self.pwd = [arguments objectAtIndex:1];    
    self.urllogon = [arguments objectAtIndex:2];    

    connectionData = [[NSMutableData alloc] init];
    // create the request
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:  self.urllogon]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
   NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    // Create Plugin Result 
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
   [pluginResult setKeepCallbackAsBool:TRUE];
    [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];

    
 }

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    //return YES to say that we have the necessary credentials to access the requested resource
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    //some code here, continue reading to find out what comes here 
       NSLog(@"Authentication challenge");
    
    if ([challenge previousFailureCount] == 0) 
    {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.user password:self.pwd persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    } 
    else 
    {
        NSLog(@"Credentials are wrong!");
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        NSMutableString *stringToReturn = [NSMutableString stringWithString: @"Credentials are wrong!"];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [pluginResult setKeepCallbackAsBool:FALSE];
        [super writeJavascript:[pluginResult toErrorCallbackString:self.callbackID]];
       
    }
}


	
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"in didFailWithError ");
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
   }


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // Create the Message that we wish to send to the Javascript
    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"Logon Successfull"];
    NSLog(@"in connectionDidFinishLoading ");
    NSString *string = [[[NSString alloc] initWithData:connectionData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", string);
    
    // Create Plugin Result 
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                     messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   [pluginResult setKeepCallbackAsBool:FALSE];
   [super writeJavascript:[pluginResult toSuccessCallbackString:self.callbackID]];


    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
       return nil;     // Never cache
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
       NSLog(@"in didReceiveResponse ");
[       connectionResponse release];
        connectionResponse = [response retain];
       [connectionData setLength:0];
}
 
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
        NSLog(@"in didReceiveData ");
   	    [connectionData appendData:data];
}

    


@end
