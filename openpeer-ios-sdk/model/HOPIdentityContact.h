//
//  HOPIdentityContact.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 7/19/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPRolodexContact, PublicPeerFile;

@interface HOPIdentityContact : NSManagedObject

@property (nonatomic, retain) NSDate * expires;
@property (nonatomic, retain) NSString * identityProofBundle;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSString * stableID;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) PublicPeerFile *peerFile;
@property (nonatomic, retain) HOPRolodexContact *rolodexContact;

@end
