//
//  NwLogon.h
//  HCM
//
//  Created by on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "NwLogon.h"

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>


@interface NwLogon : CDVPlugin {

 NSString* callbackID;  
    NSMutableData *connectionData;
    NSURLResponse *connectionResponse;
    NSString *user; 
    NSString *pwd; 
    NSString *urllogon; 

}

@property (nonatomic, copy) NSString* callbackID;
@property (nonatomic, copy) NSString* user;
@property (nonatomic, copy) NSString* pwd;
@property (nonatomic, copy) NSString* urllogon;
// Instance Method  
- (void)logon:(NSMutableArray*)user withDict:(NSMutableDictionary*)options;


@end
