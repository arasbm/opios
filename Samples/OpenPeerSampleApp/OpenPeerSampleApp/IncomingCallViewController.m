
//
//  IncomingCallViewController.m
//  Hookflash
//
//  Created by Zeljko Turbic on 11-09-11.
//  Copyright 2012 SMB Phone Inc. All rights reserved.
//

#import "IncomingCallViewController.h"
#import "SessionManager.h"
#import "SoundsManager.h"

#import <OpenPeerSDK/HOPCall.h>
#import <OpenPeerSDK/HOPRolodexContact+External.h>
#import <OpenPeerSDK/HOPAvatar.h>
#import <OpenPeerSDK/HOPImage.h>
#import "Session.h"

@interface IncomingCallViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *bgImgView;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewCallerAvatar;

@property (nonatomic, weak) IBOutlet UIButton *buttonAccept;
@property (nonatomic, weak) IBOutlet UIButton *buttonDecline;

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) IBOutlet UILabel *labelCallType;
@property (nonatomic, weak) IBOutlet UILabel *labelCaller;
@end

@implementation IncomingCallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithSession:(Session*) inSession
{
    self = [self initWithNibName:@"IncomingCallView_iPhone" bundle:nil];
    if (self)
    {
        self.session = inSession;
    }
    return self;
}

-(IBAction)acceptCall:(id)sender
{
    [[SessionManager sharedSessionManager] answerCallForSession:self.session];
}

-(IBAction)declineCall:(id)sender
{
    [[SessionManager sharedSessionManager] endCallForSession:self.session];
}

- (IBAction)toggleSilent:(id)sender 
{
    [[SoundManager sharedSoundsManager] stopCallingSound];
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

    HOPRolodexContact* rolodexContact = [self.session.participantsArray objectAtIndex:0];
    
    self.labelCallType.text = [self.session.currentCall hasVideo] ? NSLocalizedString(@"Video call from", nil) : NSLocalizedString(@"Audio call from", nil);
    
    self.buttonAccept.imageView.image = [self.session.currentCall hasVideo] ? [UIImage imageNamed:@"video_indicator_white_big.png"] : [UIImage imageNamed:@"handset_accept_icon.png"];
    
    self.labelCaller.text = rolodexContact.name;
    
    rolodexContact.profileURL = @"http://www.blic.rs";
    if ([rolodexContact.profileURL length] > 0)
    {
        NSURL* url = [NSURL URLWithString:rolodexContact.profileURL];
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    }
    
    HOPAvatar* avatar = [rolodexContact getAvatarForWidth:[NSNumber numberWithFloat:self.imageViewCallerAvatar.frame.size.width] height:[NSNumber numberWithFloat:self.imageViewCallerAvatar.frame.size.height]];

    if (avatar && avatar.avatarImage.image)
    {
        [self.imageViewCallerAvatar setImage:[UIImage imageWithData:avatar.avatarImage.image]];
    }
    [self.webView.layer setCornerRadius:5.0];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// ================================================================================================
// UIWebView delegate
// ================================================================================================
#pragma mark - UIWebView delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
}


@end
