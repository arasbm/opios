//
//  HOPIdentityProvider.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 8/12/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPHomeUser, HOPRolodexContact;

@interface HOPIdentityProvider : NSManagedObject

@property (nonatomic, retain) NSString * baseIdentityURI;
@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSDate * lastDownloadTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) HOPHomeUser *homeUser;
@property (nonatomic, retain) HOPRolodexContact *homeUserProfile;
@property (nonatomic, retain) NSSet *rolodexContacts;
@end

@interface HOPIdentityProvider (CoreDataGeneratedAccessors)

- (void)addRolodexContactsObject:(HOPRolodexContact *)value;
- (void)removeRolodexContactsObject:(HOPRolodexContact *)value;
- (void)addRolodexContacts:(NSSet *)values;
- (void)removeRolodexContacts:(NSSet *)values;

@end
