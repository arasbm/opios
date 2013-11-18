//
//  ContactTableViewCell.m
//  Hookflash
//
//  Created by Zeljko on 6/16/11.
//  Copyright 2012 SMB Phone Inc. All rights reserved.
//

#import "ContactTableViewCell.h"
#import <OpenpeerSDK/HOPRolodexContact+External.h>
#import <OpenpeerSDK/HOPAssociatedIdentity.h>
#import <OpenpeerSDK/HOPAvatar+External.h>
#import "IconDownloader.h"
#import "AppConsts.h"

#define AVATAR_WIDTH 0 //31.0
#define AVATAR_HEIGHT 0 //31.0

@interface ContactTableViewCell ()

@property (weak, nonatomic) UITableView* tableView;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
- (void)startIconDownloadForAvatar:(HOPAvatar*) avatar atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ContactTableViewCell

- (NSMutableDictionary*) imageDownloadsInProgress
{
    if (_imageDownloadsInProgress)
    {
        _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    }
    
    return _imageDownloadsInProgress;
}

- (void) setContact:(HOPRolodexContact *)inContact
{
    _contact = inContact;
    
    self.displayName.text = [self.contact name];
    
    self.username.textColor = [UIColor colorWithRed:112.0/255.0 green:116.0/255.0 blue:119.0/255.0 alpha:1.0];

    self.username.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.username.text = _contact.identityURI;
    
    if ([inContact.associatedIdentity.baseIdentityURI isEqualToString:identityFacebookBaseURI])
    {
        UIImageView *facebookTag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook_tag.png"]];
        [facebookTag setFrame:CGRectMake(self.displayImage.frame.size.width - 10.0, self.displayImage.frame.size.height-10.0, 10.0, 10.0)];
        [self.displayImage addSubview:facebookTag];
    }
    
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

- (void) setContact:(HOPRolodexContact *)inContact inTable:(UITableView*) table atIndexPath:(NSIndexPath *)indexPath
{
    _contact = inContact;
    
    self.tableView = table;
    self.displayName.text = [self.contact name];
    
    self.username.textColor = [UIColor colorWithRed:112.0/255.0 green:116.0/255.0 blue:119.0/255.0 alpha:1.0];
    
    self.username.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.username.text = _contact.identityURI;
    
    HOPAvatar* avatar = [inContact getAvatarForWidth:[NSNumber numberWithFloat:AVATAR_WIDTH] height:[NSNumber numberWithFloat:AVATAR_HEIGHT]];
    if (avatar)
    {
        UIImage* img = [avatar getImage];
        if (!img)
            [self startIconDownloadForAvatar:avatar atIndexPath:indexPath];
        else
        {
            self.displayImage.contentMode = UIViewContentModeScaleAspectFill;
            self.displayImage.clipsToBounds = YES;
            self.displayImage.image = img;
        }
        
    }
    
    if ([inContact.associatedIdentity.baseIdentityURI isEqualToString:identityFacebookBaseURI])
    {
        UIImageView *facebookTag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook_tag.png"]];
        [facebookTag setFrame:CGRectMake(self.displayImage.frame.size.width - 10.0, self.displayImage.frame.size.height-10.0, 10.0, 10.0)];
        [self.displayImage addSubview:facebookTag];
    }
    
    //if (self.contact.status != OFFLINE)
    {
        self.displayName.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.displayName.textColor = [UIColor blackColor];
    }
}

- (void)startIconDownloadForAvatar:(HOPAvatar*) avatar atIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        [iconDownloader setCompletionHandler:^(UIImage* downloadedImage)
        {
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            [avatar storeImage:downloadedImage];
            
            cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            cell.imageView.clipsToBounds = YES;
            
            // Display the newly loaded image
            cell.imageView.image = downloadedImage;
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownloadForURL:avatar.url];
    }
}

@end
