//
//  CoreDataManager.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 1/3/14.
//  Copyright (c) 2014 Hookflash. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "AppConsts.h"
#import "Cache.h"

@implementation CoreDataManager

@synthesize backgroundManagedObjectContext = _backgroundManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedCoreDataManager
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

- (NSManagedObjectContext *)backgroundManagedObjectContext
{
    if (_backgroundManagedObjectContext != nil)
    {
        return _backgroundManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil)
    {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _backgroundManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CacheModel" withExtension:@"momd"];
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
    
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *pathDirectory = [libraryPath stringByAppendingPathComponent:databaseDirectory];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:libraryPath withIntermediateDirectories:YES attributes:nil error:&error])
    {
        [NSException raise:@"Failed creating directory" format:@"[%@], %@", libraryPath, error];
    }
    
    NSString *path = [libraryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",CacheDatabaseName]];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObject*) createObjectInBackgroundForEntity:(NSString*) entityName
{
    NSManagedObject* ret = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.backgroundManagedObjectContext];
    return ret;
}

- (void)saveBackgroundContext
{
    NSError *error = nil;
    if (self.backgroundManagedObjectContext != nil)
    {
        if ([self.backgroundManagedObjectContext hasChanges] && ![self.backgroundManagedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSArray*) getResultsInBackgroundForEntity:(NSString*) entityName withPredicateString:(NSString*) predicateString orderDescriptors:(NSArray*) orderDescriptors
{
    __block NSArray* ret = nil;
    
    if ([entityName length] > 0)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.backgroundManagedObjectContext];
        [fetchRequest setEntity:entity];
        
        if ([predicateString length] > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
            [fetchRequest setPredicate:predicate];
        }
        
        if ([orderDescriptors count] > 0)
            [fetchRequest setSortDescriptors:orderDescriptors];
        
        NSError *error;
        NSArray *fetchedObjects  = [self.backgroundManagedObjectContext executeFetchRequest:fetchRequest error:&error];
        
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

- (Cache*) getCacheDataForPath:(NSString*) path
{
    Cache* ret = nil;
    
    NSArray* results = [self getResultsInBackgroundForEntity:@"Cache" withPredicateString:[NSString stringWithFormat:@"(path MATCHES '%@') AND (expire >= %f)", path, [[NSDate date] timeIntervalSince1970]] orderDescriptors:nil];
    
    ret = [results count] > 0 ? ((Cache*)results[0]) : nil;
    
    return ret;
}

- (void) setCookie:(NSString*) data withPath:(NSString*) path expires:(NSDate*) expires
{
    if ([path length] > 0)
    {
        OPLog(HOPLoggerSeverityInformational, HOPLoggerLevelInsane, @"Set cookie for path %@ with expire date: %@",path, expires == nil ? @"infinitely" : expires);
        [self.backgroundManagedObjectContext performBlockAndWait:
         ^{
             Cache* cacheData = [self getCacheDataForPath:path];
             
             if (!cacheData)
                 cacheData = (Cache*)[self createObjectInBackgroundForEntity:@"Cache"];
             
             cacheData.data = data;
             cacheData.path = path;
             cacheData.expire = [NSNumber numberWithDouble:[expires timeIntervalSince1970]];
             
             [self saveBackgroundContext];
         }];
    }
    else
    {
        OPLog(HOPLoggerSeverityWarning, HOPLoggerLevelInsane, @"Invalid cookie path");
    }
}

- (NSString*) getCookieWithPath:(NSString*) path
{
    __block NSString* ret = nil;
    
    if ([path length] > 0)
    {
        OPLog(HOPLoggerSeverityInformational, HOPLoggerLevelInsane, @"Get cookie for path %@",path);
        
        [self.backgroundManagedObjectContext performBlockAndWait:
         ^{
             Cache* cacheData = [self getCacheDataForPath:path];
             ret = cacheData.data;
         }];
    }
    else
    {
        OPLog(HOPLoggerSeverityWarning, HOPLoggerLevelInsane, @"Invalid cookie path");
    }
    return ret;
}

- (void) removeCookieForPath:(NSString*) path
{
    if ([path length] > 0)
    {
        OPLog(HOPLoggerSeverityInformational, HOPLoggerLevelInsane, @"Delete cookie for path %@",path);
        
        NSArray* objectsToDelete = [self getResultsInBackgroundForEntity:@"Cache" withPredicateString:[NSString stringWithFormat:@"path MATCHES '%@'", path] orderDescriptors:nil];
        for (NSManagedObject* object in objectsToDelete)
            [self.backgroundManagedObjectContext deleteObject:object];
        
        [self saveBackgroundContext];
    }
    else
    {
        OPLog(HOPLoggerSeverityWarning, HOPLoggerLevelInsane, @"Invalid cookie path");
    }
}

- (void) removeExpiredCookies
{
    OPLog(HOPLoggerSeverityInformational, HOPLoggerLevelInsane, @"Removing expired cookies.");
    [self.backgroundManagedObjectContext performBlock:
     ^{
         NSArray* objectsToDelete = [self getResultsInBackgroundForEntity:@"Cache" withPredicateString:[NSString stringWithFormat:@"expire != nil AND (expire < %f)", [[NSDate date] timeIntervalSince1970]] orderDescriptors:nil];
         
         for (NSManagedObject* object in objectsToDelete)
             [self.backgroundManagedObjectContext deleteObject:object];
         
         [self saveBackgroundContext];
     }];
}
@end
