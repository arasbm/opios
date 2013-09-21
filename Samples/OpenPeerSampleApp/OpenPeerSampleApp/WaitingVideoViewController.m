//
//  WaitingVideoViewController.m
//  Hookflash
//
//  Created by Jelena Djurkovic on 12/28/11.
//  Copyright (c) 2012 SMB Phone Inc. All rights reserved.
//

#import "WaitingVideoViewController.h"

@interface WaitingVideoViewController()

@property (weak, nonatomic) IBOutlet UIImageView *callerImage;
@property (weak, nonatomic) IBOutlet UIImageView *calleeImage;
@property (weak, nonatomic) IBOutlet UIImageView *connectingAnimationImageView;
@property (weak, nonatomic) IBOutlet UILabel *participantName;
@property (weak, nonatomic) IBOutlet UILabel *callerName;
@property (weak, nonatomic) IBOutlet UILabel *callEndedLabel;
@property (weak, nonatomic) IBOutlet UILabel* statusLabel;

-(NSMutableArray*)getAnimationImages;

@end

@implementation WaitingVideoViewController
	
const int CONNECTING_ANIMATION_IMAGES_COUNT = 13;
const int CONNECTING_ANIMATION_IMAGES_IPHONE_COUNT = 29;
const int CONNECTING_ANIMATION_DURATION = 2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init
{
    self = [self initWithNibName:@"WaitingVideoViewController" bundle:nil];
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.statusLabel.text = self.statusText;
    
    // Do any additional setup after loading the view from its nib.

   /* Contact* contact = [[[[SessionManager sharedSessionManager] getCurrentSession] getParticipants] objectAtIndex:0];
    calleeImage.image = [contact getAvatarImage];
    callerImage.image = [[[HomeUser sharedHomeUser] homeUser] getAvatarImage];
    participantName.text = [contact fullName];
    callerName.text = [[HomeUser sharedHomeUser].homeUser fullName];*/
    
    self.connectingAnimationImageView.animationImages = [self getAnimationImages];
    self.connectingAnimationImageView.animationDuration = CONNECTING_ANIMATION_DURATION;
    self.connectingAnimationImageView.animationRepeatCount = 0; //Repeats indefinitely
    [self.connectingAnimationImageView startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.connectingAnimationImageView stopAnimating];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


-(NSMutableArray*)getAnimationImages 
{
    NSMutableArray* images = [[NSMutableArray alloc] init];

    for (int i=0; i< CONNECTING_ANIMATION_IMAGES_IPHONE_COUNT; i++)
    {
        if (i < 10)
        {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"iPhone_loader_0000%d.png", i]]];
        }
        else
        {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"iPhone_loader_000%d.png", i]]];
        }
    }
    
    return images;
}

@end
