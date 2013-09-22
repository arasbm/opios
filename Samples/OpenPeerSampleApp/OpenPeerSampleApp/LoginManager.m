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

#import "LoginManager.h"


#import "OpenPeer.h"
#import "OpenPeerUser.h"
//Utility
#import "XMLWriter.h"
#import "Utility.h"
#import "Constants.h"
//Managers
#import "ContactsManager.h"
//SDK
#import <OpenPeerSDK/HOPAccount.h>
#import <OpenPeerSDK/HOPIdentity.h>
#import <OpenPeerSDK/HOPTypes.h>
#import <OpenpeerSDK/HOPHomeUser.h>
#import <OpenpeerSDK/HOPModelManager.h>
#import <OpenpeerSDK/HOPAssociatedIdentity.h>
#import <OpenpeerSDK/HOPIdentityContact.h>
#import <OpenpeerSDK/HOPRolodexContact.h>

//Delegates
#import "StackDelegate.h"
//View Controllers
#import "MainViewController.h"
#import "LoginViewController.h"
#import "ActivityIndicatorViewController.h"
#import "WebLoginViewController.h"

@interface LoginManager ()

@property (nonatomic) BOOL isLogin;
@property (nonatomic) BOOL isAssociation;

@property (strong, nonatomic) NSMutableDictionary* associatingIdentitiesDictionary;
@end


@implementation LoginManager

/**
 Retrieves singleton object of the Login Manager.
 @return Singleton object of the Login Manager.
 */
+ (id) sharedLoginManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 Initialize singleton object of the Login Manager.
 @return Singleton object of the Login Manager.
 */
