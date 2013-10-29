//
//  Settings.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/1/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "Settings.h"
#import "Constants.h"
#import "OpenPeer.h"
#import "Logger.h"

@interface Settings ()

- (NSString*) getArchiveStringForModule:(Modules) module;
@end

@implementation Settings



/**
 Retrieves singleton object of the Settings.
 @return Singleton object of the Settings.
 */
+ (id) sharedSettings
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initSingleton];
    });
    return _sharedObject;
}

- (id)initSingleton
{
    self = [super init];
    if (self)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:archiveRemoteSessionActivationMode])
            self.isRemoteSessionActivationModeOn = [[[NSUserDefaults standardUserDefaults] objectForKey:archiveRemoteSessionActivationMode] boolValue];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:archiveFaceDetectionMode])
            self.isFaceDetectionModeOn = [[[NSUserDefaults standardUserDefaults] objectForKey:archiveFaceDetectionMode] boolValue];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:archiveRedialMode])
            self.isRedialModeOn = [[[NSUserDefaults standardUserDefaults] objectForKey:archiveRedialMode] boolValue];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:archiveStdLogger])
            self.enabledStdLogger = [[[NSUserDefaults standardUserDefaults] objectForKey:archiveStdLogger] boolValue];
        
        self.appModulesLoggerLevel =[[[NSUserDefaults standardUserDefaults] objectForKey:archiveModulesLogLevels] mutableCopy];
        if (!self.appModulesLoggerLevel)
            self.appModulesLoggerLevel = [[NSMutableDictionary alloc] init];
        
        self.telnetLoggerSettings =[[[NSUserDefaults standardUserDefaults] objectForKey:archiveTelnetLogger] mutableCopy];
        if (!self.telnetLoggerSettings)
        {
            self.telnetLoggerSettings = [[NSMutableDictionary alloc] init];
            [self.telnetLoggerSettings setObject:defaultTelnetPort forKey:@"server"];
            [self.telnetLoggerSettings setObject:[NSNumber numberWithBool:YES] forKey:@"colorized"];
        }
        
        self.outgoingTelnetLoggerSettings =[[[NSUserDefaults standardUserDefaults] objectForKey:archiveOutgoingTelnetLogger] mutableCopy];
        if (!self.outgoingTelnetLoggerSettings)
        {
            self.outgoingTelnetLoggerSettings = [[NSMutableDictionary alloc] init];
            [self.outgoingTelnetLoggerSettings setObject:defaultOutgoingTelnetServer forKey:@"server"];
            [self.outgoingTelnetLoggerSettings setObject:[NSNumber numberWithBool:YES] forKey:@"colorized"];
        }
    }
    return self;
}

- (void) enableRemoteSessionActivationMode:(BOOL) enable
{
    self.isRemoteSessionActivationModeOn = enable;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.isRemoteSessionActivationModeOn] forKey:archiveRemoteSessionActivationMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) enableFaceDetectionMode:(BOOL) enable
{
    self.isFaceDetectionModeOn = enable;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.isFaceDetectionModeOn] forKey:archiveFaceDetectionMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) enableRedialMode:(BOOL) enable
{
    self.isRedialModeOn = enable;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.isRedialModeOn] forKey:archiveRedialMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) enable:(BOOL) enable logger:(LoggerTypes) type
{
    switch (type)
    {
        case LOGGER_STD_OUT:
            self.enabledStdLogger = enable;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.enabledStdLogger] forKey:archiveStdLogger];
            break;
            
        case LOGGER_TELNET:
            [self.telnetLoggerSettings setObject:[NSNumber numberWithBool:enable] forKey:@"enabled"];
            [[NSUserDefaults standardUserDefaults] setObject:self.telnetLoggerSettings forKey:archiveTelnetLogger];
            break;
            
        case LOGGER_OUTGOING_TELNET:
            [self.outgoingTelnetLoggerSettings setObject:[NSNumber numberWithBool:enable] forKey:@"enabled"];
            [[NSUserDefaults standardUserDefaults] setObject:self.outgoingTelnetLoggerSettings forKey:archiveOutgoingTelnetLogger];
            break;
            
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[Logger start:enable logger:type];
}

