Thank you for downloading Hookflash's Open Peer iOS SDK.

This release is a preliminary 0.8.0 release of the SDK and Hookflash will be publishing updates to the SDK regularly.

For a quick introduction to the code please read the following. For more detailed instructions please go to http://docs.hookflash.com.


From your terminal, please clone the "opios" git repository:
git clone --recursive https://github.com/openpeer/opios.git

This repository will yield the iOS Object-C SDK, sample application and dependency librarys like the C++ open peer core, stack, media and libraries needed to support the underlying SDK.

Directory structure:
opios/                            - contains the project files for building the Open Peer iOS SDK framework
opios/openpeer-ios-sdk/           - contains the Open Peer iOS SDK header files
opios/openpeer-ios-sdk/source/    - contains the implementation of the iOS SDK header files
opios/openpeer-ios-sdk/internal/  - contains the wrapper interface that implements the Objective-C to C++ interaction
opios/Samples/                    - contains the Open Peer iOS Samples application(s)

How to build:

1) Extract pre-built boost libraries:

pushd opios/libs/op/libs/boost/
curl -O http://assets.hookflash.me/github.com-openpeer-opios/lib/10012013_0.8_boost-build-iOS-5.zip
unzip 10012013_0.8_boost-build-iOS-5.zip
popd


NOTE: If you are running < XCode 5.0 you can build boost by from your terminal:

pushd opios/libs/op/libs/boost/projects/gnu-make/
./build all
popd


2) Build curl, from your terminal:

pushd opios/libs/op/libs/curl/
./build_ios.sh
popd


3) From X-code, load:

opios/openpeer-ios-sdk.xcodeproj (project/workspace)


4) Select HOPSDK > iOS Device schema and then build

The OpenpeerSDK.framework and OpenpeerDataModel.bundle will be built inside:
project_derived_data_folder/Build/Products/Debug-iphoneos/		- in debug mode
project_derived_data_folder/Build/Products/Release-iphoneos/	- in release mode


Required frameworks:
CoreAudio
CoreVideo
CoreMedia
CoreData
CoreGraphics
CoreImage
Foundation
MobileCoreServices
QuartzCore
AssetLibrary
AudioToolbox
AVFoundation
Security
UIKIT
libresolve.dylib
libz.dylib
libxml2.dylib


Exploring the dependency libraries:
Core Projects/zsLib      - asynchronous communication library for C++
Core Projects/udns       - C language DNS resolution library
Core Projects/cryptopp   – C++ cryptography language
Core Projects/hfservices - C++ Hookflash Open Peer communication services layer
Core Projects/hfstack    – C++ Hookflash Open Peer stack
Core Projects/hfcore     – C++ Hookflash Open Peer core API (works on the Open Peer stack)
Core Projects/WebRTC     – iPhone port of the webRTC media stack


Exploring the SDK:
openpeer-ios-sdk/         - header files used to build Open Peer iOS applications
openpeer-ios-sdk/Source   - implementation of header files
openpeer-ios-sdk/Internal – internal implementation of iOS to C++ wrapper for SDK
Samples/OpenPeerSampleApp - basic example of how to use the SDK


Exploring the header files:

HOPAccount.h
- Object representing Open Peer account.

HOPCache.h
- Object used for caching user data.

HOPCall.h
- Object used for placing audio/video calls created with the contact of a conversation thread.

HOPConctact.h
- Contact object representing a local or remote peer contact/person.

HOPConversationThread.h
- Conversation object where contacts are added and text and calls can be performed.

HOPIdentity.h
- Identity object used for identity login and downloading rolodex contacts.

HOPIdentityLookup.h
- Object used to lookup identities of peer contacts to obtain peer contact information.

HOPIdentityLookupInfo.h
- Object representing information about the identity URI and date of last update.

HOPLogger.h
- Object used for managing core debug logs.

HOPMediaEngine.h
- Object used for media control.

HOPMediaEngineRtpRtcpStatistics.h
- Object representing media engine stats.

HOPMessage.h
- Object representing sent/received message.

HOPModelManager.h
- Object used for core data manipulation.

HOPProtocols.h
- Object-C protocols to implement callback event routines.

HOPStack.h
- Object to be constructed after HOPClient object, pass in all the listener event protocol objects

HOPTypes.h
- Place where are defined most of enums used in SDK


Branches:

Our current activity is being performed on "20131025-federated-cloud-contacts" but this branch is unstable. Individual activity is on other sub-branches from this branch.
https://github.com/openpeer/opios/tree/20131025-federated-cloud-contacts

To see all branches go to:
https://github.com/openpeer/opios/branches


Contact info:

Please contact robin@hookflash.com if you have any suggestions to improve the API. Please use support@hookflash.com for any bug reports. New feature requests should be directed to erik@hookflash.com.

Thank you for your interest in the Hookflash Open Peer iOS SDK.

License:

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



