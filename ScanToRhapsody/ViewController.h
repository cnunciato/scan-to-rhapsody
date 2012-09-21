//
//  ViewController.h
//  ScannerTest
//
//  Created by Christian Nunciato on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@class AppModel;
@class Album;

@interface ViewController : UIViewController <ZBarReaderDelegate, UIAlertViewDelegate>
{
    UIImageView *albumImage;
    AppModel *model;
    Album *selectedAlbum;
}

@property (nonatomic, retain) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIButton *addToLibraryButton;
@property (weak, nonatomic) IBOutlet UILabel *failureLabel;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet UILabel *notFoundLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *openButton;


- (IBAction) scanButtonTapped;
- (IBAction) addToLibrary:(id)sender;
- (IBAction) openInRhapsody:(id)sender;


@end
