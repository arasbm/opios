//
//  Cache.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 1/3/14.
//  Copyright (c) 2014 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cache : NSManagedObject

@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSNumber * expire;
@property (nonatomic, retain) NSString * path;

@end
