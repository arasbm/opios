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

#import "ContactsTableViewController.h"
#import "ContactsManager.h"
#import "SessionManager.h"
#import "Constants.h"
#import <OpenpeerSDK/HOPRolodexContact+External.h>
#import <OpenpeerSDK/HOPModelManager.h>
#import <OpenpeerSDK/HOPImage.h>
#import <OpenpeerSDK/HOPAvatar+External.h>
#import "OpenPeer.h"
#import "ActivityIndicatorViewController.h"
#import "MainViewController.h"
#import "ContactTableViewCell.h"
#import "IconDownloader.h"

#define REMOTE_SESSION_ALERT_TAG 1
#define AVATAR_WIDTH 31.0
#define AVATAR_HEIGHT 31.0
#define TABLE_CELL_HEIGHT 55.0

@interface ContactsTableViewController ()

- (void) prepareTableForRemoteSessionMode;

@property (nonatomic,retain) NSMutableArray* listOfSelectedContacts;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation ContactsTableViewController

- (NSMutableArray*) listOfSelectedContacts
{
    if (!_listOfSelectedContacts)
        _listOfSelectedContacts = [[NSMutableArray alloc] init];
    return _listOfSelectedContacts;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareTableForRemoteSessionMode) name:notificationRemoteSessionModeChanged object:nil];
    
    self.contactsTableView.backgroundColor = [UIColor clearColor];
    self.contactsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //Terminate all pending icon download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

- (void) prepareTableForRemoteSessionMode
{
    self.contactsTableView.allowsMultipleSelection = [[OpenPeer sharedOpenPeer] isRemoteSessionActivationModeOn];
    if (![[OpenPeer sharedOpenPeer] isRemoteSessionActivationModeOn])
    {
        [self.listOfSelectedContacts removeAllObjects];
    }
}

- (void) onContactsLoadingStarted
{    
    [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:YES withText:@"Getting contacts from social provider ..." inView:self.view];
}

- (void) onContactsLookupCheckStarted
{
    [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:YES withText:@"Checking contacts against lookup server ..." inView:self.view];
}

- (void) onContactsPeerFilesLoadingStarted
{
    [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:YES withText:@"Getting peer files for contacts ..." inView:self.view];
}
- (void) onContactsLoaded
{
    NSError *error;
	if (![self.fetchedResultsController performFetch:&error])
    {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    [self.contactsTableView reloadData];
    [[ActivityIndicatorViewController sharedActivityIndicator] showActivityIndicator:NO withText:nil inView:nil];
}

#pragma  mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ContactCell";
    
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tableViewCell.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tableViewCell_selected.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    
    HOPRolodexContact* contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell setContact:contact];
    
    HOPAvatar* avatar = [contact getAvatarForWidth:[NSNumber numberWithFloat:AVATAR_WIDTH] height:[NSNumber numberWithFloat:AVATAR_HEIGHT]];
    if (avatar)
    {
        UIImage* img = [avatar getImage];
        if (!img)
            [self startIconDownloadForIndexPath:indexPath];
        else
            cell.imageView.image = img;
    }
    
    if (contact.identityContact)
    {
        cell.userInteractionEnabled = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HOPRolodexContact* contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (contact)
    {
        //Check if app is in remote session mode
        if (![[OpenPeer sharedOpenPeer] isRemoteSessionActivationModeOn])
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            self.contactsTableView.allowsMultipleSelection = NO;
            //If not, create a session for selecte contact
            Session* session = [[SessionManager sharedSessionManager] createSessionForContact:nil];//[contact getCoreContact]];
            
            [[[OpenPeer sharedOpenPeer] mainViewController] showSessionViewControllerForSession:session forIncomingCall:NO forIncomingMessage:NO];
        }
        else
        {
            self.contactsTableView.allowsMultipleSelection = YES;
            //If app is in remote session mode, add selected contact to the list of contacts which will take a part in a remote session
            //If contact is already in the list, remove it
            if ([self.listOfSelectedContacts containsObject:contact])
            {
                [self.listOfSelectedContacts removeObject:contact];
            }
            else
            {
                [self.listOfSelectedContacts addObject:contact];
            }
            
            //If two contacts are selected ask user to create remote session between selected contacts
            if ([self.listOfSelectedContacts count] == 2)
            {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Remote video session."
                                                                    message:@"Do you want to create a remote session?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"No"
                                                          otherButtonTitles:@"Yes",nil];
                alertView.tag = REMOTE_SESSION_ALERT_TAG;
                [alertView show];
                
            }
            else if ([self.listOfSelectedContacts count] > 2)
            {
                [self.listOfSelectedContacts removeLastObject];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Remote video session."
                                                                    message:@"You cannot select more than two contacts!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                alertView.tag = 0;
                [alertView show];
                return;
            }
        }
    }
    
    if (!self.contactsTableView.allowsMultipleSelection)
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0)
{
    HOPRolodexContact* contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (contact)
    {
        if ([self.listOfSelectedContacts containsObject:contact])
        {
            [self.listOfSelectedContacts removeObject:contact];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == REMOTE_SESSION_ALERT_TAG)
    {
        if (buttonIndex == 1)
        {
            //If user wants to create a remote session between selected contacts, create a session for fist selected and send him a system message to create a session with other selected contact
            [[SessionManager sharedSessionManager] createRemoteSessionForContacts:self.listOfSelectedContacts];
        }
    }
}


#pragma mark - NSFetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HOPRolodexContact" inManagedObjectContext:[[HOPModelManager sharedModelManager] managedObjectContext]];
	[fetchRequest setEntity:entity];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];

	_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[HOPModelManager sharedModelManager] managedObjectContext] sectionNameKeyPath:nil cacheName:@"RolodexContacts"];
    _fetchedResultsController.delegate = self;

	return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[self.contactsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	switch (type)
    {
		case NSFetchedResultsChangeInsert:
			[self.contactsTableView  insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			[[self.contactsTableView cellForRowAtIndexPath:indexPath].textLabel setText:((HOPRolodexContact*)[[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).name];
			break;
		case NSFetchedResultsChangeDelete:
			[self.contactsTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeMove:
			[self.contactsTableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.contactsTableView  insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.contactsTableView endUpdates];
}

- (void)startIconDownloadForIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        HOPRolodexContact* contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
        HOPAvatar* avatar = ((HOPAvatar*)contact.avatars.anyObject);
        [iconDownloader setCompletionHandler:^(UIImage* downloadedImage){
            
            UITableViewCell *cell = [self.contactsTableView cellForRowAtIndexPath:indexPath];
            
            [avatar storeImage:downloadedImage];
            
            // Display the newly loaded image
            cell.imageView.image = downloadedImage;
            
            [self.contactsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownloadForURL:avatar.url];
    }
}
@end
