//
//  ViewController.m
//  ScannerTest
//
//  Created by Christian Nunciato on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "AppModel.h"
#import "Album.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize albumName;
@synthesize artistName;
@synthesize addToLibraryButton;
@synthesize failureLabel;
@synthesize successLabel;
@synthesize notFoundLabel;
@synthesize scanButton;
@synthesize openButton;
@synthesize albumImage;

- (IBAction) scanButtonTapped
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [[self albumName] setHidden:YES];
    [[self artistName] setHidden:YES];
    [[self albumImage] setHidden:YES];    
    [[self addToLibraryButton] setHidden:YES];
    [[self openButton] setHidden:YES];
    [[self successLabel] setHidden:YES];
    [[self failureLabel] setHidden:YES];
    [[self notFoundLabel] setHidden:YES];
    
    [self presentModalViewController:reader animated:YES];
}

- (void) dealloc
{
    self.albumImage = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [AppModel sharedInstance];
    
    if (![model token])
    {
        LoginViewController *loginController = [[LoginViewController alloc] init];
        [self presentModalViewController:loginController animated:YES];
    }
	
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setAlbumName:nil];
    [self setArtistName:nil];
    [self setAddToLibraryButton:nil];
    [self setFailureLabel:nil];
    [self setSuccessLabel:nil];
    [self setNotFoundLabel:nil];
    [self setScanButton:nil];
    [self setOpenButton:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)
        break;
    
    [reader dismissModalViewControllerAnimated: YES];
    [self findAlbumByUPC:[symbol data]];
}

- (void) findAlbumByUPC:(NSString *)candidateString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *upc = [formatter numberFromString:candidateString];
    
    if (upc)
    {
        NSString *developerKey = @""; // <-- Your developer key here
        NSString *url = [NSString stringWithFormat:@"http://direct.rhapsody.com/metadata/data/methods/getAlbums.js?developerKey=%@&albumIds=alb_upc.%@&cobrandId=40134&filterRightsKey=0", developerKey, upc];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        
        NSLog(@"lookup: %@", url);
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (error)
             {
                 [[self notFoundLabel] setHidden:NO];
                 [[self addToLibraryButton] setHidden:YES];
             }
             else 
             {
                 NSArray *a = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 NSLog(@"returned: %@", a);
                 
                 if ([a count] && [a count] > 0)
                 {
                     NSDictionary *d = [a objectAtIndex:0];
                     selectedAlbum = [[Album alloc] initWithRDSDataDictionary:d];
                     
                     [[self albumName] setText:[selectedAlbum name]];
                     [[self artistName] setText:[selectedAlbum artistName]];
                     [[self albumImage] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[selectedAlbum coverURL]]]]];
                     
                     [[self albumName] setHidden:NO];
                     [[self artistName] setHidden:NO];
                     [[self albumImage] setHidden:NO];
                     [[self addToLibraryButton] setHidden:NO];
                 }
                 else 
                 {
                     [[self notFoundLabel] setHidden:NO];
                     [[self addToLibraryButton] setHidden:YES];
                 }
             }
         }];
    }
    else 
    {
        
    }
}

- (IBAction) addToLibrary:(id)sender {
    
    NSString *developerKey = @""; // <-- Your developer key here
    NSString *albumID = [self escape:[selectedAlbum id]];
    NSString *username = [self escape:[[AppModel sharedInstance] username]];
    NSString *password = [self escape:[[AppModel sharedInstance] password]];
    NSString *url = [NSString stringWithFormat:@"http://direct.rhapsody.com/library/data/methods/addAlbumToLibrary.js?developerKey=%@&albumId=%@&cobrandId=40134&logon=%@&password=%@", developerKey, albumID, username, password];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {        
         NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         if (error)
         {
             [[self failureLabel] setHidden:NO];
         }
         else 
         {
             if ([d valueForKey:@"exception"])
             {
                 [[self failureLabel] setHidden:NO];
             }
             
             [[self albumName] setHidden:YES];
             [[self artistName] setHidden:YES];
             [[self albumImage] setHidden:YES];  
             [[self addToLibraryButton] setHidden:YES];
             [[self openButton] setHidden:NO];
             
             // Parse out the result here; not all albums are streamable
             
             [[self successLabel] setHidden:NO];
         }
     }];
}

- (IBAction) openInRhapsody:(id)sender {
    NSString *url = [NSString stringWithFormat:@"rhap:///?action=view&id=%@", [selectedAlbum id]];
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"You Need Rhapsody!" message:@"To view (and play!) this album, you need the Rhapsody iPhone app.  Get it now?" delegate:self cancelButtonTitle:@"Sure!" otherButtonTitles:@"No, Thanks", nil];
        
        [a show];
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *url = @"itms-apps://itunes.apple.com/us/app/rhapsody/id366725701?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
}

@end
