//
//  AppLog.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/3/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define NSLog(...) AppLog([NSString stringWithUTF8String:__PRETTY_FUNCTION__], [NSString stringWithUTF8String:__FILE__], __LINE__, __VA_ARGS__)

void AppLog(NSString* functionName, NSString* filePath, unsigned long lineNumber, NSString* format,...);