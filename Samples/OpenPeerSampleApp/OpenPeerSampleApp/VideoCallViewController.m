//
//  VideoViewController_iPhone.m
//  Hookflash
//
//  Created by Tomislav Filipovic on 5/30/12.
//  Copyright (c) 2012 SMB Phone Inc. All rights reserved.
//

#import "VideoCallViewController.h"
#import "WaitingVideoViewController.h"

#import "Utility.h"

@interface VideoCallViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *receivingVideoView;
@property (weak, nonatomic) IBOutlet UIImageView *sendingVideoView;
@property (strong, nonatomic) WaitingVideoViewController *waitingVideoViewController;
@property (weak, nonatomic) IBOutlet UIButton *buttonShowMyVideo;

- (void) customizeTopVideoButton : (UIButton*) button;
- (void) setOrientation;
- (void) setMyVideoFrameWithOrientation;
- (UIImageOrientation) getImageOrientation;

@end


@implementation VideoCallViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}
- (id) initWithSession:(Session*) inSession
{
    self = [self initWithNibName:@"VideoCallViewController" bundle:nil];
    if (self) 
    {
        self.session = inSession;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}


- (UIImageOrientation) getImageOrientation
{
    UIImageOrientation orientation;
    switch ([Utility getCurrentOrientation])
    {
        case UIInterfaceOrientationLandscapeLeft:
            orientation = UIImageOrientationLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
        default:
            orientation = UIImageOrientationRight;
            break;
    }
    
    return orientation;
}
-(void)setImageForMainVideoView:(UIImage*) img
{
    if (UIInterfaceOrientationIsLandscape([Utility getCurrentOrientation]))
    {
        UIImage * rotatedImage = [[UIImage alloc] initWithCGImage: img.CGImage
                                                             scale: 1.0
                                                       orientation: [self getImageOrientation]];
        
        [self.receivingVideoView performSelectorOnMainThread:@selector(setImage:) withObject:rotatedImage waitUntilDone:NO];
    }
    else
        [self.receivingVideoView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
    
    }


-(void)setImageForMyVideoThumbnailView:(UIImage*) img
{
    if (UIInterfaceOrientationIsLandscape([Utility getCurrentOrientation]))
    {
        UIImage * rotatedImage = [[UIImage alloc] initWithCGImage: img.CGImage
                                                             scale: 1.0
                                                       orientation: [self getImageOrientation]];
        
        [self.sendingVideoView performSelectorOnMainThread:@selector(setImage:) withObject:rotatedImage waitUntilDone:NO];
    }
    else 
    {
        [self.sendingVideoView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:NO];
    }
}

- (void) showEndCallScreen
{
    /*WaitingVideoViewController *endCallScreen = [[WaitingVideoViewController alloc] initWithNibName:@"WaitingVideoView_iPhone" bundle:nil];
    [self.view addSubview:endCallScreen.view];
    endCallScreen.connectingAnimationImageView.hidden = YES;
    endCallScreen.callEndedLabel.hidden = NO;
    
    [self endVideoCall];
    
    self.mediaNavigationViewController.labelCallState.text = @"Call ended";
    [endCallScreen.view setFrame:CGRectMake(0.0, 20.0, 320.0, 410.0)];
    
    [endCallScreen release];*/

}

- (IBAction) actionEndCall:(id) sender
{
    [self showEndCallScreen];
    //[super actionEndCall:sender];
    //[[ActionManager sharedActionManager] hangupCallForSession:self.session forReason:ICall::CallClosedReason_User];
}

- (void) endVideoCall
{
    //[self playSoundForSessionState];

    /*if (_isFullScreenMode)
    {
        [self actionFullScreen:nil];
    }*/
}


- (void) showWaitingScreen
{
    //_controlView.hidden = NO;
    //return;
    //[self hideControllButtons:YES];
    if (self.waitingVideoViewController == nil)
    {
        self.waitingVideoViewController = [[WaitingVideoViewController alloc] init];
    }
    
    self.waitingVideoViewController.view.frame = self.waitingViewContainer.bounds;
    [self.waitingViewContainer addSubview:self.waitingVideoViewController.view];
    self.waitingViewContainer.hidden = NO;
    [self.view bringSubviewToFront:self.waitingViewContainer];
    //[self.waitingVideoViewController setFrame:CGRectMake(0.0, 25.0, 320.0, 460.0 - self.mediaNavigationViewController.view.frame.size.height)];
//    [muteButton setAlpha:0.0];
//    [chatButton setAlpha:0.0];
//    [speakerButton setAlpha:0.0];
//    [switchCameraButton setAlpha:0.0];
//    [_buttonShowHideMe setAlpha:0.0];
//    [self.mediaNavigationViewController.buttonEndVideoCall setBackgroundImage:[UIImage imageNamed:[Hookflash_ThemeManager getImagePath:ki_iPhone_xEndCallButton]] forState:UIControlStateNormal];
//    [self.mediaNavigationViewController.buttonEndVideoCall setTitle:@"" forState:UIControlStateNormal];
//    [self.mediaNavigationViewController.buttonEndVideoCall setFrame:CGRectMake(285.0, 23.0, 21.0, 22.0)];
//    self.mediaNavigationViewController.imgRightSeparator.hidden = NO;
}

- (void) hideWaitingScreen
{
    if (self.waitingVideoViewController != nil)
    {
        [self.waitingVideoViewController.view removeFromSuperview];
        self.waitingVideoViewController = nil;
        //[self hideControllButtons:NO];
    }
    self.waitingViewContainer.hidden = YES;
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.buttonShowMyVideo setAlpha:1.0];
                    }
                     completion:^(BOOL finished)
                    {
                        [UIView animateWithDuration:1.0
                                         animations:^{
                                             [self.muteButton setAlpha:1.0];
                                         }
                                         completion:^(BOOL finished)
                                        {
                                            [UIView animateWithDuration:1.0
                                                             animations:^{
                                                                [self.switchCameraButton setAlpha:1.0];
                                                            }
                                                            completion:^(BOOL finished)
                                                            {
                                                                [UIView animateWithDuration:1.0
                                                                                 animations:^{
                                                                                    [self.chatButton setAlpha:1.0];
                                                                                }
                                                                                completion:^(BOOL finished)
                                                                                {
                                                                                    self.muteButton.enabled = YES;
                                                                                    self.switchCameraButton.enabled = YES;
                                                                                    self.chatButton.enabled = YES;
                                                                                    self.buttonShowMyVideo.enabled = YES;
                                                                                }];
                                                            }];
                                        }];                                                
                    }];
    [self.buttonShowMyVideo setHidden:YES];
