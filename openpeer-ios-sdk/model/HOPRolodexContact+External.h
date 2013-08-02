//
//  HOPRolodexContact+HOPRolodexContact_External.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 7/30/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "HOPRolodexContact.h"

@class HOPContact;

@interface HOPRolodexContact (External)

- (BOOL) isSelf;
- (HOPContact*) getCoreContact;
@end
