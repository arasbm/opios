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

#import "ChatViewController.h"
#import <UIKit/UIKit.h>

#import "MessageManager.h"
#import "Message.h"
#import "Session.h"
#import "OpenPeerUser.h"
#import "ChatMessageCell.h"

@interface ChatViewController()

@property (weak, nonatomic) Session* session;


@property (weak, nonatomic) IBOutlet UIView *typingMessageView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextbox;
@property (weak, nonatomic) NSDictionary* userInfo;
@property (nonatomic) BOOL keyboardIsHidden;
@property (nonatomic) CGFloat keyboardLastChange;

- (void) setFramesSizes;
- (void) registerForNotifications:(BOOL)registerForNotifications;

- (void) sendIMmessage:(NSString *)message;

- (IBAction) sendButtonPressed:(id) sender;

@end

@implementation ChatViewController


#pragma mark init/dealloc
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id) initWithSession:(Session*) inSession
{
    self = [self initWithNibName:@"ChatViewController" bundle:nil];
    {
        self.session = inSession;
    }
    
    return self;
}


#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [self registerForNotifications:YES];
    
    if (!self.keyboardIsHidden)
    {
        [self.messageTextbox becomeFirstResponder];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self registerForNotifications:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keyboardIsHidden = YES;
    
    self.chatTableView.backgroundColor = [UIColor clearColor];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.messageTextbox setReturnKeyType:UIReturnKeySend];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.chatTableView addGestureRecognizer:tapGesture];
}

- (void) hideKeyboard
{
    [self.messageTextbox resignFirstResponder];
}

#pragma mark - Keyboard handling
-(void)resetKeyboard:(NSNotification *)notification
{
    self.keyboardIsHidden = NO;
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    [self.delegate prepareForChat];
    self.keyboardIsHidden = NO;
    
    self.userInfo = [notification userInfo];       
   
    [self setFramesSizes];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardIsHidden = YES;
    self.userInfo = [notification userInfo];
    [self setFramesSizes];
}

#pragma mark - Frames handling
-(void) setFramesSizes
{
    float chatHeight;
    if (self.userInfo != nil)
    {
        CGRect keyboardFrame;
        NSValue *ks = [self.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        keyboardFrame = [ks CGRectValue];
        CGRect kF = [self.view convertRect:keyboardFrame toView:nil];
        self.keyboardLastChange = kF.size.height;
        
        NSTimeInterval animD;
        UIViewAnimationCurve animC;
        
        [[self.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animC];
        [[self.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animD];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: animD]; 
        [UIView setAnimationCurve:animC];
    }
    if (self.keyboardIsHidden)
    {
        self.keyboardLastChange = 0;
    }
    
    // set initial size, session view
    CGRect viewRect = self.view.superview.frame;
    viewRect.origin.y=0;
    
    // set initial size, chat view
    CGRect chatRect = self.chatTableView.frame;
    chatRect.origin.y = 0.0;//topSessionView.frame.size.height;
    if (!self.typingMessageView.hidden)
        chatHeight = viewRect.size.height - self.typingMessageView.frame.size.height - self.keyboardLastChange;
    else 
        chatHeight = viewRect.size.height - self.keyboardLastChange;
    
    self.view.frame = viewRect;
    NSLog(@"SessionViewContorller frame: %f, %f, %f, %f,",viewRect.origin.x, viewRect.origin.y, viewRect.size.width, viewRect.size.height);
    
    chatRect.size.height = chatHeight;
    self.chatTableView.frame = chatRect;
    
    CGRect textEntryViewRect = self.typingMessageView.frame;
    textEntryViewRect.origin.y = chatRect.size.height;
    self.typingMessageView.frame = textEntryViewRect;
    [self refreshViewWithData];
    
    if (self.userInfo)
        [UIView commitAnimations];
    
    self.userInfo = nil;
}

#pragma mark - Actions
- (IBAction) sendButtonPressed : (id) sender
{
    if ([self.messageTextbox.text length] > 0)
        [self sendIMmessage:self.messageTextbox.text];
}


- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self.messageTextbox resignFirstResponder];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextViewDelegate
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"] && [textView.text length] > 0)
    {
        [self sendIMmessage:textView.text];
        return NO;
    }
    return YES;
}

- (void) refreshViewWithData
{
    if(self.session.messageArray && [self.session.messageArray count] > 0)
    {
        [self.chatTableView reloadData];
        
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.session.messageArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

/*- (float) getHeaderHeight:(float)tableViewHeight
{
    float res = tableViewHeight;
    
    if(self.session.messageArray && [self.session.messageArray count] > 0)
    {
        for(int i=0; i<[self.session.messageArray count]; i++)
        {
            Message *message = [self.session.messageArray objectAtIndex:i];
            
            CGSize cs = [ChatMessageCell calcMessageHeight:message.text forScreenWidth:self.chatTableView.frame.size.width - 85];
            res -= (cs.height + 32);
            
            if(res < 0)
            {
                res = 1;
                break;
            }
        } // end of if
    }
    
    return res;
}*/

- (void) registerForNotifications:(BOOL)registerForNotifications
{
    if (registerForNotifications)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}


#pragma mark - Table Data Source Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.session.messageArray count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message* message = nil;
    
    if (self.session.messageArray && [self.session.messageArray count] > 0)
    {
        message = (Message*)[self.session.messageArray objectAtIndex:indexPath.row];
    }
    else
    {
        return nil;
    }
    
    ChatMessageCell* msgCell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellIdentifier"];
    
    if (msgCell == nil)
    {
        msgCell = [[ChatMessageCell alloc] initWithFrame:CGRectZero];
    }
    
    [msgCell setMessage:message];
    
    return msgCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float res = 0.0;
    Message *message = [self.session.messageArray objectAtIndex:indexPath.row];
    
    CGSize textSize = [ChatMessageCell calcMessageHeight:message.text forScreenWidth:self.chatTableView.frame.size.width - 85];

    textSize.height += 32;
    
    res = (textSize.height < 46) ? 46 : textSize.height;
    
    return res;
}

- (void) sendIMmessage:(NSString *)message
{
    [[MessageManager sharedMessageManager] sendMessage:message forSession:self.session];
    self.messageTextbox.text = nil;
    [self refreshViewWithData];
}
@end
