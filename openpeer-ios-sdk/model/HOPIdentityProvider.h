//
//  HOPIdentityProvider.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 7/25/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPRolodexContact;

@interface HOPIdentityProvider : NSManagedObject

@property (nonatomic, retain) NSString * identityProviderDomain;
@property (nonatomic, retain) NSString * baseIdentityURI;
@property (nonatomic, retain) NSDate * lastDownloadTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * homeUserIdentityURI;
@property (nonatomic, retain) NSSet *rolodexContacts;
@end

@interface HOPIdentityProvider (CoreDataGeneratedAccessors)

- (void)addRolodexContactsObject:(HOPRolodexContact *)value;
- (void)removeRolodexContactsObject:(HOPRolodexContact *)value;
- (void)addRolodexContacts:(NSSet *)values;
- (void)removeRolodexContacts:(NSSet *)values;

@end
