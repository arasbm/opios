//
//  AppLog.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/3/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "AppLog.h"
#import "Settings.h"
#import "Constants.h"


void AppLog(NSString* format,...)
{
    if ([[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleApplication])
    {
        va_list argumentList;
        va_start(argumentList, format);
        NSLogv(format, argumentList);
        va_end(argumentList);
    }
}



