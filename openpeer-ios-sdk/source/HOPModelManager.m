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

#import "HOPModelManager.h"
#import "HOPRolodexContact.h"
#import "HOPIdentityContact.h"
#import "HOPIdentityProvider.h"
#import "HOPPublicPeerFile.h"
#import "HOPAvatar.h"
#import "HOPHomeUser.h"
#import "OpenPeerConstants.h"
#import <CoreData/CoreData.h>

@interface HOPModelManager()

- (id) initSingleton;
- (NSArray*) getResultsForEntity:(NSString*) entityName withPredicateString:(NSString*) predicateString;
@end

@implementation HOPModelManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedModelManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initSingleton];
    });
    return _sharedObject;
}

- (id) initSingleton
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"OpenPeerDataModel" ofType:@"bundle"];
    NSURL *modelURL = [[NSBundle bundleWithPath:bundlePath] URLForResource:@"OpenPeerModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pathDirectory = [libraryPath stringByAppendingPathComponent:databaseDirectory];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:pathDirectory withIntermediateDirectories:YES attributes:nil error:&error])
    {
        [NSException raise:@"Failed creating directory" format:@"[%@], %@", pathDirectory, error];
    }
    
    NSString *path = [pathDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",databaseName]];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
#warning TODO: remove this comment
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data storing

- (void)saveContext
{
    NSError *error = nil;
    if (self.managedObjectContext != nil)
    {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void) deleteObject:(NSManagedObject*) managedObjectToDelete
{
    [self.managedObjectContext deleteObject:managedObjectToDelete];
}

- (NSManagedObject*) createObjectForEntity:(NSString*) entityName
{
    NSManagedObject* ret = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    return ret;
}

#pragma mark - Core Data retrieving
- (NSArray*) getResultsForEntity:(NSString*) entityName withPredicateString:(NSString*) predicateString
{
    NSArray* ret = nil;
    
    if ([entityName length] > 0)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        if ([predicateString length] > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
            [fetchRequest setPredicate:predicate];
        }
        
        NSError *error;
        NSArray *fetchedObjects  = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if (!error)
        {
            if([fetchedObjects count] > 0)
            {
                ret = fetchedObjects;
            }
        }
    }
    return ret;
}

- (HOPRolodexContact *) getRolodexContactByIdentityURI:(NSString*) identityURI
{
    HOPRolodexContact* ret = nil;
    
    NSArray* results = [self getResultsForEntity:@"HOPRolodexContact" withPredicateString:[NSString stringWithFormat:@"(identityURI MATCHES '%@')", identityURI]];
    
    if([results count] > 0)
    {
        ret = [results objectAtIndex:0];
    }
    
    return ret;
}

- (NSArray *) getRolodexContactsByPeerURI:(NSString*) peerURI
{
    NSArray* ret = [self getResultsForEntity:@"HOPRolodexContact" withPredicateString:[NSString stringWithFormat:@"(ANY identityContact.peerFile.peerURI MATCHES '%@')", peerURI]];
    
    return ret;
}

- (NSArray*) getAllRolodexContactForHomeUserIdentityURI:(NSString*) homeUserIdentityURI
{
    NSArray* ret = nil;
    NSArray* results = [self getResultsForEntity:@"HOPIdentityProvider" withPredicateString:[NSString stringWithFormat:@"(homeUserProfile.identityURI MATCHES '%@')",homeUserIdentityURI]];
    
    if([results count] > 0)
    {
        HOPIdentityProvider* identityProvider = [results objectAtIndex:0];
        ret = [identityProvider.rolodexContacts allObjects];
    }
    return ret;
}

- (NSArray*) getRolodexContactsForHomeUserIdentityURI:(NSString*) homeUserIdentityURI openPeerContacts:(BOOL) openPeerContacts
{
    NSArray* ret = nil;
    NSString* stringFormat = nil;
    
    if (openPeerContacts)
    {
        stringFormat = [NSString stringWithFormat:@"(identityContact != nil || identityContact.@count > 0 && identityProvider.homeUserProfile.identityURI MATCHES '%@')",homeUserIdentityURI];
    }
    else
    {
        stringFormat = [NSString stringWithFormat:@"(identityContact == nil || identityContact.@count == 0 && identityProvider.homeUserProfile.identityURI MATCHES '%@')",homeUserIdentityURI];
    }
    
    ret = [self getResultsForEntity:@"HOPRolodexContact" withPredicateString:stringFormat];
    
    return ret;
}

- (HOPIdentityContact*) getIdentityContactByStableID:(NSString*) stableID identityURI:(NSString*) identityURI
{
    HOPIdentityContact* ret = nil;
    
    NSArray* results = [self getResultsForEntity:@"HOPIdentityContact" withPredicateString:[NSString stringWithFormat:@"(stableID MATCHES '%@' AND rolodexContact.identityURI MATCHES '%@')", stableID, identityURI]];
    
    if([results count] > 0)
    {
        ret = [results objectAtIndex:0];
    }
    
    return ret;
}

- (HOPPublicPeerFile*) getPublicPeerFileForPeerURI:(NSString*) peerURI
{
    HOPPublicPeerFile* ret = nil;
    
    NSArray* results = [self getResultsForEntity:@"HOPPublicPeerFile" withPredicateString:[NSString stringWithFormat:@"(peerURI MATCHES '%@')", peerURI]];
    
    if([results count] > 0)
    {
        ret = [results objectAtIndex:0];
    }
    
    return ret;
}

- (HOPIdentityProvider *) getIdentityProviderByDomain:(NSString*) identityProviderDomain identityName:(NSString*) identityName homeUserIdentityURI:(NSString*) homeUserIdentityURI
{
    HOPIdentityProvider* ret = nil;
    
    NSArray* results = [self getResultsForEntity:@"HOPIdentityProvider" withPredicateString:[NSString stringWithFormat:@"(domain MATCHES '%@' AND name MATCHES '%@' AND homeUser.identityURI MATCHES '%@')", identityProviderDomain, identityName, homeUserIdentityURI]];
    
    if([results count] > 0)
    {
        ret = [results objectAtIndex:0];
    }
    
    return ret;
}

- (NSArray*) getAllIdentitiesInfoForHomeUserIdentityURI:(NSString*) identityURI
{
    NSArray* ret = [self getResultsForEntity:@"HOPIdentityProvider" withPredicateString:[NSString stringWithFormat:@"(homeUser.identityURI MATCHES '%@')", identityURI]];
    
    return ret;
}

- (HOPAvatar*) getAvatarByURL:(NSString*) url
{
    HOPAvatar* ret = nil;
    
    NSArray* results = [self getResultsForEntity:@"HOPAvatar" withPredicateString:[NSString stringWithFormat:@"(url MATCHES '%@')", url]];
    
    if([results count] > 0)
    {
        ret = [results objectAtIndex:0];
    }
    
    return ret;
}

- (HOPHomeUser*) getLastLoggedInHomeUser
{
    HOPHomeUser* ret = nil;
    
    NSArray* results = [self getResultsForEntity:@"HOPHomeUser" withPredicateString:@"(loggedIn == YES)"];
    
    if([results count] > 0)
    {
        ret = [results objectAtIndex:0];
    }
    
    return ret;
}

- (HOPHomeUser*) getHomeUserByStableID:(NSString*) stableID
{
    HOPHomeUser* ret = nil;
    
    NSArray* results = [self getResultsForEntity:@"HOPHomeUser" withPredicateString:[NSString stringWithFormat:@"(stableId MATCHES '%@')", stableID]];
    
    if([results count] > 0)
    {
        ret = [results objectAtIndex:0];
    }
    
    return ret;
}

- (void) deleteAllMarkedRolodexContactsForHomeUserIdentityURI:(NSString*) homeUserIdentityURI
{
    NSArray* objectsForDeleteion = nil;
    NSArray* results = [self getResultsForEntity:@"HOPIdentityProvider" withPredicateString:[NSString stringWithFormat:@"(ANY rolodexContacts.readyForDeletion == YES AND homeUserProfile.identityURI MATCHES '%@')",homeUserIdentityURI]];
    
    if([results count] > 0)
    {
        HOPIdentityProvider* identityProvider = [results objectAtIndex:0];
        objectsForDeleteion = [identityProvider.rolodexContacts allObjects];
        for (NSManagedObject* objectToDelete in objectsForDeleteion)
        {
            [self deleteObject:objectToDelete];
        }
        [self saveContext];
    }
}

- (NSArray*) getAllRolodexContactsMarkedForDeletionForHomeUserIdentityURI:(NSString*) homeUserIdentityURI
{
     NSArray* ret = [self getResultsForEntity:@"HOPRolodexContact" withPredicateString:[NSString stringWithFormat:@"(ANY identityProvider.rolodexContacts.identityContact.rolodexContacts.readyForDeletion == YES AND identityProvider.rolodexContacts.identityContact.homeUserProfile.identityURI MATCHES '%@')",homeUserIdentityURI]];
    
    return ret;
}

- (NSArray*) getRolodexContactsForRefreshByHomeUserIdentityURI:(NSString*) homeUserIdentityURI lastRefreshTime:(NSDate*) lastRefreshTime
{
    NSArray* ret = [self getResultsForEntity:@"HOPRolodexContact" withPredicateString:[NSString stringWithFormat:@"(identityProvider.homeUserProfile.identityURI MATCHES '%@' AND (ANY identityProvider.rolodexContacts.identityContact == nil OR ANY identityProvider.rolodexContacts.identityContact.lastUpdated < %@)",homeUserIdentityURI,lastRefreshTime]];
    
    return ret;
}

- (void) fillCoreData
{
    HOPRolodexContact* test = [self getRolodexContactByIdentityURI:@"identityURIVeseli1"];
    if (!test)
    {
        HOPHomeUser* homeUser = (HOPHomeUser*)[self createObjectForEntity:@"HOPHomeUser"];
        homeUser.stableId = @"StabilniVeselnik";
        homeUser.loggedIn = [NSNumber numberWithBool:YES];
        
        HOPIdentityProvider* identityProvider = (HOPIdentityProvider*)[self createObjectForEntity:@"HOPIdentityProvider"];
        
        identityProvider.baseIdentityURI = @"baseVeseliIdentityURI";
        identityProvider.domain = @"identityProviderDomainVeseli";
        identityProvider.lastDownloadTime = [NSDate date];
        identityProvider.name = @"Veseli";
        identityProvider.homeUser = homeUser;
        
        //homeUser.identityProvider = [NSSet setWithObject: identityProvider];
        
        HOPAvatar* hopAvatar = (HOPAvatar*)[self createObjectForEntity:@"HOPAvatar"];
        hopAvatar.url = @"http://i1.ytimg.com/vi/HsCQKM4wscc/default.jpg";
        hopAvatar.name = @"Ma gonite se";
        
        HOPRolodexContact* rolodexContact = (HOPRolodexContact*)[self createObjectForEntity:@"HOPRolodexContact"];
        
        rolodexContact.identityURI = @"identityURIVeseli1";
        rolodexContact.name = @"Veselnikov drugar 1";
        
        rolodexContact.identityProvider = identityProvider;
        NSMutableSet *avatars1 = [rolodexContact mutableSetValueForKey:@"avatars"];
        [avatars1 addObject:hopAvatar];
        
        HOPRolodexContact* rolodexContact2 = (HOPRolodexContact*)[self createObjectForEntity:@"HOPRolodexContact"];
        
        rolodexContact2.identityURI = @"identityURIVeseli2";
        rolodexContact2.name = @"Veselnikov drugar 2P";
        NSMutableSet *avatars2 = [rolodexContact2 mutableSetValueForKey:@"avatars"];
        [avatars2 addObject:hopAvatar];
        
        rolodexContact2.identityProvider = identityProvider;
        
        HOPIdentityContact* identityContact = (HOPIdentityContact*)[self createObjectForEntity:@"HOPIdentityContact"];
        identityContact.identityProofBundle = @"ddd";
        identityContact.lastUpdated = [NSDate date];
        identityContact.priority = [NSNumber numberWithInt:1];
        identityContact.stableID = @"MamuVam";
        
        HOPPublicPeerFile* publicPeerFile = (HOPPublicPeerFile*)[self createObjectForEntity:@"HOPPublicPeerFile"];
        
        publicPeerFile.peerFile = @"fdngve9r-tut84ngf-9e8tu34ng9er25=jgue=tjg-93j=tg=54j3tgn4=jt4-t3j";
        publicPeerFile.peerURI = @"sssaaaassssaaaa";
        identityContact.peerFile = publicPeerFile;
        
        identityContact.rolodexContact = rolodexContact2;
        
        HOPAvatar* hopAvatar2 = (HOPAvatar*)[self createObjectForEntity:@"HOPAvatar"];
        hopAvatar2.url = @"http://i1.ytimg.com/i/j7hXPeXEg6rbc4y_IuhLaw/1.jpg?v=4ffd3f34";
        hopAvatar2.name = @"Gonite se";
        
        HOPRolodexContact* rolodexContact3 = (HOPRolodexContact*)[self createObjectForEntity:@"HOPRolodexContact"];
        
        rolodexContact3.identityURI = @"identityURIVeseli3";
        rolodexContact3.name = @"Veselnikov drugar 3P";
        NSMutableSet *avatars3 = [rolodexContact3 mutableSetValueForKey:@"avatars"];
        [avatars3 addObject:hopAvatar2];
        //[avatars1 addObject:hopAvatar2];
        
        rolodexContact3.identityProvider = identityProvider;
        
        HOPIdentityContact* identityContact3 = (HOPIdentityContact*)[self createObjectForEntity:@"HOPIdentityContact"];
        identityContact3.identityProofBundle = @"ddd3";
        identityContact3.lastUpdated = [NSDate date];
        identityContact3.priority = [NSNumber numberWithInt:1];
        identityContact3.stableID = @"MamuVam3";
        
        HOPPublicPeerFile* publicPeerFile3 = (HOPPublicPeerFile*)[self createObjectForEntity:@"HOPPublicPeerFile"];
        
        publicPeerFile3.peerFile = @"fdngve9r-tut84ngf-9e8tu34ng9er25=jgue=tjg-93j=tg=54j3tgn4=jt4-t3j3";
        publicPeerFile3.peerURI = @"sssaaaassssaaaa3";
        identityContact3.peerFile = publicPeerFile3;
        
        identityContact3.rolodexContact = rolodexContact3;
        
        [self saveContext];
    }
    else
    {
        
        
    }
}

@end
