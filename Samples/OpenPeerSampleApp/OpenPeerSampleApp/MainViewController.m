/*
 
 Copyright (c) 2012, SMB Phone Inc.
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

#import "MainViewController.h"
#import "OpenPeer.h"
#import "OpenPeerUser.h"
#import "Constants.h"
//SDK
#import <OpenpeerSDK/HOPConversationThread.h>
//Managers
#import "SessionManager.h"
#import "LoginManager.h"
#import "ContactsManager.h"
#import "MessageManager.h"
//Model
#import "Session.h"
//View controllers
#import "LoginViewController.h"
#import "WebLoginViewController.h"
#import "ContactsTableViewController.h"
#import "ActiveSessionViewController.h"
#import "MainViewController.h"
#import "ChatViewController.h"
#import "SettingsViewController.h"
#import "SessionViewController.h"

//Private methods
@interface MainViewController ()

- (void) removeAllSubViews;
- (SessionTransitionStates) determineViewControllerTransitionStateForSession:(NSString*) sessionId forIncomingCall:(BOOL) incomingCall forIncomingMessage:(BOOL) incomingMessage;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.sessionViewControllersDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) removeAllSubViews
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [[[self view] subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
}


- (void) showTabBarController
{
    [self removeAllSubViews];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"iPhone_top_bar_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    if (!self.tabBarController)
    {
        self.contactsTableViewController = nil;
        
        //Contacts tab
        self.contactsTableViewController = [[ContactsTableViewController alloc] initWithNibName:@"ContactsTableViewController" bundle:nil];
        self.contactsTableViewController.title = @"Contacts";
        self.tabBarItem.title = @"CONTACTS";
        
        [self.contactsTableViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"iPhone_tabBar_contacts_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iPhone_tabBar_contacts_inactive.png"]];
        
        UINavigationController *contactsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.contactsTableViewController];
        
        //Settings tab
        SettingsViewController* settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        settingsViewController.title = @"Settings";
        self.tabBarItem.title = @"SETTINGS";
            
        [settingsViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"iPhone_tabBar_settings_active_Icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iPhone_tabBar_settings_inactive_Icon.png"]];
        
        UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
        
        //Tab
        self.tabBarController = [[UITabBarController alloc] init];
        self.tabBarController.delegate = self;
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:contactsNavigationController, settingsNavigationController, nil];
        
        self.tabBarController.view.frame = self.view.bounds;
        [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"iPhone_tabBar_bkgd.png"]];
    }
    
    [self.view addSubview:self.tabBarController.view];
}

#pragma mark - Login views
/**
 Show view with login button
*/
- (void) showLoginView
{
    if (!self.loginViewController)
    {
        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.loginViewController.view setFrame:self.view.bounds];
    }
    
    [self removeAllSubViews];
    self.tabBarController = nil;
    
    [self.loginViewController prepareForLogin];
    [self.view addSubview:self.loginViewController.view];
}

/**
 Show web view with opened login page.
 @param url NSString Login page url.
*/
- (void) showWebLoginView:(WebLoginViewController*) webLoginViewController
{
    if (webLoginViewController)
    {
        //[self removeAllSubViews];
        [self.view addSubview:webLoginViewController.view];
    }
}


#pragma mark - Session view
/**
 Show session view.
 @param session Session which needs to be displyed
 @param incomingCall BOOL - Yes if it is session with incoming call, otherwise NO
 @param incomingMessage BOOL - Yes if it is session with incoming message, otherwise NO
 */