//    [self.mediaNavigationViewController.buttonEndVideoCall setBackgroundImage:[UIImage imageNamed:[Hookflash_ThemeManager getImagePath:ki_iPhone_redEndCallButton]] forState:UIControlStateNormal];
//    [self.mediaNavigationViewController.buttonEndVideoCall setTitle:@"END" forState:UIControlStateNormal];
//    [self.mediaNavigationViewController.buttonEndVideoCall setFrame:CGRectMake(260.0, 16.0, 58.0, 37.0)];
//    self.mediaNavigationViewController.imgRightSeparator.hidden = YES;
}



#pragma mark - Call states handling
-(void)handleCallStateChanged
{
    /*NSMutableString *ms = [[NSMutableString alloc] initWithString:@""];
    
    switch ([self.session getCall]->getState()) 
    {
        case ICall::CallState_Preparing:
        {
            if ([self.session getCall]->getCaller()->isSelf())
            {
                [ms appendString:NSLocalizedString(@"Calling", @"")];
                //                [ms appendString:@" "];
                //                NSString* displayName = [self.session getDisplayName];
                //                if (displayName != nil)
                //                    [ms appendString:displayName];
                //                else
                //                    [ms appendString:@"Unknown caller"];
                //                
                //                lblCallDuration.text = @"00:00:00";
            }
        }
            
            break;
            
        case ICall::CallState_Ringing:
        {
            [ms appendString:NSLocalizedString(@"Calling", @"")];
        }
            break;
        case ICall::CallState_Ringback:
        {
            [ms appendString:NSLocalizedString(@"Ringing", @"")];
        }
            break;
            
        case ICall::CallState_Placed:
        {
            [ms appendString:NSLocalizedString(@"Calling", @"")];
        }
            break;
            
        case ICall::CallState_Early:
        {
            NSLog(@">>> AudioCallViewController_iPad -> callState: CallState_Early");
            //                [ms setString:@""];
            //                [ms appendString:NSLocalizedString(@"Connected", @"")];
            //                [ms appendString:@" ..."];
        }
            break;
            
        case ICall::CallState_Open:
            NSLog(@">>> AudioCallViewController_iPad -> callState: CallState_Open | CallState_Active");
            // call is started or resumed
            //            if(_isCallMuted && _isCallRecording)
            //            {
            //                imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigRecordingMutededIcon]; 
            //                [ms setString:NSLocalizedString(@"Call Muted", @"")];
            //            }
            //            else
            //            {
            //                if(_isCallMuted)
            //                {
            //                    imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigMutedIcon];
            //                    [ms setString:NSLocalizedString(@"Call Muted", @"")];
            //                }
            //                if(_isCallRecording)
            //                {
            //                    imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigInProgressRecordingIcon];
            //                    [ms setString:NSLocalizedString(@"Call Recording", @"")];
            //                }
            //                if(!_isCallRecording && !_isCallMuted)
            //                {
            //                    imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigInProgressIcon];
            //                    [ms setString:NSLocalizedString(@"Call In-Progress", @"")];
            //                }
            //            }
            
            //[self setSessionParticipantCount];
            
            //[ms appendString:NSLocalizedString(@"Duration: 00:00:00", @"")];
            
            [self hideWaitingScreen];
            
            if(_sessionDuration == 0)
            {
                [ms appendString:NSLocalizedString(@"Duration: 00:00:00", @"")];
                // call is just started
            }
            
            if (!_tmrSessionDuration)
                _tmrSessionDuration = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCallDuration) userInfo:nil repeats:YES];
            break;
            
        case ICall::CallState_Hold:
            [ms setString:NSLocalizedString(@"Call Paused", @"")];
            // call is on hold
            //            NSLog(@">>> AudioCallViewController_iPad -> callState: CallState_Hold");
            //            if(_isCallRecording)
            //                imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigRecordingPausedIcon];
            //            else
            //                imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigPausedIcon];
            //            [ms setString:NSLocalizedString(@"Call Paused", @"")];
            //            [btnPause setImage:[Hookflash_ThemeManager imageNamed:ki_AudioCallUnpausedIcon] forState:UIControlStateNormal];
            
            break;
        case ICall::CallState_Closed:
            NSLog(@">>> AudioCallViewController_iPad -> callState: CallState_Closed");
            //if (!callEnded)
            //    [self callHangup:nil];
            break;
            
            
            
        default:
            break;
    }
    
    //self.mediaNavigationViewController.labelCallState.text = ms;
    
    // set objects visiblity 
    //[self setVisibilityForCallState];
*/
}


