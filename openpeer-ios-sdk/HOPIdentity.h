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


#import <Foundation/Foundation.h>
#import "HOPTypes.h"
#import "HOPProtocols.h"

/**
 Wrapper for identity state data.
 */
@interface HOPIdentityState : NSObject

@property (nonatomic, assign) HOPIdentityStates state;
@property (nonatomic, assign) unsigned short lastErrorCode;
@property (nonatomic, strong) NSString* lastErrorReason;
@end


@interface HOPIdentity : NSObject

@property (nonatomic, strong) NSString* identityBaseURI;
@property (copy) NSString* identityId;

/**
 Converts identity state enum to string
 @param state HOPIdentityStates Identity state enum
 @returns String representation of identity state
 */
+ stateToString:(HOPIdentityStates) state;

/**
 Creates identity object and starts identity login. This method is called only on login procedure. During relogin procedure this method is not invoked.
 @param inIdentityDelegate HOPIdentityDelegate delegate
 @param redirectAfterLoginCompleteURL NSString String that will be passed from JS after login is completed. (It can be any string)
 @param identityURIOridentityBaseURI NSString Base URI of identity provider (e.g. identity://facebook.com/),  or contact specific identity URI (e.g. identity://facebook.com/contact_facebook_id)
 @param identityProviderDomain NSString Identity provider domain
 @returns HOPIdentity object if IIdentityPtr object is created sucessfully, otherwise nil
 */
+ (id) loginWithDelegate:(id<HOPIdentityDelegate>) inIdentityDelegate redirectAfterLoginCompleteURL:(NSString*) redirectAfterLoginCompleteURL identityURIOridentityBaseURI:(NSString*) identityURIOridentityBaseURI identityProviderDomain:(NSString*) identityProviderDomain;

/**
 Retrieves identity state
 @returns HOPIdentityState Identity state
 */
- (HOPIdentityState*) getState;

/**
 Retrieves whether identiy is attached or not.
 @returns BOOL YES if attached, otherwise NO
 */
- (BOOL) isAttached;

/**
 Attaches identity with specified redirection URL and identity delegate
 @param redirectAfterLoginCompleteURL NSString Redirection URL that will be received after login is completed
 @param inIdentityDelegate HOPIdentityDelegate IIdentityDelegate delegate

 */
- (void) attachWithRedirectionURL:(NSString*) redirectAfterLoginCompleteURL identityDelegate:(id<HOPIdentityDelegate>) inIdentityDelegate;

/**
 Retrieves identity URI
 @returns NSString identity URI
 */
- (NSString*) getIdentityURI;

/**
 Retrieves identity provider domain
 @returns NSString identity provider domain
 */
- (NSString*) getIdentityProviderDomain;

/**
 Retrieves identity relogin access key
 @returns NSString identity relogin access key
 */
- (NSString*) getIdentityReloginAccessKey;

/**
 Retrieves identity bundle
 @returns NSString identity bundle
 */
- (NSString*) getSignedIdentityBundle;

/**
 Retrieves identity login URL
 @returns NSString identity login URL
 */
- (NSString*) getIdentityLoginURL;

/**
 Retrieves date when login expires
 @returns NSString date when login expired
 */
- (NSDate*) getLoginExpires;

/**
 Notifies core that web wiev is now visible.
 */
- (void) notifyBrowserWindowVisible;

/**
 Notifies core that redirection URL for completed login is received.
 */
- (void) notifyLoginCompleteBrowserWindowRedirection;

/**
 Retrieves JSON message from core that needs to be passed to inner browser frame.
 @returns NSString JSON message
 */
- (NSString*) getNextMessageForInnerBrowerWindowFrame;

/**
 Passes JSON message from inner browser frame to core.
 @param NSString JSON message
 */
- (void) handleMessageFromInnerBrowserWindowFrame:(NSString*) message;

/**
 Cancels identity login.
 */
- (void) cancel;
@end
