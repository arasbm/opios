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
#import "Constants.h"
#import "Utility.h"
#import "Logger.h"
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
#import "SplashViewController.h"
//Private methods
@interface MainViewController ()
@property (nonatomic) BOOL isLogerActivated;
@property (strong, nonatomic) SplashViewController* splashViewController;

- (void) removeAllSubViews;
- (SessionTransitionStates) determineViewControllerTransitionStateForSession:(NSString*) sessionId forIncomingCall:(BOOL) incomingCall forIncomingMessage:(BOOL) incomingMessage;

- (void)threeTapGasture;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.sessionViewControllersDictionary = [[NSMutableDictionary alloc] init];
        self.threeTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeTapGasture)];
        self.threeTapGestureRecognizer.delegate = self;
        self.threeTapGestureRecognizer.numberOfTapsRequired = 3;
        self.threeTapGestureRecognizer.numberOfTouchesRequired = 2;
        
       self.isLogerActivated = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[OpenPeer sharedOpenPeer] setMainViewController:self];

    if (self.threeTapGestureRecognizer)
        [self.view addGestureRecognizer:self.threeTapGestureRecognizer];
    
    self.splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    self.splashViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

-(void)viewDidUnload
{
    if (self.threeTapGestureRecognizer)
    {
        [self.view removeGestureRecognizer:self.threeTapGestureRecognizer];
        self.threeTapGestureRecognizer = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.splashViewController)
    {
        [self presentModalViewController:self.splashViewController animated:YES];
        self.splashViewController = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
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
    }
    
    [self removeAllSubViews];
    self.tabBarController = nil;
    
    [self.loginViewController prepareForLogin];
    [self.view addSubview:self.loginViewController.view];
    [self.loginViewController.view setFrame:self.view.bounds];
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
    ActiveSessionViewController* sessionViewContorller = nil;
    NSString* sessionId = [[session conversationThread] getThreadId];
    
    SessionTransitionStates transition = [self determineViewControllerTransitionStateForSession:sessionId forIncomingCall:incomingCall forIncomingMessage:incomingMessage];
    
    NSString* title = [[[session participantsArray] objectAtIndex:0] name];
    
    UINavigationController* navigationController = (UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0];
    switch (transition)
    {
        case NEW_SESSION_SWITCH:
        {
            [navigationController popToRootViewControllerAnimated:NO];
        }
        case NEW_SESSION:
        case NEW_SESSION_WITH_CALL:
            sessionViewContorller = [[ActiveSessionViewController alloc] initWithSession:session];
            sessionViewContorller.hidesBottomBarWhenPushed = YES;
            [self.sessionViewControllersDictionary setObject:sessionViewContorller forKey:sessionId];
            
            //[self.contactsNavigationController pushViewController:sessionViewContorller animated:YES];
            //[self.contactsNavigationController.navigationBar.topItem setTitle:title];
            [navigationController pushViewController:sessionViewContorller animated:YES];
            [navigationController.navigationBar.topItem setTitle:title];
            break;
            
        case NEW_SESSION_WITH_CHAT:
            sessionViewContorller = [[ActiveSessionViewController alloc] initWithSession:session];
            sessionViewContorller.hidesBottomBarWhenPushed = YES;
            [self.sessionViewControllersDictionary setObject:sessionViewContorller forKey:sessionId];
            
            //[self.contactsNavigationController pushViewController:sessionViewContorller animated:NO];
            [navigationController pushViewController:sessionViewContorller animated:NO];
            [navigationController.navigationBar.topItem setTitle:title];
            
            //[self.contactsNavigationController pushViewController:sessionViewContorller.chatViewController animated:YES];
            [navigationController pushViewController:sessionViewContorller.chatViewController animated:YES];
            //[sessionViewContorller.chatViewController refreshViewWithData];
            break;
            
        case NEW_SESSION_REFRESH_CHAT:
        {
            sessionViewContorller = [[ActiveSessionViewController alloc] initWithSession:session];
            [self.sessionViewControllersDictionary setObject:sessionViewContorller forKey:sessionId];
            [sessionViewContorller.chatViewController refreshViewWithData];
            
            [self showNotification:[NSString stringWithFormat:@"New message from %@",title]];
        }
            break;
            
        case EXISITNG_SESSION_SWITCH:
            sessionViewContorller = [self.sessionViewControllersDictionary objectForKey:sessionId];
//            [self.contactsNavigationController popToRootViewControllerAnimated:NO];
//            [self.contactsNavigationController pushViewController:sessionViewContorller animated:YES];
//            [self.contactsNavigationController.navigationBar.topItem setTitle:title];
            
            [navigationController popToRootViewControllerAnimated:NO];
            [navigationController pushViewController:sessionViewContorller animated:YES];
            [navigationController.navigationBar.topItem setTitle:title];
            break;
            
        case EXISTING_SESSION_REFRESH_NOT_VISIBLE_CHAT:
            [self showNotification:[NSString stringWithFormat:@"New message from %@",title]];
        case EXISTING_SESSION_REFRESH_CHAT:
            sessionViewContorller = [self.sessionViewControllersDictionary objectForKey:sessionId];
            [sessionViewContorller.chatViewController refreshViewWithData];
            break;
            
        case EXISTIG_SESSION_SHOW_CHAT:
            sessionViewContorller = [self.sessionViewControllersDictionary objectForKey:sessionId];
            if (navigationController.visibleViewController != sessionViewContorller)
            {
                [navigationController popToRootViewControllerAnimated:NO];
                [navigationController pushViewController:sessionViewContorller animated:NO];
            }
            [navigationController pushViewController:sessionViewContorller.chatViewController animated:YES];
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
    //If session view controller is laredy created for this session get it from dictionary
    ActiveSessionViewController* sessionViewContorller = [self.sessionViewControllersDictionary objectForKey:sessionId];
    UINavigationController* navigationController = (UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0];
    
    if (!sessionViewContorller)
    {
        if (incomingCall)
        {
            if ([[SessionManager sharedSessionManager] isCallInProgress])
                return INCOMING_CALL_WHILE_OTHER_INPROGRESS; //Cannot have two active calls at once
            else
            {
                if (navigationController.visibleViewController && ![navigationController.visibleViewController isKindOfClass:[ContactsTableViewController class]])
                    return NEW_SESSION_SWITCH; //Incoming call has priority over chat session, so switch from currently active session to new with incoming call
                else
                    return NEW_SESSION_WITH_CALL; //Create and show a new session with incomming call
            }
            
        }
        else if (incomingMessage)
        {
            if (navigationController.visibleViewController && ![navigationController.visibleViewController isKindOfClass:[ContactsTableViewController class]])
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
                if (navigationController.visibleViewController == sessionViewContorller)
                    return EXISTING_SESSION; //Incoming call for currenlty displayed session so don't change anything
                else
                    return EXISITNG_SESSION_SWITCH; //Incoming call for session that is not displayed at the moment so swith to that session
            }
        }
        else if (incomingMessage)
        {
            if (navigationController.visibleViewController == sessionViewContorller)
            {
                if ([[SessionManager sharedSessionManager] isCallInProgress])
                    return EXISTING_SESSION_REFRESH_CHAT; //Incoming message for session with active call. Just refresh list of messages but don't display chat view
                else
                    return EXISTIG_SESSION_SHOW_CHAT; //Show chat for currently displayed session
            }
            else if (navigationController.visibleViewController == sessionViewContorller.chatViewController)
            {
                return EXISTING_SESSION_REFRESH_CHAT; //Already displayed chat view, so just refresh messages
            }
            else if ([navigationController.visibleViewController isKindOfClass:[ContactsTableViewController class]])
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
    UINavigationController* navigationController = (UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0];
    
    UILabel* labelNotification = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 20.0, self.view.frame.size.width - 10.0, 40.0)];
    labelNotification.text = message;//[NSString stringWithFormat:@"New message from %@",contactName];
    labelNotification.textAlignment = NSTextAlignmentCenter;
    labelNotification.textColor = [UIColor whiteColor];
    labelNotification.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [navigationController.visibleViewController.view addSubview:labelNotification];
    
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        labelNotification.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        [labelNotification removeFromSuperview];
    }];
}


- (void)threeTapGasture
{
    [Logger startTelnetLoggerOnStartUp];
}

- (void) removeSplashScreen
{
    if (![self.presentedViewController isBeingDismissed])
        [self dismissViewControllerAnimated:NO completion:nil];
    
    //Init open peer delegates. Start login procedure. Display Login view controller.
    [[OpenPeer sharedOpenPeer] setup];
}

- (void) onLogout
{
    [self removeAllSubViews];
    self.contactsTableViewController = nil;
    self.tabBarController = nil;
}
@end