- (IBAction)actionSwitchToSpeaker:(id)sender
{
    /*
    UIImage *buttonImage = [Hookflash_ThemeManager imageNamed:ki_iPhone_speakerIcon];
    UIImage *overlayedSpeaker = [self getOverlayedImage:buttonImage];
    
    if(isSpeakerOn)
    {
        [MediaEngineController switchAudioOutput:false];
        [speakerButton setImage:buttonImage forState:UIControlStateNormal];
    }
    else
    {
        [MediaEngineController switchAudioOutput:true];
        [speakerButton setImage:overlayedSpeaker forState:UIControlStateNormal];
    }
    isSpeakerOn = !isSpeakerOn;
     */
}

//- (UIImage *) getOverlayedImage:(UIImage *) image
//{
//    return [Hookflash_Utils imageWithOverlay:image overlayColor:[UIColor colorWithRed:57.0/255.0 green:185.0/255.0 blue:202.0/255.0 alpha:1.0]];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //_showScrollButtons= NO;
   /* sliderViewController = [[SliderViewController alloc] init];
    sliderViewController.delegate = self;
    
    scrollView.contentSize = participantsContainerView.frame.size;
    
    [buttonRecording setButtonImage:ki_btnRecord];
    [buttonRecording setPulsingIconPadding:CGPointMake(5.5, -1.5)];
    
    
    [self actionShowParticipantsHideParticipants:nil];*/
    
