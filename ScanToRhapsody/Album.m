//
//  Album.m
//  ScannerTest
//
//  Created by Christian Nunciato on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Album.h"

@implementation Album

@synthesize id;
@synthesize name;
@synthesize coverURL;
@synthesize artistID;
@synthesize artistName;

- (id) initWithRDSDataDictionary:(NSDictionary *)data
{
    self = [super init];
    
    if (self) 
    {
        [self setId:[data valueForKey:@"albumId"]];
        [self setName:[data valueForKey:@"name"]];
        [self setCoverURL:[data valueForKey:@"albumArt162x162Url"]];
        [self setArtistID:[data valueForKey:@"primaryArtistId"]];
        [self setArtistName:[data valueForKey:@"primaryArtistDisplayName"]];
    }
    
    return self;
}

@end
