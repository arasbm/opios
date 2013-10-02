//
//  HOPAssociatedIdentity.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 9/28/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPHomeUser, HOPRolodexContact;

@interface HOPAssociatedIdentity : NSManagedObject

@property (nonatomic, retain) NSString * baseIdentityURI;
@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSString * downloadedVersion;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) HOPHomeUser *homeUser;
@property (nonatomic, retain) HOPRolodexContact *homeUserProfile;
@property (nonatomic, retain) NSSet *rolodexContacts;
@end

@interface HOPAssociatedIdentity (CoreDataGeneratedAccessors)

- (void)addRolodexContactsObject:(HOPRolodexContact *)value;
- (void)removeRolodexContactsObject:(HOPRolodexContact *)value;
- (void)addRolodexContacts:(NSSet *)values;
- (void)removeRolodexContacts:(NSSet *)values;

@end
