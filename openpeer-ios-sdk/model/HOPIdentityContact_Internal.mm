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

#import "HOPModelManager.h"
#import "HOPPublicPeerFile.h"
#import "HOPIdentityContact_Internal.h"
#import "OpenPeerUtility.h"
#import <openpeer/core/IHelper.h>

@implementation HOPIdentityContact

- (void) updateWithIdentityContact:(IdentityContact) inIdentityContact
{
    NSString* sId = [NSString stringWithUTF8String:inIdentityContact.mStableID];
    NSString* identityURI = [NSString stringWithUTF8String:inIdentityContact.mIdentityURI];
    HOPIdentityContact* identityContact = [[HOPModelManager sharedModelManager] getIdentityContactByStableID:sId identityURI:identityURI];
    
    if (!identityContact)
    {
        NSManagedObject* managedObject = [[HOPModelManager sharedModelManager] createObjectForEntity:@"HOPIdentityContact"];
        if (managedObject && [managedObject isKindOfClass:[HOPIdentityContact class]])
        {
            identityContact = (HOPIdentityContact*) managedObject;
        }
        else
            return;
    }
    
    identityContact.stableID = sId;
    identityContact.expires = [OpenPeerUtility convertPosixTimeToDate:inIdentityContact.mExpires];
    identityContact.lastUpdated = [OpenPeerUtility convertPosixTimeToDate:inIdentityContact.mLastUpdated];
    identityContact.identityProofBundle = [NSString stringWithCString:core::IHelper::convertToString(inIdentityContact.mIdentityProofBundleEl) encoding:NSUTF8StringEncoding];
    identityContact.priority = [NSNumber numberWithInt:inIdentityContact.mPriority];
    identityContact.weight = [NSNumber numberWithInt:inIdentityContact.mWeight];
    
    //TODO: check also against homeuserid
    HOPRolodexContact* hopRolodexContact = [[HOPModelManager sharedModelManager] getRolodexContactByIdentityURI:[NSString stringWithCString:inIdentityContact.mIdentityURI encoding:NSUTF8StringEncoding]];
    
    identityContact.rolodexContact = hopRolodexContact;
    
    NSString* peerURI = [NSString stringWithCString: IHelper::getPeerURI(inIdentityContact.mPeerFilePublic) encoding:NSUTF8StringEncoding];
    NSString* peerFile = [NSString stringWithCString:IHelper::convertToString(IHelper::convertToElement(inIdentityContact.mPeerFilePublic)) encoding:NSUTF8StringEncoding];
    
    HOPPublicPeerFile* publicPeerFile = [[HOPModelManager sharedModelManager] getPublicPeerFileForPeerURI:peerURI];
    
    if (!publicPeerFile)
    {
        NSManagedObject* managedObject = [[HOPModelManager sharedModelManager] createObjectForEntity:@"HOPPublicPeerFile"];
        if (managedObject && [managedObject isKindOfClass:[HOPPublicPeerFile class]])
        {
            publicPeerFile = (HOPPublicPeerFile*) managedObject;
        }
        else
            return;
    }
    identityContact.peerFile = publicPeerFile;
}

@end
