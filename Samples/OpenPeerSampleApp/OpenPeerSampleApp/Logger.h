//
//  Logger.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/7/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface Logger : NSObject

+ (void) setLogLevels;
+ (void) startStdLogger:(BOOL) start;
+ (void) startTelnetLogger:(BOOL) start;
+ (void) startOutgoingTelnetLogger:(BOOL) start;
+ (void) startAllSelectedLoggers;
+ (void) start:(BOOL) start logger:(LoggerTypes) type;
+ (void) startTelnetLoggerOnStartUp;

@end
