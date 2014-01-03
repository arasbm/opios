//
//  CoreDataManager.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 1/3/14.
//  Copyright (c) 2014 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedCoreDataManager;
- (id) init __attribute__((unavailable("HOPModelManager is singleton class.")));

- (NSString*) getCookieWithPath:(NSString*) path;
- (void) setCookie:(NSString*) data withPath:(NSString*) path expires:(NSDate*) expires;
- (void) removeCookieForPath:(NSString*) path;
- (void) removeExpiredCookies;
@end
