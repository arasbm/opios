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

#import "AppDelegate.h"
#import "OpenPeer.h"
#import "MainViewController.h"
#import "LoginManager.h"

#ifdef APNS_ENABLED
#import "APNSManager.h"
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Create root view controller. This view controller will manage displaying all other view controllers.
    MainViewController* mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:mainViewController];
    
    [self.window makeKeyAndVisible];

    [[OpenPeer sharedOpenPeer] setMainViewController:mainViewController];
    [[OpenPeer sharedOpenPeer] setup];
    
#ifdef APNS_ENABLED
    [[APNSManager sharedAPNSManager] prepareUrbanAirShip];
    NSDictionary *apnsInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
    if ([apnsInfo count] > 0)
    {
        
    }
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[OpenPeer sharedOpenPeer] setAppEnteredBackground:YES];
    [[OpenPeer sharedOpenPeer] setAppEnteredForeground:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ( [[OpenPeer sharedOpenPeer] appEnteredBackground])
    {
        [[OpenPeer sharedOpenPeer] setAppEnteredForeground:YES];
        [[OpenPeer sharedOpenPeer] setAppEnteredBackground:NO];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#ifdef APNS_ENABLED
//    NSString *tokenStr = [[deviceToken description] substringWithRange:NSMakeRange(1, 71)];
//    
//    NSString *result=[tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString* hexString = [AppDelegate hexadecimalStringForData:deviceToken];
//    NSData* data = [AppDelegate dataFromHexString:hexString];
//    NSString *tokenStr2 = [[data description] substringWithRange:NSMakeRange(1, 71)];
    
    NSLog(@"deviceToken result:%@",hexString);

    [[APNSManager sharedAPNSManager] registerDeviceToken:deviceToken];
    [[APNSManager sharedAPNSManager] setDeviceToken:hexString];
    [[OpenPeer sharedOpenPeer] setDeviceToken:hexString];
     
    /*NSString* deveiceTokenToREceive = @"34a4615a a2a9d182 011382a8 8f16be64 a065d601 0f89b74f 468021d6 02735a81";
    if (![deveiceTokenToREceive isEqualToString:hexString])
    {
        [[APNSManager sharedAPNSManager] sendPushNotificationForDeviceToken:deveiceTokenToREceive message:@"Wellcome bro."];
    }*/
#endif
    
    
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    int length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
        
    }
    
    return data;
}

+ (NSString *)hexadecimalStringForData:(NSData *)data
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received push notification with userInfo:%@", userInfo);
}
- (void)handleNotification:(NSDictionary *)notification applicationState:(UIApplicationState)state
{
    NSLog(@"Received push notification with notification:%@", notification);
}
@end
