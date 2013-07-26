//
//  HOPPublicPeerFile.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 7/25/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPIdentityContact;

@interface HOPPublicPeerFile : NSManagedObject

@property (nonatomic, retain) NSString * peerFile;
@property (nonatomic, retain) NSString * peerURI;
@property (nonatomic, retain) NSSet *identityContact;
@end

@interface HOPPublicPeerFile (CoreDataGeneratedAccessors)

- (void)addIdentityContactObject:(HOPIdentityContact *)value;
- (void)removeIdentityContactObject:(HOPIdentityContact *)value;
- (void)addIdentityContact:(NSSet *)values;
- (void)removeIdentityContact:(NSSet *)values;

@end
