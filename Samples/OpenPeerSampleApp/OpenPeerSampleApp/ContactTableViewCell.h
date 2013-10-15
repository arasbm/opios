//
//  ContactTableViewCell.h
//  Hookflash
//
//  Created by Zeljko on 6/16/11.
//  Copyright 2012 SMB Phone Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HOPRolodexContact;

@interface ContactTableViewCell : UITableViewCell 
{
        
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *displayImage;

@property (weak, nonatomic) IBOutlet UIImageView* displayChatImage;
@property (weak, nonatomic) IBOutlet UIImageView* displayVoiceImage;
@property (weak, nonatomic) IBOutlet UIImageView* displayVideoImage;

 @property (weak,nonatomic) HOPRolodexContact* contact;

//- (void) setAccessoryViewFrame:(NSInteger) howMuch;
- (void) setContact:(HOPRolodexContact *)inContact;
- (void) setContact:(HOPRolodexContact *)inContact inTable:(UITableView*) table atIndexPath:(NSIndexPath *)indexPath;


@end
