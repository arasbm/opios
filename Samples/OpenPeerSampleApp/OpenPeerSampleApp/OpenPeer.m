/*
 
 Copyright (c) 2012, SMB Phone Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies,
 either expressed or implied, of the FreeBSD Project.
 
 */

#import "OpenPeer.h"
#import "OpenPeerUser.h"
#import "Utility.h"
#import "Constants.h"

//SDK
#import "OpenpeerSDK/HOPStack.h"
#import "OpenpeerSDK/HOPLogger.h"
//Managers
#import "LoginManager.h"
//Delegates
#import "StackDelegate.h"
#import "MediaEngineDelegate.h"
#import "ConversationThreadDelegate.h"
#import "CallDelegate.h"
#import "AccountDelegate.h"
#import "IdentityDelegate.h"
#import "IdentityLookupDelegate.h"

//View controllers
#import "MainViewController.h"



//Private methods
@interface OpenPeer ()

@property (nonatomic) BOOL forcedTelnetLogger;
- (void) createDelegates;
- (void) setLogLevels;
@end


@implementation OpenPeer

/**
 Retrieves singleton object of the Open Peer.
 @return Singleton object of the Open Peer.
 */
+ (id) sharedOpenPeer
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

/**
 Prepare authorized app ID and associate main view controller.
 @param inMainViewController MainViewController Input main view controller.
 */
- (void) prepareWithMainViewController:(MainViewController *)inMainViewController
{
    self.mainViewController = inMainViewController;
    
    NSDate* expiry = [[NSDate date] dateByAddingTimeInterval:(30 * 24 * 60 * 60)];
    
    self.authorizedApplicationId = [HOPStack createAuthorizedApplicationID:applicationId applicationIDSharedSecret:applicationIdSharedSecret expires:expiry];
}

/**
 Initializes the open peer stack. After initialization succeeds, login screen is displayed, or user relogin started.
 @param inMainViewController MainViewController Input main view controller.
 */
- (void) setup
{
  //Set log levels and start logging
  [self startAllSelectedLoggers];

  //Created all delegates required for openpeer stack initialization.
  [self createDelegates];

  //Init openpeer stack and set created delegates
  [[HOPStack sharedStack] setupWithStackDelegate:self.stackDelegate mediaEngineDelegate:self.mediaEngineDelegate appID: self.authorizedApplicationId appName:applicationName appImageURL:applicationImageURL appURL:applicationURL userAgent:[Utility getUserAgentName] deviceID:[[OpenPeerUser sharedOpenPeerUser] deviceId] deviceOs:[Utility getDeviceOs] system:[Utility getPlatform]];

  //Start with login procedure and display login view
  [[LoginManager sharedLoginManager] login];
}

/**
 Method used for all delegates creation. Delegates will catch events from the Open Peer SDK and handle them properly.
 */
- (void) createDelegates
{
    self.stackDelegate = [[StackDelegate alloc] init];
    self.mediaEngineDelegate = [[MediaEngineDelegate alloc] init];
    self.conversationThreadDelegate = [[ConversationThreadDelegate alloc] init];
    self.callDelegate = [[CallDelegate alloc] init];
    self.accountDelegate = [[AccountDelegate alloc] init];
    self.identityDelegate = [[IdentityDelegate alloc] init];
    self.identityLookupDelegate = [[IdentityLookupDelegate alloc] init];
}

- (void) setLogLevels
{
    //For each system you can choose log level from HOPClientLogLevelNone (turned off) to HOPClientLogLevelTrace (most detail).
    //[HOPLogger setLogLevel:HOPLoggerLevelTrace];
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

- (void) setLogLevel:(HOPLoggerLevels) level
{
    [HOPLogger setLogLevel:level];
    [HOPLogger setLogLevelbyName:moduleApplication level:level];
    [HOPLogger setLogLevelbyName:moduleServices level:level];
    [HOPLogger setLogLevelbyName:moduleServicesHttp level:level];
    [HOPLogger setLogLevelbyName:moduleCore level:level];
    [HOPLogger setLogLevelbyName:moduleStackMessage level:level];
    [HOPLogger setLogLevelbyName:moduleStack level:level];
    [HOPLogger setLogLevelbyName:moduleWebRTC level:level];
    [HOPLogger setLogLevelbyName:moduleZsLib level:level];
    [HOPLogger setLogLevelbyName:moduleSDK level:level];
    [HOPLogger setLogLevelbyName:moduleMedia level:level];
}

- (void) startStdLogger:(BOOL) start
{
    if (start)
    {
        [self setLogLevels];
        [HOPLogger installStdOutLogger:NO];
    }
    else
        [HOPLogger uninstallStdOutLogger];
}

/**
 Sets log levels and starts the logger.
 */
- (void) startTelnetLogger:(BOOL) start
{
    if (!self.forcedTelnetLogger)
    {
        if (start)
        {
            [self setLogLevels];
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
}

- (void) startOutgoingTelnetLogger:(BOOL) start
{
    if (start)
    {
        [self setLogLevels];
        NSString* server =[[Settings sharedSettings] getServerPortForLogger:LOGGER_OUTGOING_TELNET];
        BOOL colorized = [[Settings sharedSettings] isColorizedOutputForLogger:LOGGER_OUTGOING_TELNET];
        if ([server length] > 0)
            [HOPLogger installOutgoingTelnetLogger:server colorizeOutput:colorized stringToSendUponConnection:self.authorizedApplicationId];
    }
    else
    {
        [HOPLogger uninstallOutgoingTelnetLogger];
    }
}

- (void) startAllSelectedLoggers
{
    [self startStdLogger:[[Settings sharedSettings] isLoggerEnabled:LOGGER_STD_OUT]];
    [self startTelnetLogger:[[Settings sharedSettings] isLoggerEnabled:LOGGER_TELNET]];
    [self startOutgoingTelnetLogger:[[Settings sharedSettings] isLoggerEnabled:LOGGER_OUTGOING_TELNET]];
}


- (void) start:(BOOL) start looger:(LoggerTypes) type
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

- (void) startTelnetLoggerOnStartUp
{
    self.forcedTelnetLogger = YES;
    [HOPLogger setLogLevelbyName:moduleApplication level:HOPLoggerLevelTrace];
    [HOPLogger setLogLevelbyName:moduleServices level:HOPLoggerLevelTrace];
    [HOPLogger setLogLevelbyName:moduleServicesHttp level:HOPLoggerLevelTrace];
    [HOPLogger setLogLevelbyName:moduleCore level:HOPLoggerLevelTrace];
    [HOPLogger setLogLevelbyName:moduleStackMessage level:HOPLoggerLevelTrace];
    [HOPLogger setLogLevelbyName:moduleStack level:HOPLoggerLevelTrace];
    [HOPLogger setLogLevelbyName:moduleWebRTC level:HOPLoggerLevelBasic];
    [HOPLogger setLogLevelbyName:moduleZsLib level:HOPLoggerLevelTrace];
    [HOPLogger setLogLevelbyName:moduleSDK level:HOPLoggerLevelTrace];
    [HOPLogger setLogLevelbyName:moduleMedia level:HOPLoggerLevelBasic];
    
    [HOPLogger installTelnetLogger:[defaultTelnetPort intValue] maxSecondsWaitForSocketToBeAvailable:60 colorizeOutput:YES];
    [HOPLogger installOutgoingTelnetLogger:defaultOutgoingTelnetServer  colorizeOutput:YES stringToSendUponConnection:self.authorizedApplicationId];
}
@end