- (id) init
{
    self = [super init];
    if (self)
    {
        self.isLogin  = NO;
        self.isAssociation = NO;
        
        self.associatingIdentitiesDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/**
 Custom getter for webLoginViewController
 */
- (WebLoginViewController *)webLoginViewController
{
    if (!_webLoginViewController)
    {
        _webLoginViewController = [[WebLoginViewController alloc] init];
        if (_webLoginViewController)
            _webLoginViewController.view.hidden = YES;
    }
    
    return _webLoginViewController;
}

/**
 This method will show login window in case user data does not exists on device, or start relogin automatically if information are available.
 @return Singleton object of the Contacts Manager.
 */
- (void) login
{
    //If peer file doesn't exists, show login view, otherwise start relogin
    if (![[HOPModelManager sharedModelManager] getLastLoggedInHomeUser])
    {
        [[[OpenPeer sharedOpenPeer] mainViewController] showLoginView];
        self.isLogin = YES;
    }
    else
    {
        [self startRelogin];
    }
}

/**
 Logout from the current account.
 */
- (void) logout
{    
    //Delete all cookies.
    [Utility removeCookiesAndClearCredentials];
    
    //Delete user data stored on device.
    //[[OpenPeerUser sharedOpenPeerUser] deleteUserData];
    
    //Remove all contacts
    //[[[ContactsManager sharedContactsManager] contactArray] removeAllObjects];
    [[[ContactsManager sharedContactsManager] contactsDictionaryByProvider] removeAllObjects];
    
    //Call to the SDK in order to shutdown Open Peer engine.
    [[HOPAccount sharedAccount] shutdown];
    
    //Return to the login page.
    [[[OpenPeer sharedOpenPeer] mainViewController] showLoginView];
    
}

- (void) startAccount
{
    [[HOPAccount sharedAccount] loginWithAccountDelegate:(id<HOPAccountDelegate>)[[OpenPeer sharedOpenPeer] accountDelegate] conversationThreadDelegate:(id<HOPConversationThreadDelegate>) [[OpenPeer sharedOpenPeer] conversationThreadDelegate]  callDelegate:(id<HOPCallDelegate>) [[OpenPeer sharedOpenPeer] callDelegate]  namespaceGrantOuterFrameURLUponReload:grantOuterFrameURLUponReload grantID:@"Id" lockboxServiceDomain:identityProviderDomain forceCreateNewLockboxAccount:NO];
}
/**
 Starts user login for specific identity URI. Activity indicator is displayed and identity login started.
 @param identityURI NSString identity uri (e.g. identity://facebook.com/)
 */
- (void) startLoginUsingIdentityURI:(NSString*) identityURI
{
    if (![self.associatingIdentitiesDictionary objectForKey:identityURI])
    {
        NSLog(@"Identity login started");
        [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:YES withText:@"Getting identity login url ..." inView:[[[[OpenPeer sharedOpenPeer] mainViewController] loginViewController] view]];
        
        NSString* redirectAfterLoginCompleteURL = [NSString stringWithFormat:@"%@?reload=true",outerFrameURL];

        [self startAccount];
        //For identity login it is required to pass identity delegate, URL that will be requested upon successful login, identity URI and identity provider domain. This is 
        HOPIdentity* hopIdentity = [HOPIdentity loginWithDelegate:(id<HOPIdentityDelegate>)[[OpenPeer sharedOpenPeer] identityDelegate] identityProviderDomain:identityProviderDomain  identityURIOridentityBaseURI:identityURI outerFrameURLUponReload:redirectAfterLoginCompleteURL];
        
        if (!hopIdentity)
            NSLog(@"Identity login failed");
        else
            [self.associatingIdentitiesDictionary setObject:hopIdentity forKey:identityURI];
    }
}

/**
 Initiates relogin procedure.
 */
- (void) startRelogin
{
    BOOL reloginStarted = NO;
    NSLog(@"Relogin started");
    [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:YES withText:@"Relogin ..." inView:[[[OpenPeer sharedOpenPeer] mainViewController] view]];
    
    HOPHomeUser* homeUser = [[HOPModelManager sharedModelManager] getLastLoggedInHomeUser];
    
    if (homeUser && [homeUser.reloginInfo length] > 0)
    {
        //To start relogin procedure it is required to pass account, conversation thread and call delegates. Also, private peer file and secret, received on previous login procedure, are required.
        reloginStarted = [[HOPAccount sharedAccount] reloginWithAccountDelegate:(id<HOPAccountDelegate>) [[OpenPeer sharedOpenPeer] accountDelegate] conversationThreadDelegate:(id<HOPConversationThreadDelegate>)[[OpenPeer sharedOpenPeer] conversationThreadDelegate]  callDelegate:(id<HOPCallDelegate>)[[OpenPeer sharedOpenPeer] callDelegate] lockboxOuterFrameURLUponReload:outerFrameURL reloginInformation:homeUser.reloginInfo];
    }
    
    if (!reloginStarted)
        NSLog(@"Relogin failed");
}


/**
 Makes login web view visible or hidden, depending of input parameter.
 @param isVisible BOOL YES to make web view visible, NO to hide it 
 */
- (void) makeLoginWebViewVisible:(BOOL) isVisible
{
    self.webLoginViewController.view.hidden = !isVisible;
    if (!self.webLoginViewController.view.superview)
    {
        [[[OpenPeer sharedOpenPeer] mainViewController] showWebLoginView:self.webLoginViewController];
        [self.webLoginViewController.view setFrame:[[OpenPeer sharedOpenPeer] mainViewController].view.bounds];
    }
}


/**
 Handles successful identity association. It updates list of associated identities on server side.
 @param identity HOPIdentity identity used for login
 */
- (void) onIdentityAssociationFinished:(HOPIdentity*) identity
{
    NSString* relogininfo = [[HOPAccount sharedAccount] getReloginInformation];
    
    if ([relogininfo length] > 0)
    {
        HOPHomeUser* homeUser = [[HOPModelManager sharedModelManager] getHomeUserByStableID:[[HOPAccount sharedAccount] getStableID]];
        
        if (!homeUser)
        {
            homeUser = (HOPHomeUser*)[[HOPModelManager sharedModelManager] createObjectForEntity:@"HOPHomeUser"];
            homeUser.stableId = [[HOPAccount sharedAccount] getStableID];
            homeUser.reloginInfo = [[HOPAccount sharedAccount] getReloginInformation];
            homeUser.loggedIn = [NSNumber numberWithBool: YES];
        }
        
        HOPAssociatedIdentity*  associatedIdentity = (HOPAssociatedIdentity*)[[HOPModelManager sharedModelManager] createObjectForEntity:@"HOPAssociatedIdentity"];
        
        HOPIdentityContact* homeIdentityContact = [identity getSelfIdentityContact];
        associatedIdentity.domain = [identity getIdentityProviderDomain];
        associatedIdentity.lastDownloadTime = [NSDate date];
        associatedIdentity.name = [identity getBaseIdentityURI];
        associatedIdentity.baseIdentityURI = [identity getBaseIdentityURI];
        associatedIdentity.homeUserProfile = homeIdentityContact.rolodexContact;
        associatedIdentity.homeUser = homeUser;
        homeIdentityContact.rolodexContact.associatedIdentityForHomeUser = associatedIdentity;
        
        [[HOPModelManager sharedModelManager] saveContext];
        
        [self.associatingIdentitiesDictionary removeObjectForKey:[identity getBaseIdentityURI]];
    }
    
    [self onUserLoggedIn];
}


/**
 Handles SDK event after login is successful.
 */
- (void) onUserLoggedIn
{
    //Wait till identity association is not completed
    if ([[HOPAccount sharedAccount] getState].state == HOPAccountStateReady && [self.associatingIdentitiesDictionary count] == 0)
    {
       /* NSArray* associatedIdentites = [[HOPAccount sharedAccount] getAssociatedIdentities];
        for (HOPIdentity* identity in associatedIdentites)
        {
            BOOL b = NO;
            if (![identity isDelegateAttached])
            {
                NSString* redirectAfterLoginCompleteURL = [NSString stringWithFormat:@"%@?reload=true",outerFrameURL];
                
                [identity attachDelegate:(id<HOPIdentityDelegate>)[[OpenPeer sharedOpenPeer] identityDelegate]  redirectionURL:redirectAfterLoginCompleteURL];
            }
            b = [identity isDelegateAttached];
            b = YES;
        }*/
        
        //Login finished. Remove activity indicator
        [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:NO withText:nil inView:nil];
    
        //Check if it is logged in a new user
        HOPHomeUser* previousLoggedInHomeUser = [[HOPModelManager sharedModelManager] getLastLoggedInHomeUser];
        HOPHomeUser* homeUser = [[HOPModelManager sharedModelManager] getHomeUserByStableID:[[HOPAccount sharedAccount] getStableID]];
    
        if (homeUser)
        {
            //If is previous logged in user is different update loggedIn flag
            if (![homeUser.loggedIn boolValue])
            {
                if (previousLoggedInHomeUser)
                    previousLoggedInHomeUser.loggedIn = NO;
                
                homeUser.loggedIn = [NSNumber numberWithBool: YES];
                [[HOPModelManager sharedModelManager] saveContext];
            }
        }

        if (self.isLogin)
        {
            self.isLogin = NO;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Identity association" message:@"Do you want to associate another social account" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            
            [alert show];
        }

        //Start loading contacts.
        [[ContactsManager sharedContactsManager] loadContacts];
    }
}


/**
 Retrieves info if an identity with specified URI is associated or not.
 @param inBaseIdentityURI NSString base identity URI
 @return YES if associated, otherwise NO
 */
- (BOOL) isAssociatedIdentity:(NSString*) inBaseIdentityURI
{
    BOOL ret = NO;
    
    HOPHomeUser* homeUser = [[HOPModelManager sharedModelManager] getLastLoggedInHomeUser];
    if (homeUser)
    {
        HOPAssociatedIdentity* associatedIdentity = [[HOPModelManager sharedModelManager] getAssociatedIdentityBaseIdentityURI:inBaseIdentityURI homeUserStableId:homeUser.stableId];
        
        if (associatedIdentity)
            ret = YES;
    }
    
    return ret;
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        self.isAssociation = YES;
        [[[OpenPeer sharedOpenPeer] mainViewController] showLoginView];
    }
//    else
//    {
//        [[ContactsManager sharedContactsManager] loadContacts];
//    }
}
@end
