//
//  VideoViewController_iPhone.h
//  Hookflash
//
//  Created by Tomislav Filipovic on 5/30/12.
//  Copyright (c) 2012 SMB Phone Inc. All rights reserved.
//

#import "CallViewController.h"

@interface VideoCallViewController : CallViewController
{
    UIInterfaceOrientation _previousOrientation;
    
    //IBOutlet UIBadgeView *badgeView;
    int badgeNumber;
}

//@property (assign, nonatomic) id<SessionViewControlleriPhoneDelegate> delegateSessionViewContorller;
//@property (retain, nonatomic) id <MainViewControllerDelegate> mainViewControllerDelegate;

@property (weak, nonatomic) IBOutlet UIView *viewBottomControl;
@property (weak, nonatomic) IBOutlet UIView* waitingViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

- (id) initWithSession:(Session*) inSession;
- (IBAction)actionSwitchToSpeaker:(id)sender;
@end
