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

#import "AppConsts.h"

#error PLEASE SET APPLICATION ID VALUE (THEN REMOVE THIS LINE)
NSString* const applicationId = @"<-- insert application ID here (e.g. com.domain.appName) -->";

NSString* const applicationName = @"OpenPeerSampleApp";
NSString* const applicationImageURL = @"http://hookflash.com/wp-content/themes/CleanSpace/images/logo.png";
NSString* const applicationURL = @"www.openpeer.org";

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

NSString* const outerFrameURL = @"https://app-javascript.hookflash.me/outer.html?view=choose";
NSString* const identityProviderDomain = @"idprovider-javascript.hookflash.me";
NSString* const identityFederateBaseURI = @"identity://idprovider-javascript.hookflash.me/";
NSString* const identityFacebookBaseURI = @"identity://facebook.com/";
NSString* const identityLinkedInBaseURI = @"identity://linkedin.com/";
NSString* const grantOuterFrameURLUponReload = @"grantFinished";
//NSString* const grantServiceDomain = @"hcs-javascript.hookflash.me";
NSString* const lockBoxServiceDomain =  @"hcs-javascript.hookflash.me";

NSString* const namespaceGrantServiceURL = @"https://app-javascript.hookflash.me/outernamespacegrant.html";

NSString * const keyOpenPeerUser = @"keyOpenPeerUser";

//User defaults keys

NSString * const archiveDeviceId = @"archiveDeviceId";
NSString * const archiveStableUniqueId = @"archiveStableUniqueId";
NSString * const archiveIdentityURI = @"archiveIdentityURI";
NSString * const archivePeerURI = @"archivePeerURI";
NSString * const archiveFullname = @"archiveFullname";
NSString * const archiveContactId = @"archiveContactId";
NSString * const archiveAccountSalt = @"archiveAccountSalt";
NSString * const archivePasswordNonce = @"archivePasswordNonce";
NSString * const archivePrivatePeerFile = @"archivePrivatePeerFile";
NSString * const archivePrivatePeerFileSecret = @"archivePrivatePeerFileSecret";
NSString * const archivePeerFilePassword = @"archivePeerFilePassword";
NSString * const archiveAssociatedIdentities = @"archiveAssociatedIdentities";
NSString * const archiveLastProfileUpdateTimestamp = @"archiveLastProfileUpdateTimestamp";
NSString * const archiveReloginInfo = @"archiveReloginInfo";

//Contact Profile xml tags
NSString* const profileXmlTagProfile = @"profile";
NSString* const profileXmlTagName = @"name";
NSString* const profileXmlTagIdentities = @"identities";
NSString* const profileXmlTagIdentityBundle = @"identityBundle";
NSString* const profileXmlTagIdentity = @"identity";
NSString* const profileXmlTagSignature = @"signature";
NSString* const profileXmlTagAvatar = @"avatar";
NSString* const profileXmlTagContactID = @"contactID";
NSString* const profileXmlTagPublicPeerFile = @"publicPeerFile";
NSString* const profileXmlTagSocialId = @"socialId";
NSString* const profileXmlAttributeId = @"id";
NSString* const profileXmlTagUserID = @"userID";

//Message types
NSString* const messageTypeText = @"text/x-application-hookflash-message-text";
NSString* const messageTypeSystem = @"text/x-application-hookflash-message-system";

NSString * const TagEvent           = @"event";
NSString * const TagId              = @"id";
NSString * const TagText            = @"text";

NSString * const systemMessageRequest = @"?";

NSString * const notificationRemoteSessionModeChanged = @"notificationRemoteSessionModeChanged";

NSString * const defaultTelnetPort = @"59999";
NSString * const defaultOutgoingTelnetServer = @"tcp.logger.hookflash.me:8055";

NSString * const archiveMediaAEC = @"archiveMediaAEC";
NSString * const archiveMediaAGC = @"archiveMediaAGC";
NSString * const archiveMediaNS = @"archiveMediaNS";

NSString * const archiveRemoteSessionActivationMode = @"archiveRemoteSessionActivationMode";
NSString * const archiveFaceDetectionMode = @"archiveFaceDetectionMode";
NSString * const archiveRedialMode = @"archiveRedialMode";

NSString * const archiveStdLogger = @"archiveStdLogger";
NSString * const archiveTelnetLogger = @"archiveTelnetLogger";
NSString * const archiveOutgoingTelnetLogger = @"archiveOutgoingTelnetLogger";
NSString * const archiveModulesLogLevels = @"archiveModulesLogLevels";

NSString * const moduleApplication = @"openpeer_application";
NSString * const moduleSDK = @"openpeer_sdk";
NSString * const moduleMedia = @"openpeer_media";
NSString * const moduleWebRTC = @"openpeer_webrtc";
NSString * const moduleCore = @"openpeer_core";
NSString * const moduleStackMessage = @"openpeer_stack_message";
NSString * const moduleStack = @"openpeer_stack";
NSString * const moduleServices = @"openpeer_services";
NSString * const moduleServicesIce = @"openpeer_services_ice";
NSString * const moduleServicesRudp = @"openpeer_services_rudp";
NSString * const moduleServicesHttp = @"openpeer_services_http";
NSString * const moduleServicesMls = @"openpeer_services_mls";
NSString * const moduleZsLib = @"zsLib";
NSString * const moduleJavaScript = @"openpeer_javascript";

