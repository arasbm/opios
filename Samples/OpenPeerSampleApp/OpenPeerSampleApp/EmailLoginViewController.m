//
//  EmailLoginViewController.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 7/16/13.
//  Copyright (c) 2013 Sergej. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "LoginManager.h"

@interface EmailLoginViewController ()

@end

@implementation EmailLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextFieldName:nil];
    [self setTextFieldEmail:nil];
    [super viewDidUnload];
}
- (IBAction)actionLogin:(id)sender
{
    if ([self.textFieldName.text length] > 0 && [self.textFieldEmail.text length] > 0)
    {
        [[LoginManager sharedLoginManager] startLegacyLoginWithName:self.textFieldName.text phoneNumber:nil email:self.textFieldEmail.text];
        [self.view removeFromSuperview];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self actionLogin:nil];
    return NO;
}
@end
