//
//  Logger.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/7/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "Logger.h"
#import "Constants.h"
#import "OpenPeer.h"

#import "OpenpeerSDK/HOPLogger.h"

@implementation Logger

+ (void) setLogLevels
{
    //For each system you can choose log level from HOPClientLogLevelNone (turned off) to HOPClientLogLevelInsane (most detail).
    [HOPLogger setLogLevelbyName:moduleApplication level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleApplication]];
    [HOPLogger setLogLevelbyName:moduleServices level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleServices]];
    [HOPLogger setLogLevelbyName:moduleServicesHttp level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleServicesHttp]];
    [HOPLogger setLogLevelbyName:moduleCore level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleCore]];
    [HOPLogger setLogLevelbyName:moduleStackMessage level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleStackMessage]];
    [HOPLogger setLogLevelbyName:moduleStack level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleStack]];
    [HOPLogger setLogLevelbyName:moduleWebRTC level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleWebRTC]];
    [HOPLogger setLogLevelbyName:moduleZsLib level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleZsLib]];
    [HOPLogger setLogLevelbyName:moduleSDK level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleSDK]];
    [HOPLogger setLogLevelbyName:moduleMedia level:[[Settings sharedSettings] getLoggerLevelForAppModuleKey:moduleMedia]];
}


+ (void) startStdLogger:(BOOL) start
{
    if (start)
    {
        [HOPLogger installStdOutLogger:NO];
    }
    else
        [HOPLogger uninstallStdOutLogger];
}

/**
 Sets log levels and starts the logger.
 */
+ (void) startTelnetLogger:(BOOL) start
{
    if (start)
    {
        NSString* port =[[Settings sharedSettings] getServerPortForLogger:LOGGER_TELNET];
        BOOL colorized = [[Settings sharedSettings] isColorizedOutputForLogger:LOGGER_TELNET];
        if ([port length] > 0)
            [HOPLogger installTelnetLogger:[port intValue] maxSecondsWaitForSocketToBeAvailable:60 colorizeOutput:colorized];
    }
    else
    {
        [HOPLogger uninstallTelnetLogger];
    }
}

+ (void) startOutgoingTelnetLogger:(BOOL) start
{
    if (start)
    {
        NSString* server =[[Settings sharedSettings] getServerPortForLogger:LOGGER_OUTGOING_TELNET];
        BOOL colorized = [[Settings sharedSettings] isColorizedOutputForLogger:LOGGER_OUTGOING_TELNET];
        if ([server length] > 0)
            [HOPLogger installOutgoingTelnetLogger:server colorizeOutput:colorized stringToSendUponConnection:[[OpenPeer sharedOpenPeer] authorizedApplicationId]];
    }
    else
    {
        [HOPLogger uninstallOutgoingTelnetLogger];
    }
}

+ (void) startAllSelectedLoggers
{
    [self setLogLevels];
    [self startStdLogger:[[Settings sharedSettings] isLoggerEnabled:LOGGER_STD_OUT]];
    [self startTelnetLogger:[[Settings sharedSettings] isLoggerEnabled:LOGGER_TELNET]];
    [self startOutgoingTelnetLogger:[[Settings sharedSettings] isLoggerEnabled:LOGGER_OUTGOING_TELNET]];
}


+ (void) start:(BOOL) start logger:(LoggerTypes) type
{
    switch (type)
    {
        case LOGGER_STD_OUT:
            [self startStdLogger:start];
            break;
            
        case LOGGER_TELNET:
            [self startTelnetLogger:start];
            break;
            
        case LOGGER_OUTGOING_TELNET:
            [self startOutgoingTelnetLogger:start];
            break;
            
        default:
            break;
    }
    
}

+ (void) startTelnetLoggerOnStartUp
{
    [[Settings sharedSettings] saveDefaultsLoggerSettings];
    [Logger startAllSelectedLoggers];
}

@end
