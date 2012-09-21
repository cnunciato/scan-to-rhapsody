//
//  LoginViewController.m
//  ScannerTest
//
//  Created by Christian Nunciato on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize submitButton;
@synthesize errorLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [usernameField setDelegate:self];
    [passwordField setDelegate:self];
}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setSubmitButton:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) awakeFromNib
{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usernameField || textField == passwordField)
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)authenticate:(id)sender 
{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@", [usernameField text], [passwordField text]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://playback.rhapsody.com/login.json"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [errorLabel setHidden:YES];
    [usernameField setEnabled:NO];
    [passwordField setEnabled:NO];
    [submitButton setEnabled:NO];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[NSOperationQueue mainQueue] 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {        
         if (error)
         {
             [errorLabel setHidden:NO];
         }
         else 
         {
             NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSString *token = [(NSDictionary *)[result valueForKey:@"data"] valueForKey:@"token"];
             NSString *guid = [(NSDictionary *)[result valueForKey:@"data"] valueForKey:@"userGuid"];
             
             NSLog(@"%@", result);
             
             if ([token isEqual:[NSNull null]])
             {
                 [errorLabel setHidden:NO];
             }
             else 
             {
                 [[AppModel sharedInstance] setToken:token];
                 [[AppModel sharedInstance] setUsername:[usernameField text]];
                 [[AppModel sharedInstance] setPassword:[passwordField text]];
                 [[AppModel sharedInstance] setGuid:guid];
                 
                 [self dismissModalViewControllerAnimated:YES];
             }
         }
         
         [usernameField setEnabled:YES];
         [passwordField setEnabled:YES];
         [submitButton setEnabled:YES];
     }];
}

@end
