//
//  HOPImage.h
//  openpeer-ios-sdk
//
//  Created by Sergej on 9/8/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HOPAvatar;

@interface HOPImage : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) HOPAvatar *avatar;

@end