- (BOOL) isLoggerEnabled:(LoggerTypes) type
{
    switch (type)
    {
        case LOGGER_STD_OUT:
            return self.enabledStdLogger;
            break;
            
        case LOGGER_TELNET:
            return [self.telnetLoggerSettings objectForKey:@"enabled"];
            break;
            
        case LOGGER_OUTGOING_TELNET:
            return [self.outgoingTelnetLoggerSettings objectForKey:@"enabled"];
            break;
            
        default:
            break;
    }
    return NO;
}

- (void) setServerOrPort:(NSString*) server logger:(LoggerTypes) type
{
    switch (type)
    {
        case LOGGER_TELNET:
            [self.telnetLoggerSettings setObject:server forKey:@"server"];
            [[NSUserDefaults standardUserDefaults] setObject:self.telnetLoggerSettings forKey:archiveTelnetLogger];
            break;
            
        case LOGGER_OUTGOING_TELNET:
            [self.outgoingTelnetLoggerSettings setObject:server forKey:@"server"];
            [[NSUserDefaults standardUserDefaults] setObject:self.outgoingTelnetLoggerSettings forKey:archiveOutgoingTelnetLogger];
            
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) getServerPortForLogger:(LoggerTypes) type
{
    switch (type)
    {
        case LOGGER_TELNET:
            return [self.telnetLoggerSettings objectForKey:@"server"];
            break;
            
        case LOGGER_OUTGOING_TELNET:
            return [self.outgoingTelnetLoggerSettings objectForKey:@"server"];
            break;
            
        default:
            break;
    }
    return nil;
}

- (void) setColorizedOutput:(BOOL) colorized logger:(LoggerTypes) type
{
    switch (type)
    {
        case LOGGER_TELNET:
            [self.telnetLoggerSettings setObject:[NSNumber numberWithBool:colorized] forKey:@"colorized"];
            [[NSUserDefaults standardUserDefaults] setObject:self.telnetLoggerSettings forKey:archiveTelnetLogger];
            break;
            
        case LOGGER_OUTGOING_TELNET:
            [self.outgoingTelnetLoggerSettings setObject:[NSNumber numberWithBool:colorized] forKey:@"colorized"];
            [[NSUserDefaults standardUserDefaults] setObject:self.outgoingTelnetLoggerSettings forKey:archiveOutgoingTelnetLogger];
            break;
            
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) isColorizedOutputForLogger:(LoggerTypes) type
{
    BOOL ret = NO;
    switch (type)
    {
        case LOGGER_TELNET:
            ret = [self.telnetLoggerSettings objectForKey:@"colorized"];
            break;
            
        case LOGGER_OUTGOING_TELNET:
            ret = [self.outgoingTelnetLoggerSettings objectForKey:@"colorized"];
            break;
            
        default:
            break;
    }
    return ret;
}

- (HOPLoggerLevels) getLoggerLevelForAppModule:(Modules) module
{
    HOPLoggerLevels ret = HOPLoggerLevelNone;
    
    NSString* archiveString = [self getArchiveStringForModule:module];
    if ([archiveString length] > 0)
        ret = [self getLoggerLevelForAppModuleKey:archiveString];
    
    return ret;
}

- (HOPLoggerLevels) getLoggerLevelForAppModuleKey:(NSString*) moduleKey
{
    HOPLoggerLevels ret = HOPLoggerLevelNone;
    
    NSNumber* retNumber = [self.appModulesLoggerLevel objectForKey:moduleKey];
    if (retNumber)
        ret = (HOPLoggerLevels)[retNumber intValue];
    
    return ret;
}

- (void) setLoggerLevel:(HOPLoggerLevels) level forAppModule:(Modules) module
{
    NSString* archiveString = [self getArchiveStringForModule:module];
    [self.appModulesLoggerLevel setObject:[NSNumber numberWithInt:level] forKey:archiveString];
    [self saveModuleLogLevels];
}

- (void) saveModuleLogLevels
{
    [[NSUserDefaults standardUserDefaults] setObject:self.appModulesLoggerLevel forKey:archiveModulesLogLevels];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) getStringForModule:(Modules) module
{
    NSString* ret = nil;
    
    switch (module)
    {
        case MODULE_APPLICATION:
            ret = @"Application";
            break;
            
        case MODEULE_SDK:
            ret = @"SDK (iOS)";
            break;

        case MODULE_MEDIA:
            ret = @"SDK (media)";
            break;

        case MODULE_WEBRTC:
            ret = @"SDK (webRTC)";
            break;

        case MODULE_CORE:
            ret = @"SDK (core)";
            break;

        case MODULE_STACK_MESSAGE:
            ret = @"SDK (messages)";
            break;

        case MODULE_STACK:
            ret = @"SDK (stack)";
            break;

        case MODULE_SERVICES:
            ret = @"SDK (services)";
            break;

        case MODULE_SERVICES_ICE:
            ret = @"SDK (ICE)";
            break;

        case MODULE_SERVICES_RUDP:
            ret = @"SDK (RUDP)";
            break;

        case MODULE_SERVICES_HTTP:
            ret = @"SDK (HTTP)";
            break;

        case MODULE_ZSLIB:
            ret = @"SDK (zsLib)";
            break;
            
            default:
            break;
    }
    
    return ret;
}

- (NSString*) getArchiveStringForModule:(Modules) module
{
    NSString* ret = nil;
    
    switch (module)
    {
        case MODULE_APPLICATION:
            ret = moduleApplication;
            break;
            
        case MODEULE_SDK:
            ret = moduleSDK;
            break;
            
        case MODULE_MEDIA:
            ret = moduleMedia;
            break;
            
        case MODULE_WEBRTC:
            ret = moduleWebRTC;
            break;
            
        case MODULE_CORE:
            ret = moduleCore;
            break;
            
        case MODULE_STACK_MESSAGE:
            ret = moduleStackMessage;
            break;
            
        case MODULE_STACK:
            ret = moduleStack;
            break;
            
        case MODULE_SERVICES:
            ret = moduleServices;
            break;
            
        case MODULE_SERVICES_ICE:
            ret = moduleServicesIce;
            break;

        case MODULE_SERVICES_RUDP:
          ret = moduleServicesRudp;
          break;

        case MODULE_SERVICES_HTTP:
            ret = moduleServicesHttp;
            break;
            
        case MODULE_ZSLIB:
            ret = moduleZsLib;
            break;
            
            default:
            break;
    }
    return ret;
}

- (NSString*) getStringForLogLevel:(HOPLoggerLevels) level
{
    switch (level)
    {
        case HOPLoggerLevelNone:
            return @"NONE";
            break;
            
        case HOPLoggerLevelBasic:
            return @"BASIC";
            break;
            
        case HOPLoggerLevelDetail:
            return @"DETAIL";
            break;
            
        case HOPLoggerLevelDebug:
            return @"DEBUG";
            break;
            
        case HOPLoggerLevelTrace:
            return @"TRACE";
            break;

        case HOPLoggerLevelInsane:
            return @"INSANE";
            break;

        default:
            break;
    }
    return nil;
}

- (void) saveDefaultsLoggerSettings
{
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_APPLICATION];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_SERVICES];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_SERVICES_ICE];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_SERVICES_RUDP];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_SERVICES_HTTP];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_CORE];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_STACK_MESSAGE];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_STACK];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODULE_ZSLIB];
    [self setLoggerLevel:HOPLoggerLevelTrace forAppModule:MODEULE_SDK];
    [self setLoggerLevel:HOPLoggerLevelDetail forAppModule:MODULE_WEBRTC];
    [self setLoggerLevel:HOPLoggerLevelDetail forAppModule:MODULE_MEDIA];
    
    [self setColorizedOutput:YES logger:LOGGER_STD_OUT];
    [self setColorizedOutput:YES logger:LOGGER_TELNET];
    [self setColorizedOutput:YES logger:LOGGER_OUTGOING_TELNET];
    
    [self enable:YES logger:LOGGER_STD_OUT];
    [self enable:YES logger:LOGGER_TELNET];
    [self enable:YES logger:LOGGER_OUTGOING_TELNET];
}

@end
