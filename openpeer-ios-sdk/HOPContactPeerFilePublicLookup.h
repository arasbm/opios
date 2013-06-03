
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


#import <Foundation/Foundation.h>
#import "HOPProtocols.h"

@interface HOPContactPeerFilePublicLookupResult : NSObject
@property (nonatomic, assign) BOOL wasSuccessful;
@property (nonatomic, assign) unsigned short errorCode;
@property (nonatomic, strong) NSString* errorReason;
@end

@interface HOPContactPeerFilePublicLookup : NSObject

/**
 Initializer for HOPContactPeerFilePublicLookup with passed HOPContactPeerFilePublicLookupDelegate delegate and list of contact
 @param inDelegate HOPContactPeerFilePublicLookupDelegate delegate
 @param inContactList NSString list of contacts
 @returns HOPContactPeerFilePublicLookup object
 */
- (id) initWithDelegate:(id<HOPContactPeerFilePublicLookupDelegate>) inDelegate contactsList:(NSArray*) inContactList ;

/**
 Retrieves whether peer file lookup is completed or not.
 @returns BOOL YES if completed, otherwise NO
 */
- (BOOL) isComplete;

/**
 Retrieves peer file lookup result.
 @returns HOPContactPeerFilePublicLookupResult Lookup result
 */
- (HOPContactPeerFilePublicLookupResult*) getLookupResult;

/**
 Cancels peer file lookup.
 */
- (void) cancel;

/**
 Retrieves whether peer file lookup is completed or not.
 @returns BOOL YES if completed, otherwise NO
 */
- (NSArray*) getContacts;


@end
