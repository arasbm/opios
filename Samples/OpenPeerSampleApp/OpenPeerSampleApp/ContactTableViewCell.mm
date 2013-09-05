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

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setAccessoryViewFrame:nil];
}

- (void) setAccessoryViewFrame:(NSInteger) howMuch
{
    return;
    CGRect frame = self.accessoryView.frame;
    
    if (self.accessoryView) {
        frame = self.accessoryView.frame;
        frame.origin.x = 263.0;
        frame.origin.y = 14.0;
        frame.size.width = 38;
        frame.size.height = 28.0;
        self.accessoryView.frame = frame;
    }
    else
    {
        UIView* accessoryView = nil;        
        for (UIView* view in self.subviews) {
            if (view != self.textLabel &&
                view != self.detailTextLabel &&
                view != self.backgroundView &&
                view != self.contentView &&
                view != self.selectedBackgroundView &&
                view != self.imageView &&
                view.frame.origin.x > 0
                ) {
                accessoryView = view;
                break;
            }
        }
        frame = accessoryView.frame;
        frame.origin.x = 263.0;
        frame.origin.y = 14.0;
        frame.size.width = 38.0;
        frame.size.height = 28.0;
        accessoryView.frame = frame;        
    }
}


- (void) setContact:(HOPRolodexContact *)inContact
{
    _contact = inContact;
    
    self.displayName.text = [self.contact name];
    
    self.username.textColor = [UIColor colorWithRed:112.0/255.0 green:116.0/255.0 blue:119.0/255.0 alpha:1.0];

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
