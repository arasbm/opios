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

#import "AudioCallViewController.h"


@interface AudioCallViewController ()

@end

@implementation AudioCallViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithSession:(Session*) inSession
{
    self = [self initWithNibName:@"AudioCallViewController" bundle:nil];
    if (self) 
    {
        self.session = inSession;
        //self.mediaNavigationViewController = [[[MediaNavigationViewController alloc] initWithSession:inSession] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSpeakerOn = false;
    /*[self.mediaNavigationViewController.view setFrame:CGRectMake(self.mediaNavigationViewController.view.frame.origin.x, self.mediaNavigationViewController.view.frame.origin.y, self.mediaNavigationViewController.view.frame.size.width + 1, self.mediaNavigationViewController.view.frame.size.height)];
    // Do any additional setup after loading the view from its nib.
    
    [self.mediaNavigationViewController.buttonShowCallMenu setHidden:YES];
    [self.mediaNavigationViewController.imgRightSeparator setHidden:YES];
  
    if ([[Hookflash_Utils getDeviceModel] hasPrefix:@"iPod"])
        [speakerButton setEnabled:NO];*/
}


- (void)viewDidUnload
{
    [self setCallDurationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Call states handling
/*-(void)handleCallStateChanged
{
    if (![self.session getCall])
        return;
 
    NSMutableString *ms = [[NSMutableString alloc] initWithString:@""];
    
    switch ([self.session getCall]->getState()) 
    {
        case ICall::CallState_Preparing:
        {
            if ([self.session getCall]->getCaller()->isSelf())
            {
                [ms appendString:NSLocalizedString(@"Calling", @"")];
                //                [ms appendString:@" "];
                //                NSString* displayName = [self.session getDisplayName];
                //                if (displayName != nil)
                //                    [ms appendString:displayName];
                //                else
                //                    [ms appendString:@"Unknown caller"];
                //                
                //                lblCallDuration.text = @"00:00:00";
            }
        }
            
            break;
            
        case ICall::CallState_Ringing:
        {
            [ms appendString:NSLocalizedString(@"Calling", @"")];
        }
            break;
        case ICall::CallState_Ringback:
        {
            [ms appendString:NSLocalizedString(@"Ringing", @"")];
        }
            break;
            
        case ICall::CallState_Placed:
        {
            [ms appendString:NSLocalizedString(@"Calling", @"")];
        }
            break;
            
        case ICall::CallState_Early:
        {
            NSLog(@">>> AudioCallViewController_iPad -> callState: CallState_Early");
            //                [ms setString:@""];
            //                [ms appendString:NSLocalizedString(@"Connected", @"")];
            //                [ms appendString:@" ..."];
        }
            break;
            
        case ICall::CallState_Open:
            NSLog(@">>> AudioCallViewController_iPad -> callState: CallState_Open | CallState_Active");
            // call is started or resumed
            //            if(_isCallMuted && _isCallRecording)
            //            {
            //                imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigRecordingMutededIcon]; 
            //                [ms setString:NSLocalizedString(@"Call Muted", @"")];
            //            }
            //            else
            //            {
            //                if(_isCallMuted)
            //                {
            //                    imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigMutedIcon];
            //                    [ms setString:NSLocalizedString(@"Call Muted", @"")];
            //                }
            //                if(_isCallRecording)
            //                {
            //                    imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigInProgressRecordingIcon];
            //                    [ms setString:NSLocalizedString(@"Call Recording", @"")];
            //                }
            //                if(!_isCallRecording && !_isCallMuted)
            //                {
            //                    imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigInProgressIcon];
            //                    [ms setString:NSLocalizedString(@"Call In-Progress", @"")];
            //                }
            //            }
            
            //[self setSessionParticipantCount];
            
            //[ms appendString:NSLocalizedString(@"Duration: 00:00:00", @"")];
            
            if(_sessionDuration == 0)
            {
                 [ms appendString:NSLocalizedString(@"Duration: 00:00:00", @"")];
             // call is just started
            }
             
             if (!_tmrSessionDuration)
             _tmrSessionDuration = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCallDuration) userInfo:nil repeats:YES];
            break;
            
        case ICall::CallState_Hold:
            [ms setString:NSLocalizedString(@"Call Paused", @"")];
            // call is on hold
            //            NSLog(@">>> AudioCallViewController_iPad -> callState: CallState_Hold");
            //            if(_isCallRecording)
            //                imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigRecordingPausedIcon];
            //            else
            //                imgCallStatusBig.image = [Hookflash_ThemeManager imageNamed:ki_AudioCallBigPausedIcon];
            //            [ms setString:NSLocalizedString(@"Call Paused", @"")];
            //            [btnPause setImage:[Hookflash_ThemeManager imageNamed:ki_AudioCallUnpausedIcon] forState:UIControlStateNormal];
            
            break;
        case ICall::CallState_Closed:
            NSLog(@">>> AudioCallViewController_iPad -> callState: CallState_Closed");
            //if (!callEnded)
            //    [self callHangup:nil];
            break;
            
            
            
        default:
            break;
    }
    
    self.mediaNavigationViewController.labelCallState.text = ms;
    
    // set objects visiblity 
    //[self setVisibilityForCallState];
    [ms release];
}*/


//- (void) updateCallDuration
//{
//    _sessionDuration++;
//    NSInteger secs =    _sessionDuration % 60;
//    NSInteger mins = (_sessionDuration / 60) % 60;
//    NSInteger hrs = (_sessionDuration / 3600);
//    
//    self.mediaNavigationViewController.labelCallState.text = [NSString stringWithFormat:@"Duration: %02i:%02i:%02i", hrs, mins, secs];
//}

/*
- (IBAction)actionSwitchToSpeaker:(id)sender
{
    if(isSpeakerOn)
    {
        [MediaEngineController switchAudioOutput:false];
        [speakerButton setImage:[Hookflash_ThemeManager imageNamed:ki_iPhone_speaker_active] forState:UIControlStateNormal];

    }
    else
    {
        [MediaEngineController switchAudioOutput:true];
        [speakerButton setImage:[Hookflash_ThemeManager imageNamed:ki_iPhone_speaker_pressed] forState:UIControlStateNormal];
    }
    isSpeakerOn = !isSpeakerOn;
}

- (IBAction)muteCall:(id)sender
{
    [super muteCall:sender];
    if([MediaEngineController isCallMuted])
    {
        [muteButton setImage:[Hookflash_ThemeManager imageNamed:ki_iPhone_mic_pressed] forState:UIControlStateNormal];
    }
    else
    {
        [muteButton setImage:[Hookflash_ThemeManager imageNamed:ki_iPhone_mic_active] forState:UIControlStateNormal];
    }
}

#pragma mark - Audio route change handling
@property (weak,nonatomic) Session *session;
{
    if (isSpeakerOn && (route == AUDIO_ROUTE_HEADPHONE || route == AUDIO_ROUTE_BUILT_IN_RECEIVER))
    {
        [speakerButton setImage:[Hookflash_ThemeManager imageNamed:ki_iPhone_speaker_pressed] forState:UIControlStateNormal];
        isSpeakerOn = false;
    }
}
*/
@end
