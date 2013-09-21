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

#import "SessionViewController.h"
#import "ChatViewController.h"
#import "MessageManager.h"
#import "SessionManager.h"
#import "ChatMessageCell.h"
#import "Message.h"
#import "Session.h"
#import "AudioCallViewController.h"
#import "VideoCallViewController.h"

#define DEFAULT_CELL_HEIGHT 35

@interface SessionViewController ()

@end


@implementation SessionViewController


- (void)viewDidAppear:(BOOL)animated
{
    if (self.audioCallViewController)
    {
        [self.audioCallViewController viewDidAppear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    return;
}

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
    self = [self initWithNibName:@"SessionViewController" bundle:nil];
    {
        self.session = inSession;
        self.arrayMessages = inSession.messageArray;
        self.chatViewController  = [[ChatViewController alloc] initWithSession:self.session];
        self.chatViewController.delegate = self;
        [self addChildViewController:self.chatViewController];
        [self.chatViewController didMoveToParentViewController:self];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //if (!defaultsSet)
    //[self setDefaults];
    
    self.chatViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.chatViewController.view];
    
    // Lightning button
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"iPhone_lightning_bolt.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(actionCallMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    UIBarButtonItem *navBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView: menuButton];
    self.navigationItem.rightBarButtonItem = navBarMenuButton;
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
    
- (void)viewWillAppear:(BOOL)animated
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//Implement in child class
- (void)setFramesSizes
{
    
}

//Implement in child class
- (void) updateSessionView
{
    
}

//Implement in child class
- (void) showVideoCall
{
    
}

//Implement in child class
- (void) showAudioCall
{
    
}

- (void) handleCallStateChanged
{
//    if (audioCallViewController)
//        [audioCallViewController handleCallStateChanged];
//    
//    if (videoContainerViewController)
//        [videoContainerViewController handleCallStateChanged];
}

/*- (void) handleAudioRouteChanged:(AudioRouteType)route
{
  
}

- (IBAction) closeSession:(id) sender
{
    [self.view endEditing:YES];
    
    BOOL callHangup = self.session.type != CHAT;
    
    //If call is in progress first end call and then in callEnded remove session (put it in inActive state)
    if (callHangup)
    {
        self.shouldCloseSession = YES;
        
        [[ActionManager sharedActionManager] hangupCallForSession:self.session forReason:ICall::CallClosedReason_User];
    }
    else
    {
        [[ActionManager sharedActionManager] changeSessionState:self.session isActive:NO];
    }
}*/
/*
#pragma mark - Table Data Source Methods


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    CGRect rect = CGRectMake(0, 0, chatTableView.frame.size.width, chatHeight);
    UIView *v = [[UIView alloc] initWithFrame:rect];
    return [v autorelease];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSInteger row = indexPath.row;
    static NSString* MessageCellIdentifier;
    UITableViewCell* msgCell = nil;
    Message* message = nil;
    
    if (self.arrayMessages && [self.arrayMessages count] > 0) 
    {
        message = (Message*)[self.arrayMessages objectAtIndex:row];
    }
    else
    {
        return nil;
    }
    
    if (message.typeOfMessage == SYSTEM_MESSAGE) 
    {
        MessageCellIdentifier = @"systemMessageCellIdentifier";
        
        msgCell = (SystemMessageCell*)[tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier];
        
        if (msgCell == nil) 
        {
            msgCell = [[[SystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageCellIdentifier] autorelease];
        }
        
        [((SystemMessageCell*)msgCell) setMessageText:message.messageText];
        [((SystemMessageCell*)msgCell) setMessageDate:message.messageDate];
        [((SystemMessageCell*)msgCell) setMessageEvent:message.messageEvent];
        [msgCell setNeedsDisplay];
    } 
    else if (message.typeOfMessage == HISTORY_LINE) 
    {
        MessageCellIdentifier = @"historyLineMessageCellIdentifier";
        
        msgCell = (HistoryMessageCell*)[tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier];
        
        if (msgCell == nil) 
        {
            msgCell =[[[HistoryMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageCellIdentifier] autorelease];        
        }
    } 
    else if (message.typeOfMessage == STANDARD_MESSAGE && message.messageImage != nil) 
    {
        MessageCellIdentifier = @"ImageMessageCellIdentifier";
        
        msgCell = (ImageMessageCell*) [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier];
        
        if (msgCell == nil) 
        {
            msgCell = [[[ImageMessageCell alloc] initWithFrame:CGRectZero] autorelease];
        }
        
        [((ImageMessageCell*)msgCell) setMessageOwner:message.ownerContact];
        [((ImageMessageCell*)msgCell) setMessageImage:message.messageImage];
        [((ImageMessageCell*)msgCell) setMessageDate:message.messageDate];
    } 
    else 
    {
        MessageCellIdentifier = @"MessageCellIdentifier";
        
        msgCell = (ChatMessageCell*) [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier];
        
        if (msgCell == nil) 
        {
            msgCell = [[[ChatMessageCell alloc] initWithFrame:CGRectZero] autorelease];
        }
        [((ChatMessageCell*)msgCell) messageLabel].delegate = self;
        [((ChatMessageCell*)msgCell) setMessageOwner:message.ownerContact];
        [((ChatMessageCell*)msgCell) setMessageText:message.messageText];
        [((ChatMessageCell*)msgCell) setMessageImage:message.messageImage];
        [((ChatMessageCell*)msgCell) setMessageDate:message.messageDate];
        ((ChatMessageCell*)msgCell).hasSendingIndicator = NO;
        if(message.deliveryState != hookflash::IConversationThread::MessageDeliveryState_Delivered)
        {
            ((ChatMessageCell*)msgCell).hasSendingIndicator = YES;
        }
    }
    
    return msgCell;
}


#pragma mark - IM mehods
-(void)sendIMmessage:(NSString *)message toRecipient:(id)recipient forMessageEvent:(MessageEvent)messageEvent andImage:(UIImage*)img
{
    if(message && [[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 )
    {
        Message *m = [[Message alloc] init];
        m.messageText = message;
        m.typeOfMessage = messageEvent == NO_EVENT ? STANDARD_MESSAGE : SYSTEM_MESSAGE;
        m.messageDate = [NSDate date];
        m.ownerContact = [HomeUser sharedHomeUser].homeUser;
        m.sessionId = self.session.sId;
        if (img)
            m.messageImage = img;
        //[[SessionManager sharedSessionManager] sendChatMessageToRemoteParty:m];
        [self.session addMessage:m];
        [m release];
        [self setMessage:m];
        messageTextbox.text = nil;
        
        if (recipient)
        {
            if ([self.session getConversationThread])
            {
                [self.session getConversationThread]->sendMessage([m.messageId UTF8String], [m.messageType UTF8String], [m.messageBody UTF8String]);
            }
            if (!(m.typeOfMessage == SYSTEM_MESSAGE && messageEvent == CALL_INCOMING))
            {
                [[HookflashSoundsManager sharedHookflashSoundsManager] playMessageSendSound];
            }
        }
        
        [self refreshViewWithData];
    }
}

-(void)sendIMmessage:(NSString *)message
{
    [[ActionManager sharedActionManager] sendMessage:message messageType:STANDARD_MESSAGE messageEvent:NO_EVENT forSession:self.session ];
    
    messageTextbox.text = nil;
    
    [[HookflashMasterManager sharedHookflashMasterManager] registerAchievementForKey: @"hookflash_master_achievement_text_message"];
    [[HookflashMasterManager sharedHookflashMasterManager] showCompletionIfNeededForNavigationController: self.navigationController];
}
-(void)addIMSystemMessage:(NSString *)message forMessageEvent:(MessageEvent)messageEvent
{
    if(message && [[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 )
    {
        Message *m = [[Message alloc] init];
        m.messageText = message;
        m.typeOfMessage = SYSTEM_MESSAGE;
        m.messageDate = [NSDate date];
        m.ownerContact = [HomeUser sharedHomeUser].homeUser;
        m.sessionId = self.session.sId;
        m.messageEvent = messageEvent;
        //[[SessionManager sharedSessionManager] sendChatMessageToRemoteParty:m];
        [self.session addMessage:m];
        [m release];
        [self setMessage:m];
        messageTextbox.text = nil;
        
        [self refreshViewWithData];
    }    
}

//Implement in child class
-(void)callIsEnded:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDismissPopOver object:nil];
}

-(IBAction)startVideoSession:(id)sender
{
    self.session.type = VIDEO_CALL;
    [[ActionManager sharedActionManager] makeCallForSession:self.session];
}




*/

- (void) actionCallMenu
{
    if(self.audioCallViewController != nil && self.audioCallViewController.isViewLoaded && self.audioCallViewController.view.window)
    {
        [self.audioCallViewController.view removeFromSuperview];
        
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
        else //show call controller
        {
            [self.view addSubview:self.audioCallViewController.view];
        }
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
            [self startVideoSession:nil];
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
    }
    
    self.audioCallViewController.view.frame = self.chatViewController.chatTableView.frame;
    
    [self.view addSubview:self.audioCallViewController.view];
    [self.audioCallViewController callStarted];
    [[SessionManager sharedSessionManager] makeCallForSession:self.session includeVideo:NO isRedial:NO];
}

- (IBAction) startVideoSession:(id)sender
{
    [self.chatViewController hideKeyboard];
    
    if (!self.videoCallViewController)
    {
        self.videoCallViewController = [[VideoCallViewController alloc] initWithSession:self.session];
    }
    
    self.videoCallViewController.view.frame = self.chatViewController.chatTableView.frame;
    
    [self.view addSubview:self.videoCallViewController.view];
    [self.videoCallViewController callStarted];
    [[SessionManager sharedSessionManager] makeCallForSession:self.session includeVideo:YES isRedial:NO];
}

#pragma mark - ChatViewControllerDelegate

- (void)prepareForChat
{
    if (self.audioCallViewController.isViewLoaded && self.audioCallViewController.view.window)
    {
        [self.audioCallViewController.view removeFromSuperview];
    }
}
@end
