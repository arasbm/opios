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

@class HOPIdentity;

@interface HOPAccountState : NSObject

@property (nonatomic, assign) HOPAccountStates state;
@property (nonatomic, assign) unsigned short errorCode;
@property (nonatomic, strong) NSString* errorReason;

@end

/**
 Singleton class to represent the logged in openpeer user.
 */
@interface HOPAccount : NSObject

+ (HOPAccount*) sharedAccount;

/**
 Converts account state enum to string
 @param state HOPAccountStates Account state enum
 @returns String representation of account state
 */
+ (NSString*) stateToString:(HOPAccountStates) state;

//TODO: update comment
/**
 Login method for verified identity.
 @param inAccountDelegate HOPAccountDelegate delegate
 @param inConversationThreadDelegate HOPConversationThreadDelegate delegate
 @param inCallDelegate HOPCallDelegate delegate
 @param inPeerContactServiceDomain NSString peer contact service domain
 @param inIdentity HOPIdentity identity for which user is being logged in. In case user wants to associate more identites, after successfull login should call associateIdentities and provide list of identities to assoicate.
 @returns YES if IAccount object is created sucessfully
 */
- (BOOL) loginWithAccountDelegate:(id<HOPAccountDelegate>) inAccountDelegate conversationThreadDelegate:(id<HOPConversationThreadDelegate>) inConversationThreadDelegate callDelegate:(id<HOPCallDelegate>) inCallDelegate namespaceGrantOuterFrameURLUponReload:(NSString*) namespaceGrantOuterFrameURLUponReload  grantID:(NSString*) grantID lockboxServiceDomain:(NSString*) lockboxServiceDomain forceCreateNewLockboxAccount:(BOOL) forceCreateNewLockboxAccount;
;

/**
 Relogin method for exisitng user.
 @param inAccountDelegate HOPAccountDelegate delegate
 @param inConversationThreadDelegate HOPConversationThreadDelegate delegate
 @param inCallDelegate HOPCallDelegate delegate
 @param peerFilePrivate NSString private peer file
 @param peerFilePrivateSecret NSData private peer file secret
 @returns YES if IAccount object is created sucessfully
 */
- (BOOL) reloginWithAccountDelegate:(id<HOPAccountDelegate>) inAccountDelegate conversationThreadDelegate:(id<HOPConversationThreadDelegate>) inConversationThreadDelegate callDelegate:(id<HOPCallDelegate>) inCallDelegate lockboxOuterFrameURLUponReload:(NSString *)lockboxOuterFrameURLUponReload lockboxReloginInfo:(NSString *)lockboxReloginInfo;

/**
 Retrieves account state
 @returns Account state enum
 */
- (HOPAccountState*) getState;

/**
 Retrieves logged in user id
 @returns User id
 */
//- (NSString*) getUserID;

/**
 Retrieves user location id.
 @returns location id
 */
- (NSString*) getLocationID;

/**
 Shutdowns account object. Called on logout.
 */
- (void) shutdown;

/**
 Retrieves user private peer file.
 @returns private peer file
 */
- (NSString*) getPeerFilePrivate;

/**
 Retrieves user's private peer file secret.
 @returns private peer file secret
 */
- (NSData*) getPeerFilePrivateSecret;

/**
 Retrieves list of associated identites.
 @returns list of associated identites
 */
- (NSArray*) getAssociatedIdentities;

/**
 Associates or removes identites provided in input lists.
 @param inIdentitiesToAssociate NSArray List of identites to associate with logged in user
 @param inIdentitiesToRemove NSArray List of identites to remove for logged in user
 */
- (void) associateIdentities:(NSArray*) inIdentitiesToAssociate identitiesToRemove:(NSArray*) inIdentitiesToRemove;

@end