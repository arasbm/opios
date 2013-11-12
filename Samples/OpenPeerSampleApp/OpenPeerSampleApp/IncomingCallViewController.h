//
//  IncomingCallViewController.h
//  Hookflash
//
//  Created by Zeljko Turbic on 11-09-11.
//  Copyright 2012 SMB Phone Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>


@class Session;

@interface IncomingCallViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) Session* session;

- (id)initWithSession:(Session*) inSession;

- (IBAction)acceptCall:(id)sender;
- (IBAction)declineCall:(id)sender;
- (IBAction)toggleSilent:(id)sender;

@end