- (void) showSessionViewControllerForSession:(Session*) session forIncomingCall:(BOOL) incomingCall forIncomingMessage:(BOOL) incomingMessage
{
//    SessionViewController* sessionViewController = [[SessionViewController alloc] initWithSession:session];
//    sessionViewController.hidesBottomBarWhenPushed = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"iPhone_back_button.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    //sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backButton];
    
//    NSString* keyK = @"sessionId";
//    [self.sessionViewControllersDictionary setObject:sessionViewController forKey:keyK];
//    [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]) pushViewController:sessionViewController animated:YES];
//    [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]).navigationBar.topItem setTitle:@"title"];
//    
    
    
    SessionViewController* sessionViewController = nil;
    NSString* sessionId = @"sessionId";//[[session conversationThread] getThreadId];
    
    SessionTransitionStates transition = [self determineViewControllerTransitionStateForSession:sessionId forIncomingCall:incomingCall forIncomingMessage:incomingMessage];
    
    NSString* title = @"title";//[[[session participantsArray] objectAtIndex:0] fullName];
    
    switch (transition)
    {
        case NEW_SESSION_SWITCH:
        {
            [self.contactsNavigationController popToRootViewControllerAnimated:NO];
        }
        case NEW_SESSION:
        case NEW_SESSION_WITH_CALL:
            sessionViewController = [[SessionViewController alloc] initWithSession:session];
            sessionViewController.hidesBottomBarWhenPushed = YES;
            sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backButton];
            [self.sessionViewControllersDictionary setObject:sessionViewController forKey:sessionId];
            
            [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]) pushViewController:sessionViewController animated:YES];
            [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]).navigationBar.topItem setTitle:@"title"];
            break;
            
        case NEW_SESSION_WITH_CHAT:
            sessionViewController = [[SessionViewController alloc] initWithSession:session];
            sessionViewController.hidesBottomBarWhenPushed = YES;
            sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backButton];
            [self.sessionViewControllersDictionary setObject:sessionViewController forKey:sessionId];
            
            [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]) pushViewController:sessionViewController animated:YES];
            [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]).navigationBar.topItem setTitle:@"title"];
            //[sessionViewContorller.chatViewController refreshViewWithData];
            break;
            
        case NEW_SESSION_REFRESH_CHAT:
        {
            sessionViewController = [[SessionViewController alloc] initWithSession:session];
            sessionViewController.hidesBottomBarWhenPushed = YES;
            sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backButton];
            [self.sessionViewControllersDictionary setObject:sessionViewController forKey:sessionId];
            [sessionViewController.chatViewController refreshViewWithData];
            
            [self showNotification:[NSString stringWithFormat:@"New message from %@",title]];
        }
            break;
            
        case EXISITNG_SESSION_SWITCH:
            sessionViewController = [self.sessionViewControllersDictionary objectForKey:sessionId];
            [self.contactsNavigationController popToRootViewControllerAnimated:NO];
            [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]) popToRootViewControllerAnimated:NO];
            [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]) pushViewController:sessionViewController animated:YES];
            [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]).navigationBar.topItem setTitle:@"title"];
            break;
            
        case EXISTING_SESSION_REFRESH_NOT_VISIBLE_CHAT:
            [self showNotification:[NSString stringWithFormat:@"New message from %@",title]];
        case EXISTING_SESSION_REFRESH_CHAT:
            sessionViewController = [self.sessionViewControllersDictionary objectForKey:sessionId];
            [sessionViewController.chatViewController refreshViewWithData];
            break;
            
        case EXISTIG_SESSION_SHOW_CHAT:
            sessionViewController = [self.sessionViewControllersDictionary objectForKey:sessionId];
            if (self.contactsNavigationController.visibleViewController != sessionViewController)
            {
                //[self.contactsNavigationController popToRootViewControllerAnimated:NO];
                //[self.contactsNavigationController pushViewController:sessionViewController animated:NO];
                [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]) popToRootViewControllerAnimated:NO];
                [((UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0]) pushViewController:sessionViewController animated:YES];
            }
            //[self.contactsNavigationController pushViewController:sessionViewController.chatViewController animated:YES];
            break;
            
        case INCOMING_CALL_WHILE_OTHER_INPROGRESS:
            [self showNotification:[NSString stringWithFormat:@"%@ is trying to reach you.",title]];
            break;
            
        case EXISTING_SESSION:
        default:
            break;
    }
}

