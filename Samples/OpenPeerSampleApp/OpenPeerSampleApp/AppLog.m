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
#import <OpenPeerSDK/HOPLogger.h>

void AppLog(NSString* functionName, NSString* filePath, unsigned long lineNumber, NSString* format,...)
{
    if ([[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleApplication])
    {
        va_list argumentList;
        va_start(argumentList, format);
        unsigned int subsystemid = [HOPLogger getApplicationSubsystemID];
        NSString* message = [[NSString alloc] initWithFormat:format arguments:argumentList];
        [HOPLogger log:subsystemid severity:HOPLoggerSeverityInformational level:HOPLoggerLevelTrace message:[@"Application:  " stringByAppendingString: message] function: functionName filePath:filePath lineNumber:lineNumber];
        
        va_end(argumentList);
    }
}


