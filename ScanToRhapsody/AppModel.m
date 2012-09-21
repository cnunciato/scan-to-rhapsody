//
//  AppModel.m
//  ScannerTest
//
//  Created by Christian Nunciato on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

@synthesize token;
@synthesize username;
@synthesize password;
@synthesize guid;

+ (AppModel *) sharedInstance
{
    static AppModel *sharedInstance;
    
    if(!sharedInstance)
    {
        sharedInstance = [[AppModel alloc] init];
    }
    
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
        guid = [[NSUserDefaults standardUserDefaults] valueForKey:@"guid"];
    }
    
    return self;
}

- (void) setToken:(NSString *)t
{
    token = t;
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"token"];
}

- (void) setUsername:(NSString *)u
{
    username = u;
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
}

- (void) setPassword:(NSString *)p
{
    password = p;
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
}

- (void) setGuid:(NSString *)p
{
    guid = p;
    [[NSUserDefaults standardUserDefaults] setValue:guid forKey:@"guid"];
}

@end
