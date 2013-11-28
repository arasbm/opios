//
//  ImageManager.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 11/28/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "ImageManager.h"
#import "IconDownloader.h"

#import <OpenpeerSDK/HOPAvatar+External.h>

@interface ImageManager ()

@property (nonatomic,strong) NSMutableDictionary *dictionaryDownloadingInProgress;
@property (nonatomic,strong) NSMutableArray *arrayOfInvalidUrls;

- (id) initSingleton;
@end

@implementation ImageManager

+ (id) sharedImageManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^
    {
        _sharedObject = [[self alloc ] initSingleton];
    });
    
    return _sharedObject;
}

- (id) initSingleton
{
    self = [super init];
    if (self)
    {
        self.dictionaryDownloadingInProgress = [[NSMutableDictionary alloc] init];
        self.arrayOfInvalidUrls = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) donwloadImageForAvatar:(HOPAvatar*) inAvatar tableView:(UITableView*) inTableView indexPath:(NSIndexPath*) inIndexPath
{
    //If image is already tried to be downloaded from this url and its failed don't try again
    if ([self.arrayOfInvalidUrls containsObject:inAvatar.url])
        return;
    
    UITableView* tableView = inTableView;
    NSIndexPath* indexPath = inIndexPath;
    __block HOPAvatar* avatar = inAvatar;
    
    IconDownloader *iconDownloader = [self.dictionaryDownloadingInProgress objectForKey:avatar.url];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        [iconDownloader setCompletionHandler:^(UIImage* downloadedImage, NSString* url)
         {
             if (downloadedImage)
             {
                 [avatar storeImage:downloadedImage];
                 
                 UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                 
                 if (cell)
                 {
                     cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                     cell.imageView.clipsToBounds = YES;
                     
                     // Display the newly loaded image
                     cell.imageView.image = downloadedImage;
                     
                     [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                 }
             }
             else
             {
                 [self.arrayOfInvalidUrls addObject:url];
             }
             
             // Remove the IconDownloader from the in progress list.
             // This will result in it being deallocated.
             [self.dictionaryDownloadingInProgress removeObjectForKey:url];
             
         }];
        [self.dictionaryDownloadingInProgress setObject:iconDownloader forKey:avatar.url];
        [iconDownloader startDownloadForURL:avatar.url];
    }
}
@end
