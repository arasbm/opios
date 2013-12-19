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

#import "CustomerSpecific.h"

#error PLEASE SET APPLICATION ID VALUE (THEN REMOVE THIS LINE)
NSString* const applicationId = @"<-- insert application ID here (e.g. com.domain.appName) -->";

//!!!!!!!!!!!!!!!!!!!! WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//This value should be obtained from service provider.
#error PLEASE SET SHARED SECRET VALUE (THEN REMOVE THIS LINE)
NSString* const applicationIdSharedSecret = @"<-- insert shared secret here -->";
// ------------------- !!! WARNING !!! -------------------
// Setting the application shared secret in the client is not recommended.
// Instead, the recommended solution is for your client download an authorized
// application ID from your own server using whatever method you determine is
// most appropriate.
// ------------------- !!! WARNING !!! -------------------

#error PLEASE SET APPLICATION NAME (THEN REMOVE THIS LINE)
NSString* const applicationName = @"<-- enter application name here (e.g. OpenPeerSampleApp) -->";

#error PLEASE SET APPLICATION IMAGE URL (THEN REMOVE THIS LINE)
NSString* const applicationImageURL = @"<-- enter application image url (e.g. http://hookflash.com/wp-content/themes/CleanSpace/images/logo.png) -->";

#error PLEASE SET APPLICATION URL (THEN REMOVE THIS LINE)
NSString* const applicationURL = @"<-- enter application url (e.g. www.openpeer.org) -->";

#error PLEASE SET OUTER FRAME URL (THEN REMOVE THIS LINE)
NSString* const outerFrameURL = @"<-- enter outer frame url here (e.g. https://app-javascript.hookflash.me/outer.html?view=choose) -->";

#error PLEASE SET OUTER NAMESPACE GRANT URL (THEN REMOVE THIS LINE)
NSString* const namespaceGrantServiceURL = @"<-- enter outer namespace grant service url here (e.g. https://app-javascript.hookflash.me/outernamespacegrant.html) -->";

#error PLEASE SET IDENTITY PROVIDER DOMAIN (THEN REMOVE THIS LINE)
NSString* const identityProviderDomain = @"<-- enter identity provider domain here (e.g. idprovider-javascript.hookflash.me) -->";

#error PLEASE SET FEDERATED IDENTITY BASE (THEN REMOVE THIS LINE)
NSString* const identityFederateBaseURI = @"<-- enter federated identity base uri here (e.g. identity://idprovider-javascript.hookflash.me/) -->";

#error PLEASE SET LOCKBOX SERVICE DOMAIN (THEN REMOVE THIS LINE)
NSString* const lockBoxServiceDomain =  @"<-- enter lockbox service domain here (e.g. hcs-javascript.hookflash.me) -->";

#error PLEASE SET DEFAULT OUTGOING TELENT SERVER (THEN REMOVE THIS LINE)
NSString * const defaultOutgoingTelnetServer = @"<-- enter outgoing telnet server here (e.g. tcp.logger.hookflash.me:8055) -->";

