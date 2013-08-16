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

#import "IdentityDelegate.h"
#import <OpenpeerSDK/HOPIdentity.h>
#import <OpenpeerSDK/HOPAccount.h>
#import <OpenpeerSDK/HOPHomeUser.h>
#import <OpenpeerSDK/HOPRolodexContact.h>
#import <OpenpeerSDK/HOPModelManager.h>
#import <OpenpeerSDK/HOPIdentityLookup.h>
#import "LoginManager.h"
#import "ContactsManager.h"
#import "Constants.h"
#import "OpenPeerUser.h"
#import "OpenPeer.h"
#import "MainViewController.h"
#import "ActivityIndicatorViewController.h"

@interface IdentityDelegate()

@property (nonatomic,strong) NSMutableDictionary* loginWebViewsDictionary;
- (WebLoginViewController*) getLoginWebViewForIdentity:(HOPIdentity*) identity;
- (void) removeLoginWebViewForIdentity:(HOPIdentity*) identity;
@end

@implementation IdentityDelegate

- (id)init
{
    self = [super init];
    if (self)
    {
        self.loginWebViewsDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/**
 Retrieves web login view for specific identity. If web login view doesn't exist it will be created.
 @param identity HOPIdentity Login user identity.
 @returns WebLoginViewController web login view
 */
- (WebLoginViewController*) getLoginWebViewForIdentity:(HOPIdentity*) identity
{
    WebLoginViewController* ret = nil;
    
    ret = [self.loginWebViewsDictionary objectForKey:[identity getBaseIdentityURI]];
    if (!ret)
    {
        ret= [[WebLoginViewController alloc] initWithCoreObject:identity];
        ret.view.hidden = YES;
        [self.loginWebViewsDictionary setObject:ret forKey:[identity getBaseIdentityURI]];
    }
    return ret;
}

- (void) removeLoginWebViewForIdentity:(HOPIdentity*) identity
{
    [self.loginWebViewsDictionary removeObjectForKey:[identity getBaseIdentityURI]];
}

- (void)identity:(HOPIdentity *)identity stateChanged:(HOPIdentityStates)state
{
    NSLog(@"Identity login state: %@",[HOPIdentity stringForIdentityState:state]);
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        WebLoginViewController* webLoginViewController = [self getLoginWebViewForIdentity:identity];
        NSString* relogininfo = nil;
        
        switch (state)
        {
            case HOPIdentityStatePending:
                
                break;
            
            case HOPIdentityStatePendingAssociation:
                
                break;
                
            case HOPIdentityStateWaitingAttachmentOfDelegate:
                
                break;
                
            case HOPIdentityStateWaitingForBrowserWindowToBeLoaded:
                //Login url is received. Remove activity indicator
                [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:NO withText:nil inView:nil];
                [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:YES withText:@"Opening login page ..." inView:[[[OpenPeer sharedOpenPeer] mainViewController] view]];

                //Open identity login web page
                [webLoginViewController openLoginUrl:outerFrameURL];
                break;
                
            case HOPIdentityStateWaitingForBrowserWindowToBeMadeVisible:
                webLoginViewController.view.hidden = NO;
                if (!webLoginViewController.view.superview)
                {
                    [[[OpenPeer sharedOpenPeer] mainViewController] showWebLoginView:webLoginViewController];
                    [webLoginViewController.view setFrame:[[OpenPeer sharedOpenPeer] mainViewController].view.bounds];
                }
                [identity notifyBrowserWindowVisible];
                break;
                
            case HOPIdentityStateWaitingForBrowserWindowToClose:
                //Detach the web view
                [identity notifyBrowserWindowClosed];
                [webLoginViewController.view removeFromSuperview];
                [self removeLoginWebViewForIdentity:identity];
                break;
                
            case HOPIdentityStateReady:
#warning TODO: Find better place to save relogin info
                relogininfo = [[HOPAccount sharedAccount] getReloginInformation];
                if ([relogininfo length] > 0)
                {
                    NSLog(@"Relogin info: %@", relogininfo);
                    HOPHomeUser* previousLoggedInHomeUser = [[HOPModelManager sharedModelManager] getLastLoggedInHomeUser];
                    HOPHomeUser* homeUser = [[HOPModelManager sharedModelManager] getHomeUserByStableID:[[HOPAccount sharedAccount] getStableID]];
                    
                    if (homeUser)
                    {
                        if (![homeUser.loggedIn boolValue])
                        {
                            previousLoggedInHomeUser.loggedIn = NO;
                            homeUser.loggedIn = [NSNumber numberWithBool: YES];
                            [[HOPModelManager sharedModelManager] saveContext];
                        }
                    }
                    else
                    {
                        homeUser = (HOPHomeUser*)[[HOPModelManager sharedModelManager] createObjectForEntity:@"HOPHomeUser"];
                        homeUser.stableId = [[HOPAccount sharedAccount] getStableID];
                        homeUser.reloginInfo = [[HOPAccount sharedAccount] getReloginInformation];
                        homeUser.loggedIn = [NSNumber numberWithBool: YES];
                        if (previousLoggedInHomeUser)
                            previousLoggedInHomeUser.loggedIn = NO;
                        
                        [[HOPModelManager sharedModelManager] saveContext];
                    }
                }
                break;
                
            case HOPIdentityStateShutdown:
                [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:NO withText:nil inView:nil];
                [[[OpenPeer sharedOpenPeer] mainViewController] showLoginView];
                break;
                
            default:
                break;
        }
    });
}