/*#ifdef ENABLE_ADDING_MORE_PARTICIPANTS_IN_SESSION 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addParticipant:) name:kNewParticipantAdded object:nil];
#endif
    */
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:kOrientationChanged object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showEndCallScreen) name:@"videoCallEnded" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageBadgeIndicator:) name:kNewChatMessageArrivedInVideoCallNotification object:nil];    
//    
//    CGRect r = _myCameraView.frame;
//    r.origin.x = 0;
//    r.origin.y = 0;
//    myVideoThumbnail.view.frame  = r;
////    r.size.height = myVideoThumbnail.view.frame.size.height;
////    r.size.width = myVideoThumbnail.view.frame.size.width;
////    
////    _myCameraView.frame = r;
//   // [self setMyVideoFrameWithOrientation];
//    
//    [_myCameraView addSubview:myVideoThumbnail.view];
//    // Make sure the _myCameraView is hidden once it's clicked:
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(actionShowMeHideMe:)];
//    [self.view addGestureRecognizer:singleFingerTap];
//    [singleFingerTap setNumberOfTapsRequired:1];
//    [singleFingerTap release];
    
//    //The event handling method
//    - (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
//        CGPoint location = [recognizer locationInView:[recognizer.view superview]];
//        
//        //Do stuff here...
//    }
    
   /* if (_myViewShown)
        [buttonStartStopSendingVideo setImage:[Hookflash_ThemeManager imageNamed:ki_btnCameraOn] forState:UIControlStateNormal];
    else
        [buttonStartStopSendingVideo setImage:[Hookflash_ThemeManager imageNamed:ki_btnCameraOff] forState:UIControlStateNormal];
    
    [buttonStartStopReceivingVideo setImage:[Hookflash_ThemeManager imageNamed:ki_btnMakeVideoCall] forState:UIControlStateNormal];*/
    
    //buttonShowHideMe.selected = YES;
    
   // buttonMicStatus.selected = _micMuted;
    
/*#ifndef SHOW_VIDEO_BUTTONS
    btnQualityStatistics.frame = buttonMicStatus.frame;
    buttonStartStopSendingVideo.hidden = YES;
    buttonOnHold.hidden = YES;
    buttonRecording.hidden = YES;
    buttonMicStatus.hidden = YES;
#endif*/
    
    _previousOrientation = UIInterfaceOrientationPortrait;
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
//    [self.mediaNavigationViewController.view setFrame:CGRectMake(self.mediaNavigationViewController.view.frame.origin.x, self.mediaNavigationViewController.view.frame.origin.y, self.mediaNavigationViewController.view.frame.size.width + 1, self.mediaNavigationViewController.view.frame.size.height)];
//    [self.badgeView setHidden:YES];
//    
//    //[((HookflashAppDelegate*)[[UIApplication sharedApplication] delegate]) set_renderView1:_mainVideoView];
//    //[((HookflashAppDelegate*)[[UIApplication sharedApplication] delegate]) set_renderView2:myVideoThumbnail.participantImageView];
//
//    _mediaEngineController = [[MediaEngineController alloc] init];
//    [_mediaEngineController setRendererViews:_mainVideoView previewVideoView:myVideoThumbnail.participantImageView];
//    
    [self orientationChanged];
}

