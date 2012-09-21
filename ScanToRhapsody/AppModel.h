//
//  AppModel.h
//  ScannerTest
//
//  Created by Christian Nunciato on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject
{
    NSString *token;
    NSString *username;
    NSString *password;
    NSString *guid;
}

@property (nonatomic, readwrite, copy) NSString *token;
@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *password;
@property (nonatomic, readwrite, copy) NSString *guid;

+ (AppModel *) sharedInstance;

@end