- (SessionTransitionStates) determineViewControllerTransitionStateForSession:(NSString*) sessionId forIncomingCall:(BOOL) incomingCall forIncomingMessage:(BOOL) incomingMessage
{
    //If session view controller is alaredy created for this session get it from dictionary
    ActiveSessionViewController* sessionViewContorller = [self.sessionViewControllersDictionary objectForKey:sessionId];
    
    if (!sessionViewContorller)
    {
        if (incomingCall)
        {
            if ([[SessionManager sharedSessionManager] isCallInProgress])
                return INCOMING_CALL_WHILE_OTHER_INPROGRESS; //Cannot have two active calls at once
            else
            {
                if (self.contactsNavigationController.visibleViewController && ![self.contactsNavigationController.visibleViewController isKindOfClass:[ContactsTableViewController class]])
                    return NEW_SESSION_SWITCH; //Incoming call has priority over chat session, so switch from currently active session to new with incoming call
                else
                    return NEW_SESSION_WITH_CALL; //Create and show a new session with incomming call
            }
            
        }
        else if (incomingMessage)
        {
            if (self.contactsNavigationController.visibleViewController && ![self.contactsNavigationController.visibleViewController isKindOfClass:[ContactsTableViewController class]])
                return NEW_SESSION_REFRESH_CHAT; //Create a new session and update chat, but don't switch from existing session
            else
                return NEW_SESSION_WITH_CHAT; //Create and show a new session with incomming message
        }
        else
            return NEW_SESSION; //Create and show a new session
        
    }
    else
    {
        if (incomingCall)
        {
            if ([[SessionManager sharedSessionManager] isCallInProgress])
                return ERROR_CALL_ALREADY_IN_PROGRESS; //Cannot have two active calls at once
            else
            {
                if (self.contactsNavigationController.visibleViewController == sessionViewContorller)
                    return EXISTING_SESSION; //Incoming call for currenlty displayed session so don't change anything
                else
                    return EXISITNG_SESSION_SWITCH; //Incoming call for session that is not displayed at the moment so swith to that session
            }
        }
        else if (incomingMessage)
        {
            if (self.contactsNavigationController.visibleViewController == sessionViewContorller)
            {
                if ([[SessionManager sharedSessionManager] isCallInProgress])
                    return EXISTING_SESSION_REFRESH_CHAT; //Incoming message for session with active call. Just refresh list of messages but don't display chat view
                else
                    return EXISTIG_SESSION_SHOW_CHAT; //Show chat for currently displayed session
            }
            else if (self.contactsNavigationController.visibleViewController == sessionViewContorller.chatViewController)
            {
                return EXISTING_SESSION_REFRESH_CHAT; //Already displayed chat view, so just refresh messages
            }
            else if ([self.contactsNavigationController.visibleViewController isKindOfClass:[ContactsTableViewController class]])
            {
                return EXISTIG_SESSION_SHOW_CHAT; //Move from the contacts list to the chat view for session
            }
            else
            {
                return EXISTING_SESSION_REFRESH_NOT_VISIBLE_CHAT; //Move from the contacts list to the chat view for session
            }
        }
        else
        {
            return EXISITNG_SESSION_SWITCH; //Switch to exisitng session
        }
    }
}


/**
 Remove specific session view controller from the dictionary.
 @param sessionId NSString session id
 */
- (void) removeSessionViewControllerForSession:(NSString*) sessionId
{
    [self.sessionViewControllersDictionary removeObjectForKey:sessionId];
}

- (void) updateSessionViewControllerId:(NSString*) oldSessionId newSesionId:(NSString*) newSesionId
{
    ActiveSessionViewController* svc = [self.sessionViewControllersDictionary objectForKey:oldSessionId];
    [self removeSessionViewControllerForSession:oldSessionId];
    [self.sessionViewControllersDictionary setObject:svc forKey:newSesionId];
}
/**
 Prepare specific session vire controller for incoming call
 @param session Session with incomming call
 */
- (void) showIncominCallForSession:(Session*) session
{
    ActiveSessionViewController* sessionViewContorller = [self.sessionViewControllersDictionary objectForKey:[[session conversationThread] getThreadId]];
    [sessionViewContorller prepareForIncomingCall];
}



- (void) showNotification:(NSString*) message
{
    UILabel* labelNotification = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 20.0, self.view.frame.size.width - 10.0, 40.0)];
    labelNotification.text = message;//[NSString stringWithFormat:@"New message from %@",contactName];
    labelNotification.textAlignment = NSTextAlignmentCenter;
    labelNotification.textColor = [UIColor whiteColor];
    labelNotification.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [self.contactsNavigationController.visibleViewController.view addSubview:labelNotification];
    
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        labelNotification.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        [labelNotification removeFromSuperview];
    }];
}
@end