- (void)viewDidUnload
{
    [self setViewBottomControl:nil];
    [self setReceivingVideoView:nil];
    [self setSendingVideoView:nil];
    [self setButtonShowMyVideo:nil];
    [super viewDidUnload];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNewChatMessageArrivedInVideoCallNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOrientationChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"videoCallEnded" object:nil];

    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // TODO
    // This should be YES here, because video has better user experience if it's in landscape. But, if it is YES, then we need a way to handle orientation stuff once we are back from VideoCallViewController into wherever else. Only Video has ability to be represented in both orientations, so when another view is shown from a landscape orientation it will call it's shouldAutorotateToInterfaceOrientation:interfaceOrientation which returns (interfaceOrientation == UIInterfaceOrientationPortrait) which is NO. So it will be stuck in landscape (instead of being stuck in portrait). -> in theory...

    
}

// This method isn't being called, because of the MainViewController_iPhone's (BOOL)shouldAutorotate, which is a parent... No time to fix it now.
- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    if ([self.waitingViewContainer isHidden])
    {
        return YES;
    }
    else
    {
        return orientation == UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - Actions
//-(void) actionShowHideControl:(id) sender
//{
//    [self showHideVideoControl];
//}

- (void) hideControllButtons : (BOOL) hide
{
    CGFloat startAlpha = hide ? 1.0 : 0.0;
    CGFloat endAlpha = hide ? 0.0 : 1.0;

    [self.viewBottomControl setAlpha:startAlpha];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2];

    [self.viewBottomControl setAlpha:endAlpha];
    
	//[UIView commitAnimations];
    //_controlShown = !_controlShown;
    
    //[self.delegateSessionViewContorller hideNavigation:hide];
    
    /*CGRect previewCameraRect = _myCameraView.frame;
    if (!_controlShown)
    {
        previewCameraRect.origin.y += viewBottomControl.frame.size.height;
    }
    else 
    {
        previewCameraRect.origin.y = viewBottomControl.frame.origin.y - previewCameraRect.size.height - 4.0;
    }
    
    _myCameraView.frame = previewCameraRect;*/
    
    [UIView commitAnimations];
}


- (IBAction)actionShowChat:(id)sender 
{
//    [self.delegateSessionViewContorller showChat];
//    badgeNumber = 0;
//    [badgeView setHidden:YES];
}

- (IBAction) muteCall:(id)sender
{/*
    UIImage *buttonImage = [Hookflash_ThemeManager imageNamed:ki_iPhone_muteIcon];
    //UIImage *overlayedMute = [self getOverlayedImage:buttonImage];

    [super muteCall:sender];
    isCallMuted = !isCallMuted;
    if(isCallMuted)
    {
        //[muteButton setImage:overlayedMute forState:UIControlStateNormal];
    }
    else
    {
        [muteButton setImage:buttonImage forState:UIControlStateNormal];
    }*/
}

- (void)updateMessageBadgeIndicator:(NSNotification*)notification
{
    /*Session* inSession = [notification object];
    if (inSession == self.session && (!_chatActionStarted || _isFullScreenMode))
    {
        badgeNumber += 1;
        badgeView.hidden = NO;
        badgeView.badgeText = [NSString stringWithFormat:@"%d", badgeNumber];
        [badgeView setBadgeHidden:NO];
    }*/
}

- (void)orientationChanged
{
    [self setOrientation];
    //[self setMyVideoFrameWithOrientation];
}

- (void) setOrientation
{
    //[_mediaEngineController setVideoOrientation];
}

+(UIInterfaceOrientation)getCurrentOrientation
{
    UIInterfaceOrientation currentInterfaceOrientation;// = [[UIDevice currentDevice] orientation];
    UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
    
    if(currentDeviceOrientation == 0 || currentDeviceOrientation  == 5 || currentDeviceOrientation == 6)
        currentInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    else
        currentInterfaceOrientation = (UIInterfaceOrientation) currentDeviceOrientation;
    
    return currentInterfaceOrientation;
    
    //return [[UIApplication sharedApplication] statusBarOrientation];
}

