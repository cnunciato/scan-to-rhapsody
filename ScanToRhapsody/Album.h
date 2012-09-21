//
//  Album.h
//  ScannerTest
//
//  Created by Christian Nunciato on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject 
{
    NSString *id;
    NSString *name;
    NSString *coverURL;
    NSString *artistID;
    NSString *artistName;
}

@property (nonatomic, readwrite, copy) NSString *id;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *coverURL;
@property (nonatomic, readwrite, copy) NSString *artistID;
@property (nonatomic, readwrite, copy) NSString *artistName;

- (id) initWithRDSDataDictionary:(NSDictionary *)data;

@end
