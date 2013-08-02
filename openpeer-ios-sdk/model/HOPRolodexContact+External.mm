//
//  HOPRolodexContact+HOPRolodexContact_External.m
//  openpeer-ios-sdk
//
//  Created by Sergej on 7/30/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "HOPRolodexContact+External.h"
#import "HOPRolodexContact_Internal.h"
#import "OpenPeerStorageManager.h"
#import "HOPContact.h"
#import "HOPIdentityContact.h"
#import "HOPPublicPeerFile.h"

@implementation HOPRolodexContact (External)


- (BOOL) isSelf
{
    return [[self getCoreContact] isSelf];
}

- (HOPContact*) getCoreContact
{
    HOPContact* ret = [[OpenPeerStorageManager sharedStorageManager] getContactForPeerURI:self.identityContact.peerFile.peerURI];
    if (!ret)
    {
        ret = [[HOPContact alloc] initWithPeerFile:self.identityContact.peerFile.peerFile];
    }
    return ret;
}
@end
