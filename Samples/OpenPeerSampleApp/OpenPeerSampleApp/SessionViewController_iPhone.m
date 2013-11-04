//
//  SessionViewController_iPhone.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 11/4/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "SessionViewController_iPhone.h"
#import "Session.h"
#import "ChatViewController.h"

@interface SessionViewController_iPhone ()

@end

@implementation SessionViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithSession:(Session*) inSession
{
    self = [self initWithNibName:@"SessionViewController_iPhone" bundle:nil];
    if (self)
    {
        self.session = inSession;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.chatViewController = [[ChatViewController alloc] initWithSession:self.session];
    
    [self.chatViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.chatViewController.view];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chatViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chatViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chatViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chatViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
