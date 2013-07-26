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

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSManagedObject;
@class HOPRolodexContact;
@class HOPIdentityProvider;
@class HOPIdentityContact;
@class HOPPublicPeerFile;

@interface HOPModelManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedModelManager;
- (id) init __attribute__((unavailable("HOPModelManager is singleton class, so the init is not available.")));

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

- (void) deleteObject:(NSManagedObject*) managedObjectToDelete;
- (NSManagedObject*) createObjectForEntity:(NSString*) entityName;

- (HOPRolodexContact *) getRolodexContactByIdentityURI:(NSString*) identityURI;
- (NSArray*) getAllRolodexContactForHomeUserIdentityURI:(NSString*) homeUserIdentityURI;
- (NSArray*) getRolodexContactsForHomeUserIdentityURI:(NSString*) homeUserIdentityURI openPeerContacts:(BOOL) openPeerContacts;

- (HOPIdentityContact*) getIdentityContactByStableID:(NSString*) stableID identityURI:(NSString*) identityURI;

- (HOPPublicPeerFile*) getPublicPeerFileForPeerURI:(NSString*) peerURI;

- (HOPIdentityProvider *) getIdentityProviderByDomain:(NSString*) identityProviderDomain;
- (HOPIdentityProvider *) getIdentityProviderByDomain:(NSString*) identityProviderDomain identityName:(NSString*) identityName homeUserIdentityURI:(NSString*) homeUserIdentityURI;
- (HOPIdentityProvider *) getIdentityProviderByName:(NSString*) name;

@end
