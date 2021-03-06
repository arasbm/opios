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

#import <AVFoundation/AVAudioPlayer.h>
#import "SoundsManager.h"

@interface SoundManager ()

@property (strong, nonatomic) AVAudioPlayer *callingAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *ringingAudioPlayer;

- (id) initSingleton;
@end

@implementation SoundManager

+ (id) sharedSoundsManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initSingleton];
    });
    return _sharedObject;
}



- (id) initSingleton
{
    self = [super init];
    if (self)
    {
        NSURL *callingSound = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                      pathForResource:@"calling"
                                                      ofType:@"wav"]];
        self.callingAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:callingSound error:nil];
        self.callingAudioPlayer.numberOfLoops = -1;
        
        NSURL *ringingSound = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                      pathForResource:@"ringing"
                                                      ofType:@"caf"]];
        self.ringingAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ringingSound error:nil];
        self.ringingAudioPlayer.numberOfLoops = -1;
    }
    
    return self;
}


- (void) playCallingSound
{
    if (![self.callingAudioPlayer isPlaying])
        [self.callingAudioPlayer play];
}

- (void) stopCallingSound
{
    if (self.callingAudioPlayer != nil && [self.callingAudioPlayer isPlaying])
    {
        [self.callingAudioPlayer stop];
    }
}

- (void) playRingingSound
{
    if (![self.ringingAudioPlayer isPlaying])
        [self.ringingAudioPlayer play];
}
- (void) stopRingingSound
{
    if (self.ringingAudioPlayer != nil && [self.ringingAudioPlayer isPlaying])
    {
        [self.ringingAudioPlayer stop];
    }
}
@end
