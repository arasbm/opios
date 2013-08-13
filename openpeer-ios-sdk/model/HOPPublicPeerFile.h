//
//  HOPPublicPeerFile.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 8/12/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPIdentityContact;

@interface HOPPublicPeerFile : NSManagedObject

@property (nonatomic, retain) NSString * peerFile;
@property (nonatomic, retain) NSString * peerURI;
@property (nonatomic, retain) NSSet *identityContacts;
@end

@interface HOPPublicPeerFile (CoreDataGeneratedAccessors)

- (void)addIdentityContactsObject:(HOPIdentityContact *)value;
- (void)removeIdentityContactsObject:(HOPIdentityContact *)value;
- (void)addIdentityContacts:(NSSet *)values;
- (void)removeIdentityContacts:(NSSet *)values;

@end
