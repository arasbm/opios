//
//  SessionViewController_iPhone.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 11/4/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;
@class ChatViewController;
@interface SessionViewController_iPhone : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, strong) Session* session;
@property (nonatomic, strong) ChatViewController* chatViewController;


- (id) initWithSession:(Session*) inSession;
@end
