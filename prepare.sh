#!/bin/bash

: ${PATHTOCURLSCRIPT:=./libs/op/libs/ortc-lib/libs/curl}
: ${PATHTOBOOSTSCRIPT:=./libs/op/libs/ortc-lib/libs/boost}
: ${PATHTOCREDENTIALSTEMPLATE:=./templates}
: ${PATHTOCREDENTIALSDESTINATION:=./Samples/OpenPeerSampleApp/OpenPeerSampleApp}

: ${CREDENTIALSTEMPLATEHEADER:=Template_Credentials.h}
: ${CREDENTIALSTEMPLATESOURCE:=Template_Credentials.m}
: ${CREDENTIALSHEADER:=AppCredentials.h}
: ${CREDENTIALSSOURCE:=AppCredentials.m}

#Runs curl build script
if [ -f "$PATHTOCURLSCRIPT/build_ios.sh" ]; then
	pushd $PATHTOCURLSCRIPT
		echo Building curl ...
		chmod a+x build_ios.sh
		sh build_ios.sh
	popd
else
	echo ERROR. Curl build failed. No such a file or directory.
fi

#Runs boost build script
if [ -f "$PATHTOBOOSTSCRIPT/boost.sh" ]; then
	pushd $PATHTOBOOSTSCRIPT
		echo Building boost ...
		chmod a+x boost.sh
		sh boost.sh
	popd
else
	echo ERROR. Boost build failed. No such a file or directory.
fi

#Checks if header file already exists in the destination folder. If doesn't exist, copies the template header in the destiantion folder and renames it.
if [ ! -f "$PATHTOCREDENTIALSDESTINATION/$CREDENTIALSHEADER" ]; then
	if [ -d $PATHTOCREDENTIALSTEMPLATE ]; then
		if [ -f "$PATHTOCREDENTIALSTEMPLATE/$CREDENTIALSTEMPLATEHEADER" ]; then
			cp -r "$PATHTOCREDENTIALSTEMPLATE/$CREDENTIALSTEMPLATEHEADER" "$PATHTOCREDENTIALSDESTINATION/$CREDENTIALSHEADER"
			echo Copied $CREDENTIALSHEADER
		else
			echo "Error. Template $CREDENTIALSTEMPLATEHEADER doesn't exist!"
		fi
	else
		echo Error. Invalid template directory!
	fi
else
	echo $CREDENTIALSHEADER already exists!
fi

#Checks if cource file already exists in the destination folder. If doesn't exist, copies the template cource in the destiantion folder, renames it and update name of the imported header.
if [ ! -f "$PATHTOCREDENTIALSDESTINATION/$CREDENTIALSSOURCE" ]; then
	if [ -d $PATHTOCREDENTIALSTEMPLATE ]; then
		if [ -f "$PATHTOCREDENTIALSTEMPLATE/$CREDENTIALSTEMPLATESOURCE" ]; then
			cp -r "$PATHTOCREDENTIALSTEMPLATE/$CREDENTIALSTEMPLATESOURCE" "$PATHTOCREDENTIALSDESTINATION/$CREDENTIALSSOURCE"
			sed -i.bak -e s/"$CREDENTIALSTEMPLATEHEADER"/"$CREDENTIALSHEADER"/g "$PATHTOCREDENTIALSDESTINATION/$CREDENTIALSSOURCE"
			echo Copied $CREDENTIALSSOURCE
			rm $PATHTOCREDENTIALSDESTINATION/$CREDENTIALSSOURCE.bak
		else
			echo "Error. Template $CREDENTIALSTEMPLATESOURCE doesnt exist!"
		fi
	else
		echo Error. Invalid template directory!
	fi
else
	echo $CREDENTIALSSOURCE already exists!
fi

#Checks if .gitignore already exists. If not creates it.
if [ ! -f ".gitignore" ]; then
	touch ".gitignore"
fi

#Check if header file is alredy added in the .gitignore file. If not adds it.
if grep $CREDENTIALSHEADER ".gitignore"; then
   echo "$CREDENTIALSHEADER already added in .gitignore"
else
	echo $'\n'$CREDENTIALSHEADER >> ".gitignore"
    cat ".gitignore"
fi

#Check if header file is alredy added in the .gitignore file. If not adds it.
if grep  $CREDENTIALSSOURCE ".gitignore"; then
	echo "$CREDENTIALSSOURCE already added in .gitignore"
else
	echo $'\n'$CREDENTIALSSOURCE >> ".gitignore"
	cat ".gitignore"	
fi
