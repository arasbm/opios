//
//  AppLog.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/3/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSLog(...) AppLog(__VA_ARGS__)

void AppLog(NSString* format,...);
