//
//  Settings.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/1/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenPeerSDK/HOPTypes.h>

typedef enum
{
    LOGGER_STD_OUT,
    LOGGER_TELNET,
    LOGGER_OUTGOING_TELNET
}LoggerTypes;

typedef enum
{
    TELNET_ENABLE,
    TELNET_SERVER_OR_PORT,
    TELNET_COLOR,
    
    TOTAL_TELNET_OPTIONS
}TelnetLoggerOptions;

typedef enum
{
    MODULE_APPLICATION,
    MODEULE_SDK,
    MODULE_MEDIA,
    MODULE_WEBRTC,
    MODULE_CORE,
    MODULE_STACK_MESSAGE,
    MODULE_STACK,
    MODULE_SERVICES,
    MODULE_SERVICES_HTTP,
    MODULE_ZSLIB,
    
    TOTAL_MODULES
}Modules;





@interface Settings : NSObject

@property (nonatomic) BOOL isRemoteSessionActivationModeOn;
@property (nonatomic) BOOL isFaceDetectionModeOn;
@property (nonatomic) BOOL isRedialModeOn;

@property (nonatomic) BOOL enabledStdLogger;

@property (strong, nonatomic) NSMutableDictionary* appModulesLoggerLevel;
@property (strong, nonatomic) NSMutableDictionary* telnetLoggerSettings;
@property (strong, nonatomic) NSMutableDictionary* outgoingTelnetLoggerSettings;



+ (id) sharedSettings;
- (id) init __attribute__((unavailable("HOPAccount is singleton class.")));

- (void) enableRemoteSessionActivationMode:(BOOL) enable;
- (void) enableFaceDetectionMode:(BOOL) enable;
- (void) enableRedialMode:(BOOL) enable;

- (void) enable:(BOOL) enable looger:(LoggerTypes) type;
- (BOOL) isLoggerEnabled:(LoggerTypes) type;

- (void) setServerOrPort:(NSString*) server logger:(LoggerTypes) type;
- (NSString*) getServerPortForLogger:(LoggerTypes) type;

- (void) setColorizedOutput:(BOOL) colorized logger:(LoggerTypes) type;
- (BOOL) isColorizedOutputForLogger:(LoggerTypes) type;

- (HOPLoggerLevels) getLoggerLevelForAppModule:(Modules) module;
- (HOPLoggerLevels) getLoggerLevelForAppModuleKey:(NSString*) moduleKey;
- (void) setLoggerLevel:(HOPLoggerLevels) level forAppModule:(Modules) module;

- (NSString*) getStringForModule:(Modules) module;
- (NSString*) getStringForLogLevel:(HOPLoggerLevels) level;
@end
