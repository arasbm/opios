/*
 
 Copyright (c) 2013, SMB Phone Inc.
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

#import "APNSManager.h"
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"

#import <OpenPeerSDK/HOPRolodexContact.h>

@interface APNSManager ()

@property (nonatomic, strong) NSString* developmentAppKey;
@property (nonatomic, strong) NSString* masterAppSecret;
@property (nonatomic, strong) NSString* apiPushURL;

- (id) initSingleton;

@end

@implementation APNSManager

+ (id) sharedAPNSManager
{
    static dispatch_once_t pred = 0;
    __strong static id sharedInstance = nil;
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] initSingleton];
    });
    
    return sharedInstance;
}

- (id) initSingleton
{
    self = [super init];
    if (self)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AirshipConfig" ofType:@"plist"];
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        self.developmentAppKey = [plistData objectForKey:@"developmentAppKey"];
        self.masterAppSecret = [plistData objectForKey:@"masterAppSecret"];
        self.apiPushURL = [plistData objectForKey:@"apiPushURL"];
    }
    return self;
}
- (void) prepareUrbanAirShip
{
    UAConfig *config = [UAConfig defaultConfig];
    [UAirship takeOff:config];
    
    // Print out the application configuration for debugging (optional)
    UA_LDEBUG(@"Config:\n%@", [config description]);
    
    // Set the icon badge to zero on startup (optional)
    [[UAPush shared] resetBadge];
}

- (void) sendPushNotificationForDeviceToken:(NSString*) deviceToken message:(NSString*) message
{
    if ([self.apiPushURL length] > 0)
    {
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.apiPushURL]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSDictionary * push = @{@"device_tokens":@[deviceToken], @"aps":@{@"alert":message, @"sound":@"calling"}};
        NSData * pushdata = [NSJSONSerialization dataWithJSONObject:push options:0 error:NULL];
        [request setHTTPBody:pushdata];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

- (void) registerDeviceToken:(NSData*) devToken
{
    [[UAPush shared] registerDeviceToken:devToken];
}

- (void) handleRemoteNotification:(NSDictionary*) launchOptions application:(UIApplication *)application
{
    [[UAPush shared] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                       applicationState:application.applicationState];
}
- (void) connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *) challenge
{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
    {
        if ([self.developmentAppKey length] > 0 || [self.masterAppSecret length] > 0)
        {
            NSURLCredential * credential = [[NSURLCredential alloc] initWithUser:self.developmentAppKey password:self.masterAppSecret persistence:NSURLCredentialPersistenceForSession];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        }
    }
}

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response
{
    NSHTTPURLResponse * res = (NSHTTPURLResponse *) response;
    NSLog(@"response: %@",res);
    NSLog(@"res %i\n",res.statusCode);
}


@end
