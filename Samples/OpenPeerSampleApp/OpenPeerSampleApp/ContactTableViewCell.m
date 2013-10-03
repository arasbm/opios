//
//  ContactTableViewCell.m
//  Hookflash
//
//  Created by Zeljko on 6/16/11.
//  Copyright 2012 SMB Phone Inc. All rights reserved.
//

#import "ContactTableViewCell.h"
#import <OpenpeerSDK/HOPRolodexContact.h>

@interface ContactTableViewCell ()



@end

@implementation ContactTableViewCell


- (void) setContact:(HOPRolodexContact *)inContact
{
    _contact = inContact;
    
    self.displayName.text = [self.contact name];
    
    self.username.textColor = [UIColor colorWithRed:112.0/255.0 green:116.0/255.0 blue:119.0/255.0 alpha:1.0];

    self.username.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.username.text = _contact.identityURI;
    
    UIImage *img = nil;//[self.contact getAvatarImage];
    if(img)
        self.displayImage.image = img;
    
    //if (self.contact.status != OFFLINE)
    {
        self.displayName.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.displayName.textColor = [UIColor blackColor];
    }
    /*else
    {
        self.displayName.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.displayName.textColor = [UIColor colorWithRed:112.0/255.0 green:116.0/255.0 blue:119.0/255.0 alpha:1.0];
        //[self.displayImage setAlpha:0.8];
        [_displayChatImage setAlpha:0.4];
        [_displayVoiceImage setAlpha:0.4];
        [_displayVideoImage setAlpha:0.4];
    }*/
}
@end
