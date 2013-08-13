//
//  HOPAvatar.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 8/12/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPRolodexContact;

@interface HOPAvatar : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSSet *rolodexContacts;
@end

@interface HOPAvatar (CoreDataGeneratedAccessors)

- (void)addRolodexContactsObject:(HOPRolodexContact *)value;
- (void)removeRolodexContactsObject:(HOPRolodexContact *)value;
- (void)addRolodexContacts:(NSSet *)values;
- (void)removeRolodexContacts:(NSSet *)values;

@end
