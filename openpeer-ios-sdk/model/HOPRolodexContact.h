//
//  HOPRolodexContact.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 7/19/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPAvatar, HOPIdentityContact;

@interface HOPRolodexContact : NSManagedObject

@property (nonatomic, retain) NSString * identityProvider;
@property (nonatomic, retain) NSString * identityURI;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profileURL;
@property (nonatomic, retain) NSString * vProfileURL;
@property (nonatomic, retain) NSSet *avatars;
@property (nonatomic, retain) HOPIdentityContact *identityContact;
@end

@interface HOPRolodexContact (CoreDataGeneratedAccessors)

- (void)addAvatarsObject:(HOPAvatar *)value;
- (void)removeAvatarsObject:(HOPAvatar *)value;
- (void)addAvatars:(NSSet *)values;
- (void)removeAvatars:(NSSet *)values;

@end
