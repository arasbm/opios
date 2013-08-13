//
//  HOPHomeUser.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 8/12/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPIdentityProvider;

@interface HOPHomeUser : NSManagedObject

@property (nonatomic, retain) NSNumber * loggedIn;
@property (nonatomic, retain) NSString * reloginInfo;
@property (nonatomic, retain) NSString * stableId;
@property (nonatomic, retain) NSSet *associatedIdentities;
@end

@interface HOPHomeUser (CoreDataGeneratedAccessors)

- (void)addAssociatedIdentitiesObject:(HOPIdentityProvider *)value;
- (void)removeAssociatedIdentitiesObject:(HOPIdentityProvider *)value;
- (void)addAssociatedIdentities:(NSSet *)values;
- (void)removeAssociatedIdentities:(NSSet *)values;

@end
