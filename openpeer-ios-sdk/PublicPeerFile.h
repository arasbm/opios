//
//  PublicPeerFile.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 7/17/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPIdentityContact;

@interface PublicPeerFile : NSManagedObject

@property (nonatomic, retain) NSString * peerFile;
@property (nonatomic, retain) HOPIdentityContact *identityContact;

@end