- (void)onIdentityPendingMessageForInnerBrowserWindowFrame:(HOPIdentity *)identity
{
    NSLog(@"onIdentityPendingMessageForInnerBrowserWindowFrame");
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        //Get login web view for specified identity
        WebLoginViewController* webLoginViewController = [self getLoginWebViewForIdentity:identity];
        if (webLoginViewController)
        {
            NSString* jsMethod = [NSString stringWithFormat:@"sendBundleToJS(\'%@\')", [identity getNextMessageForInnerBrowerWindowFrame]];
            NSLog(@"\n\nSent to inner frame: %@\n\n",jsMethod);
            //Pass JSON message to java script
            [webLoginViewController passMessageToJS:jsMethod];
        }
    });
}

- (void)onIdentityRolodexContactsDownloaded:(HOPIdentity *)identity
{
    if (identity)
    {
        BOOL flushAllRolodexContacts;
        NSString* downloadedVersion;
        NSArray* rolodexContacts;
        
        BOOL rolodexContactsObtained = [identity getDownloadedRolodexContacts:&flushAllRolodexContacts outVersionDownloaded:&downloadedVersion outRolodexContacts:&rolodexContacts];
        
        NSArray* allUserRolodexContacts = [[HOPModelManager sharedModelManager]getRolodexContactsForHomeUserIdentityURI:[identity getIdentityURI] openPeerContacts:NO];
        
        [identity stopTimerForContactsDeletion];
        
        if (rolodexContactsObtained)
        {
            [rolodexContacts setValue:[NSNumber numberWithBool:NO] forKey:@"readyForDeletion"];
            [[ContactsManager sharedContactsManager] identityLookupForContacts:allUserRolodexContacts identityServiceDomain:[identity getIdentityProviderDomain]];
            
            NSArray* contactsToDelete = [[HOPModelManager sharedModelManager] getAllRolodexContactsMarkedForDeletionForHomeUserIdentityURI:[identity getIdentityURI]];
            if ([contactsToDelete count] > 0)
                [identity startTimerForContactsDeletion];
        }
        else if (flushAllRolodexContacts)
        {
            [identity startTimerForContactsDeletion];
            [allUserRolodexContacts setValue:[NSNumber numberWithBool:YES] forKey:@"readyForDeletion"];
            [[HOPModelManager sharedModelManager] saveContext];
        }

    }
}

@end

