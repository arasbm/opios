//
//  SessionViewController_iPhone.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 11/4/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Delegates.h"

@class Session;
@class ChatViewController;
@class AudioCallViewController;
@class VideoCallViewController;
@class WaitingVideoViewController;

@interface SessionViewController_iPhone : UIViewController<UINavigationControllerDelegate,ChatViewControllerDelegate,VideoCallViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) Session* session;
@property (nonatomic, strong) ChatViewController* chatViewController;
@property (nonatomic, strong) AudioCallViewController* audioCallViewController;
@property (nonatomic, strong) VideoCallViewController* videoCallViewController;
@property (nonatomic, strong) WaitingVideoViewController* waitingVideoViewController;

- (id) initWithSession:(Session*) inSession;
- (void) updateCallState;
- (void) showIncomingCall:(BOOL) show;
- (void) startCallWithVideo:(BOOL) videoCall;
- (IBAction) startAudioSession:(id)sender;
- (IBAction) startVideoSession:(id)sender;
- (void) removeCallViews;
- (void) startTimer;
- (void) stopTimer;
- (void) onCallEnded;
@end


