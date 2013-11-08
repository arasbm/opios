//
//  SessionViewController_iPhone.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 11/4/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "SessionViewController_iPhone.h"
#import "Session.h"
#import "SessionManager.h"
#import "ChatViewController.h"
#import "AudioCallViewController.h"
#import "Utility.h"
#import <OpenPeerSDK/HOPCall.h>

@interface SessionViewController_iPhone ()
{
    UILabel* labelTitle;
}
@property (nonatomic, weak) IBOutlet UIView* containerView;

//It is set to strong because during life cycle it will be situations when this constrain will be removed from self.view. (e.g. showing keyboard)
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomViewContainer;

@property (strong, nonatomic)  NSLayoutConstraint *constraintHeightViewContainer;
@property (strong, nonatomic)  UILabel* labelTitle;
@property (strong, nonatomic)  UILabel* labelDuration;

- (void) actionCallMenu;
- (IBAction) startAudioSession:(id)sender;
@end

@implementation SessionViewController_iPhone


- (NSLayoutConstraint *)constraintHeightViewContainer
{
    if (!_constraintHeightViewContainer)
    {
        _constraintHeightViewContainer = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.view.frame.size.height];
    }
    
    
    return _constraintHeightViewContainer;
}

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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.chatViewController = [[ChatViewController alloc] initWithSession:self.session];
    self.chatViewController.delegate = self;
    
    [self.chatViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.containerView addSubview:self.chatViewController.view];
    
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    // Lightning button
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"iPhone_lightning_bolt.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(actionCallMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    UIBarButtonItem *navBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView: menuButton];
    self.navigationItem.rightBarButtonItem = navBarMenuButton;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"iPhone_back_button.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backButton];
    
    UIView* titleView = [[ UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 44.0)];
    titleView.backgroundColor = [UIColor clearColor];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 4.0, 180.0, 24.0)];
    self.labelTitle.text = [[[self.session participantsArray]objectAtIndex:0] name];
    [self.labelTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22.0]];
    self.labelTitle.textColor = [UIColor whiteColor];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    
    self.labelDuration = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 24.0, 160.0, 16.0)];
    [self.labelDuration setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    self.labelDuration.textColor = [UIColor whiteColor];
    self.labelDuration.text = @"Duration: 00:00:00";
    self.labelDuration.textAlignment = NSTextAlignmentCenter;
    
    [titleView addSubview:self.labelTitle];
    [titleView addSubview:self.labelDuration];
    
    [self.navigationItem setTitleView:titleView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    if (self.containerView == self.chatViewController.view.superview)
        [self.chatViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChatViewControllerDelegate

- (void) prepareForKeyboard:(NSDictionary*) userInfo showKeyboard:(BOOL) showKeyboard
{
    if (showKeyboard)
    {
        NSValue *keyboardFrameValue = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
        
        self.constraintBottomViewContainer.constant = keyboardFrame.size.height;
        
        if (self.audioCallViewController.view && self.audioCallViewController.view.hidden == NO)
            self.audioCallViewController.view.hidden = YES;
    }
    else
    {
        self.constraintBottomViewContainer.constant = 0;
    }
}

- (void) actionCallMenu
{
    if(self.audioCallViewController != nil && self.audioCallViewController.view.hidden)//&& self.audioCallViewController.isViewLoaded && self.audioCallViewController.view.window)
    {
        [self.chatViewController.messageTextbox resignFirstResponder];
        self.audioCallViewController.view.hidden = NO;
        //[self.audioCallViewController.view removeFromSuperview];
        
    }
    /*else if(videoContainerViewController != nil)
     {
     [self.videoContainerViewController.view removeFromSuperview];
     }*/
    else
    {
        //If call is not in progress show action sheet
        if (!self.audioCallViewController)
        {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Call options", @"")
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
            
            NSMutableArray* buttonTitles = [[NSMutableArray alloc] init];
            
            //int i = 0;
            
            [buttonTitles addObject:NSLocalizedString(@"Audio Call", @"")];
            [buttonTitles addObject:NSLocalizedString(@"Video Call", @"")];
            //[buttonTitles addObject:NSLocalizedString(@"Close session", @"")];
            [buttonTitles addObject:NSLocalizedString(@"Cancel", @"")];
            
            if (action)
            {
                for (int i = 0; i < [buttonTitles count]; i++)
                {
                    [action addButtonWithTitle:[buttonTitles objectAtIndex:i]];
                }
                
                [action showFromRect:self.view.frame inView:self.view.superview animated:YES];
            }
        }
//        else //show call controller
//        {
//            [self.chatViewController.messageTextbox resignFirstResponder];
//            //[self.view addSubview:self.audioCallViewController.view];
//            if (self.audioCallViewController.view.hidden == YES)
//                self.audioCallViewController.view.hidden = NO;
//        }
    }
    
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSLog(@"index: %d", buttonIndex);
    
    switch (buttonIndex)
    {
        case 0:
            [self startAudioSession:nil];
            break;
        case 1:
            //[self startVideoSession:nil];
            break;
        case 2:
            //[self closeSession:nil];
            break;
        default:
            break;
    }
}

- (IBAction) startAudioSession:(id)sender
{
    [self.chatViewController hideKeyboard];
    
    if (!self.audioCallViewController)
    {
        self.audioCallViewController = [[AudioCallViewController alloc] initWithSession:self.session];
        //self.audioCallViewController.view.frame = self.chatViewController.chatTableView.frame;
        [self.audioCallViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.containerView addSubview:self.audioCallViewController.view];
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.audioCallViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.audioCallViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.audioCallViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.chatViewController.typingMessageView.frame.size.height]];
        
        [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.audioCallViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    }
    else
    {
        if (self.audioCallViewController.view.hidden == YES)
            self.audioCallViewController.view.hidden = NO;
    }
    
    
    [self.audioCallViewController callStarted];
    [[SessionManager sharedSessionManager] makeCallForSession:self.session includeVideo:NO isRedial:NO];
}

- (void) updateCallState
{
    NSString *stateStr = [Utility getCallStateAsString:[self.session.currentCall getState]];
    if ([stateStr length] > 0)
        [self.labelDuration setText:stateStr];
}

//-(void)updateCallDuration
//{
//    self.callDuration++;
//    NSInteger secs =    self.callDuration % 60;
//    NSInteger mins = (self.callDuration / 60) % 60;
//    NSInteger hrs = (self.callDuration / 3600);
//    
//    self.labelDuration.text = [NSString stringWithFormat:@"%@: %02i:%02i:%02i", NSLocalizedString(@"Duration", @""), hrs, mins, secs];
//}
@end