- (void) setMyVideoFrameWithOrientation
{
//    CGRect rect = _myCameraView.frame;
//    if ((UIInterfaceOrientationIsLandscape([Hookflash_Utils getCurrentOrientation]) && rect.size.width < rect.size.height) ||
//        (UIInterfaceOrientationIsPortrait([Hookflash_Utils getCurrentOrientation]) && rect.size.width > rect.size.height))
//    {
//        float temp = rect.size.width;
//        rect.size.width = rect.size.height;
//        rect.size.height = temp;
//        _myCameraView.frame = rect;
//        
//        rect.origin.x = 0;
//        rect.origin.y = 0;
//        myVideoThumbnail.view.frame = rect;
//    }
    
    CGFloat rotationAngle = 0.0;
    switch ([VideoCallViewController getCurrentOrientation])
    {
            rotationAngle = 0.0;
//        case UIInterfaceOrientationPortrait:
//        {
//            switch (_previousOrientation)
//            {
//                case UIInterfaceOrientationPortrait:
//                    rotationAngle = 0.0;
//                    break;
//                case UIInterfaceOrientationPortraitUpsideDown:
//                    rotationAngle = M_PI;
//                    break;
//                case UIInterfaceOrientationLandscapeLeft:
//                    rotationAngle = 1.5*M_PI;
//                    break;
//                case UIInterfaceOrientationLandscapeRight:
//                    rotationAngle = 0.5*M_PI;
//                    break;
//            }
//        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            rotationAngle = M_PI;
//            switch (_previousOrientation)
//            {
//                case UIInterfaceOrientationPortrait:
//                    rotationAngle = M_PI;
//                    break;
//                case UIInterfaceOrientationPortraitUpsideDown:
//                    rotationAngle = 0.0;
//                    break;
//                case UIInterfaceOrientationLandscapeLeft:
//                    rotationAngle = 0.5*M_PI;
//                    break;
//                case UIInterfaceOrientationLandscapeRight:
//                    rotationAngle = 1.5*M_PI;
//                    break;
//            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            rotationAngle = 1.5*M_PI;
//            switch (_previousOrientation)
//            {
//                case UIInterfaceOrientationPortrait:
//                    rotationAngle = 0.5*M_PI;
//                    break;
//                case UIInterfaceOrientationPortraitUpsideDown:
//                    rotationAngle = 1.5*M_PI;
//                    break;
//                case UIInterfaceOrientationLandscapeLeft:
//                    rotationAngle = 0.0;
//                    break;
//                case UIInterfaceOrientationLandscapeRight:
//                    rotationAngle = M_PI;
//                    break;
//            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            rotationAngle = 0.5*M_PI;
//            switch (_previousOrientation)
//            {
//                case UIInterfaceOrientationPortrait:
//                    rotationAngle = 0.5*M_PI;
//                    break;
//                case UIInterfaceOrientationPortraitUpsideDown:
//                    rotationAngle = 1.5*M_PI;
//                    break;
//                case UIInterfaceOrientationLandscapeLeft:
//                    rotationAngle = M_PI;
//                    break;
//                case UIInterfaceOrientationLandscapeRight:
//                    rotationAngle = 0.0;
//                    break;
//            }
        }
            break;
    }
    
    //_previousOrientation = [Hookflash_Utils getCurrentOrientation];
    
//    CABasicAnimation* spinAnimation = [CABasicAnimation
//                                       animationWithKeyPath:@"transform.rotation"];
//    spinAnimation.duration = 2.0;
//    
//     spinAnimation.removedOnCompletion = NO;//YES;
//    spinAnimation.toValue = [NSNumber numberWithFloat:rotationAngle];
//    [_mainVideoView.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(rotationAngle);
    //landscapeTransform = CGAffineTransformTranslate (landscapeTransform, +90.0, +90.0);
    
    [self.receivingVideoView setTransform:landscapeTransform];
    //[_myCameraView setTransform:landscapeTransform];
    //[myVideoThumbnail.participantImageView setTransform:landscapeTransform];
    
//    CGRect r = myVideoThumbnail.participantImageView.frame;
//    if (UIInterfaceOrientationIsLandscape([Hookflash_Utils getCurrentOrientation]))
//    {
//        r.size.width = 320.0;
//        r.size.height =240.0;
//    }
//    else
//    {
//        r.size.width = 120.0;
//        r.size.height= 160.0;
//    }
//    myVideoThumbnail.participantImageView.frame = r;
    [UIView commitAnimations];
}
@end
