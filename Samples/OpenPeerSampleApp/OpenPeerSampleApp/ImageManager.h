//
//  ImageManager.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 11/28/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HOPAvatar;
@class HOPImage;

@interface ImageManager : NSObject

+ (id) sharedImageManager;

- (id) init __attribute__((unavailable("ImageManager is singleton class.")));

- (void) donwloadImageForAvatar:(HOPAvatar*) avatar tableView:(UITableView*) inTableView indexPath:(NSIndexPath*) inIndexPath;
@end
