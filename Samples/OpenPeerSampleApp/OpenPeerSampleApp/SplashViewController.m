//
//  SplashViewController.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/4/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "SplashViewController.h"
#import "OpenPeer.h"
#import "Logger.h"
#import <OpenPeerSDK/HOPModelManager.h>

@interface SplashViewController ()

- (void) removeSplashScreen;

@end

@interface SplashViewController ()

@property (strong, nonatomic) NSTimer* closingTimer;

- (IBAction)actionStartLogger:(id)sender;

@end

@implementation SplashViewController

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
    
    //if ([[HOPModelManager sharedModelManager] getLastLoggedInHomeUser])
        self.closingTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeSplashScreen) userInfo:nil repeats:NO];
//    else
//        self.closingTimer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self.presentingViewController /*[UIApplication sharedApplication].delegate*/ selector:@selector(removeSplashScreen) userInfo:nil repeats:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionStartLogger:(id)sender
{
    [Logger startTelnetLoggerOnStartUp];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"OpenPeer" message:@"Logger is started! Almost all log levels are set to trace. If you want to change that, you can do that from the settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void) removeSplashScreen
{
    [self.view removeFromSuperview];

    //[[OpenPeer sharedOpenPeer] setup];
}
@end
