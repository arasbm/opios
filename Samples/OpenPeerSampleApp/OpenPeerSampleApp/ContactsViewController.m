//
//  ContactsViewController.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/16/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"
#import "ActivityIndicatorViewController.h"
#import "MainViewController.h"
#import "OpenPeer.h"
#import "SessionManager.h"

#import <OpenpeerSDK/HOPRolodexContact+External.h>
#import <OpenpeerSDK/HOPModelManager.h>
#import <OpenpeerSDK/HOPHomeUser.h>

#define REMOTE_SESSION_ALERT_TAG 1
#define TABLE_CELL_HEIGHT 55.0

@interface ContactsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UITapGestureRecognizer *oneTapGestureRecognizer;
@property (nonatomic,retain) NSMutableArray* listOfSelectedContacts;
@property (nonatomic) BOOL keyboardIsHidden;

- (void)registerForNotifications:(BOOL)registerForNotifications;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void) setFramesSizesForUserInfo:(NSDictionary*) userInfo;
@end

@implementation ContactsViewController

- (NSMutableArray*) listOfSelectedContacts
{
    if (!_listOfSelectedContacts)
        _listOfSelectedContacts = [[NSMutableArray alloc] init];
    return _listOfSelectedContacts;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.keyboardIsHidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self.contactsTableView respondsToSelector:@selector(sectionIndexBackgroundColor)])
        self.contactsTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    self.oneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)];
    self.oneTapGestureRecognizer.delegate = self;
    self.oneTapGestureRecognizer.numberOfTapsRequired = 1;
    self.oneTapGestureRecognizer.numberOfTouchesRequired = 1;
 
    
}

- (void)viewWillAppear:(BOOL)animated
{
    return;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self registerForNotifications:YES];
    
//    CGRect rect = self.navigationController.navigationBar.frame;
//    rect.size.height = 70.0;
//    self.navigationController.navigationBar.frame = rect;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self registerForNotifications:NO];
    if (self.oneTapGestureRecognizer)
        [self.view removeGestureRecognizer:self.oneTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void) prepareTableForRemoteSessionMode
{
    self.contactsTableView.allowsMultipleSelection = [[OpenPeer sharedOpenPeer] isRemoteSessionActivationModeOn];
    if (![[OpenPeer sharedOpenPeer] isRemoteSessionActivationModeOn])
    {
        [self.listOfSelectedContacts removeAllObjects];
    }
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
    
    [cell setContact:contact inTable:self.contactsTableView atIndexPath:indexPath];
    
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
            Session* session = [[SessionManager sharedSessionManager] createSessionForContact:contact];
            
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(associatedIdentity.homeUser.stableId MATCHES '%@')",[[HOPModelManager sharedModelManager] getLastLoggedInHomeUser].stableId]];
    [fetchRequest setPredicate:predicate];
    
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
    
	//_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[HOPModelManager sharedModelManager] managedObjectContext] sectionNameKeyPath:@"firstLetter" cacheName:@"RolodexContacts"];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[HOPModelManager sharedModelManager] managedObjectContext] sectionNameKeyPath:nil cacheName:@"RolodexContacts"];
    _fetchedResultsController.delegate = self;
    
	return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	switch (type)
    {
		case NSFetchedResultsChangeInsert:
			[self.contactsTableView  insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			//[[self.contactsTableView cellForRowAtIndexPath:indexPath].textLabel setText:((HOPRolodexContact*)[[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).name];
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

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString* predicateString = nil;
    
    if ([searchText length] > 0)
        predicateString = [NSString stringWithFormat:@"(associatedIdentity.homeUser.stableId MATCHES '%@' AND name CONTAINS[c] '%@') ",[[HOPModelManager sharedModelManager] getLastLoggedInHomeUser].stableId,searchText];
    else
        predicateString = [NSString stringWithFormat:@"(associatedIdentity.homeUser.stableId MATCHES '%@') ",[[HOPModelManager sharedModelManager] getLastLoggedInHomeUser].stableId];
    
    [NSFetchedResultsController deleteCacheWithName:@"RolodexContacts"];
    
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"HOPRolodexContact" inManagedObjectContext:[[HOPModelManager sharedModelManager] managedObjectContext]];
    //[fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error;
	if (![self.fetchedResultsController performFetch:&error])
    {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    [self.contactsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}


- (void) onContactsLoaded
{
    NSLog(@"onContactsLoaded");
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

- (void) registerForNotifications:(BOOL)registerForNotifications
{
    if (registerForNotifications)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    if (self.oneTapGestureRecognizer)
        [self.view addGestureRecognizer:self.oneTapGestureRecognizer];
    
    self.keyboardIsHidden = NO;
    [self setFramesSizesForUserInfo:[notification userInfo]];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    if (self.oneTapGestureRecognizer)
        [self.view removeGestureRecognizer:self.oneTapGestureRecognizer];
    
    self.keyboardIsHidden = YES;
    [self setFramesSizesForUserInfo:[notification userInfo]];
}
- (void) setFramesSizesForUserInfo:(NSDictionary*) userInfo
{
    CGFloat keyboardHeight = 0;
    
    if (userInfo != nil)
    {
        CGRect keyboardFrame;
        NSValue *ks = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
        keyboardFrame = [ks CGRectValue];
        keyboardHeight = self.keyboardIsHidden ? 0 : keyboardFrame.size.height;
        
        NSTimeInterval animD;
        UIViewAnimationCurve animC;
        
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animC];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animD];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: animD];
        [UIView setAnimationCurve:animC];
    }
    
    // set initial size, chat view
    CGRect contactsTableViewRect = self.contactsTableView.frame;
    //contactsTableViewRect.origin.y = 0.0;//topSessionView.frame.size.height;
    
    if (!self.keyboardIsHidden)
        contactsTableViewRect.size.height = self.view.frame.size.height - self.searchBar.viewForBaselineLayout.frame.size.height - keyboardHeight + self.tabBarController.tabBar.frame.size.height;
    else
        contactsTableViewRect.size.height = self.view.frame.size.height - self.searchBar.viewForBaselineLayout.frame.size.height;    self.contactsTableView.frame = contactsTableViewRect;

    
    if (userInfo)
        [UIView commitAnimations];
}

@end
