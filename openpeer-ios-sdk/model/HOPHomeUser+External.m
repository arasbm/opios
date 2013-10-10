//
//  HOPHomeUser+External.m
//  openpeer-ios-sdk
//
//  Created by Sergej on 10/10/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "HOPHomeUser+External.h"
#import "HOPAssociatedIdentity.h"
#import "HOPRolodexContact.h"

@implementation HOPHomeUser (External)

- (NSString*) getFullName
{
    return ((HOPAssociatedIdentity*)[self.associatedIdentities anyObject]).homeUserProfile.name;
}

@end
