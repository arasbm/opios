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

@interface SessionViewController_iPhone : UIViewController<UINavigationControllerDelegate,ChatViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) Session* session;
@property (nonatomic, strong) ChatViewController* chatViewController;
@property (nonatomic, strong) AudioCallViewController* audioCallViewController;

- (id) initWithSession:(Session*) inSession;
- (void) updateCallState;
@end


