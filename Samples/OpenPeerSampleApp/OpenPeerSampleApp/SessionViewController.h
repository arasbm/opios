/*
 
 Copyright (c) 2013, SMB Phone Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies,
 either expressed or implied, of the FreeBSD Project.
 
 */

#import <UIKit/UIKit.h>
#import "Delegates.h"

@class AudioCallViewController;
@class VideoCallViewController;
@class ChatViewController;
@class Message;
@class Session;

@interface SessionViewController : UIViewController<UIActionSheetDelegate,ChatViewControllerDelegate>

@property(nonatomic,assign) Session* session;
@property(nonatomic,assign) NSMutableArray *arrayMessages;
@property(nonatomic,assign) BOOL shouldCloseSession;

@property (strong, nonatomic) ChatViewController* chatViewController;
@property (strong, nonatomic) AudioCallViewController* audioCallViewController;
@property (strong, nonatomic) VideoCallViewController* videoCallViewController;

- (id)initWithSession:(Session*)inSession;

- (void)refreshViewWithData;
- (void)setFramesSizes;
- (float)getHeaderHeight:(float)tableViewHeight;

- (float)getHeaderHeight:(float)tableViewHeight;

- (void)setMessage:(Message *)message;
- (void) updateSessionView;

- (void)registerForNotifications:(BOOL)registerForNotifications;

- (void) showVideoCall;
- (void) showAudioCall;

- (void) handleCallStateChanged;

/*- (void) handleAudioRouteChanged:(AudioRouteType)route;

- (IBAction) closeSession:(id) sender;

-(void)addIMSystemMessage:(NSString *)message forMessageEvent:(MessageEvent)messageEvent;
- (void)sendIMmessage:(NSString *)message toRecipient:(id)recipient forMessageEvent:(MessageEvent)messageEvent andImage:(UIImage*)img;
- (void)sendIMmessage:(NSString *)message;

- (void)callIsEnded:(NSNotification *)notification;
*/
- (IBAction)startVideoSession:(id)sender;
- (IBAction)startAudioSession:(id)sender;

- (void)setDefaults;

- (void) setKeyboardIsHidden:(BOOL) hidden;

@end
