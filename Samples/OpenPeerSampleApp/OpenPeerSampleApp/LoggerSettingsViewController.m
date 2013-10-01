//
//  LoggerSettingsViewController.m
//  OpenPeerSampleApp
//
//  Created by Sergej on 10/1/13.
//  Copyright (c) 2013 Hookflash. All rights reserved.
//

#import "LoggerSettingsViewController.h"
#import "OpenPeer.h"
#import <OpenPeerSDK/HOPTypes.h>

typedef enum
{
    LOGGER_STD_OUT,
    LOGGER_TELNET,
    LOGGER_OUTGOING_TELNET,
    LOGGER_MODULES,
    
    LOGGER_SETTINGS_TOTAL_SECTIONS
}LoggerSettingsSections;


typedef enum
{
    TELNET_ENABLE,
    TELNET_SERVER_OR_PORT,
    TELNET_COLOR
}LoggerTelnetOptions;

@interface LoggerSettingsViewController ()

@property (strong, nonatomic) UIPickerView *pickerView;

- (void) switchChanged:(UISwitch*) sender;

@end

@implementation LoggerSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setSwitchCellData:(UITableViewCell*) tableCell
{
    UISwitch* switcher = (UISwitch*) tableCell.accessoryView;
    
    switch (switcher.tag)
    {
        /*case LOGGER_STD_OUT:
            switcher.selected = ((OpenPeer*)[OpenPeer sharedOpenPeer]).isLocalTelnetOn;
            tableCell.textLabel.text = @"Enable std::out logger";
            break;
            
        case LOGGER_LOCAL:
            switcher.selected = ((OpenPeer*)[OpenPeer sharedOpenPeer]).isLocalTelnetOn;
            tableCell.textLabel.text = @"Local telnet logger";
            break;
            
        case LOGGER_OUTGOING:
            switcher.selected = ((OpenPeer*)[OpenPeer sharedOpenPeer]).isRemoteTelnetOn;
            tableCell.textLabel.text = @"Remote telnet logger";
            break;
            
        default:
            break;*/
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return LOGGER_SETTINGS_TOTAL_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ret = 1;
    
    switch (section)
    {
        case LOGGER_STD_OUT:
            ret = 1;
            break;
            
        case LOGGER_TELNET:
        case LOGGER_OUTGOING_TELNET:
            ret = 3;
            break;
           
        case LOGGER_MODULES:
            ret = TOTAL_MODULES_NUMBER;
            break;
            
        default:
            break;
    }
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"regularCell";
    static NSString *switchCellIdentifier = @"switchCell";
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case LOGGER_STD_OUT:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                switchView.tag = indexPath.row;
                cell.accessoryView = switchView;
                [switchView setOn:NO animated:NO];
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            }
            
            [self setSwitchCellData:cell];
        }
            break;
        case LOGGER_TELNET:
        case LOGGER_OUTGOING_TELNET:
        {
            switch (indexPath.row)
            {
                case TELNET_ENABLE:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
                    if (!cell)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                        switchView.tag = indexPath.row;
                        cell.accessoryView = switchView;
                        [switchView setOn:NO animated:NO];
                        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                    }
                    
                    [self setSwitchCellData:cell];
                }
                    break;
                    
                case TELNET_SERVER_OR_PORT:
                {
                    
                }
                    break;
                    
                case TELNET_COLOR:
                {
                    
                }
                    break;
            }

        }
            break;
            
            
        /*case LOGGER_LEVEL:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"User info";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;*/
    }
    
    return cell;
}

- (void) switchChanged:(UISwitch*) sender
{
    /*switch (sender.tag)
    {
        case LOGGER_LOCAL:
        {
            ((OpenPeer*)[OpenPeer sharedOpenPeer]).isLocalTelnetOn = [sender isOn];
            [[OpenPeer sharedOpenPeer] startLocalLogger];
        }
            break;
            
        case LOGGER_OUTGOING:
        {
            ((OpenPeer*)[OpenPeer sharedOpenPeer]).isRemoteTelnetOn = [sender isOn];
            [[OpenPeer sharedOpenPeer] startOutgoingLogger];
        }
            break;

            
        default:
            break;
    }*/
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return HOPLoggerTotalNumberOfLevels;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row)
    {
        case HOPLoggerLevelNone:
            return @"None";
            break;
            
        case HOPLoggerLevelBasic:
            return @"Basic";
            break;
            
        case HOPLoggerLevelDetail:
            return @"Detail";
            break;
            
        case HOPLoggerLevelDebug:
            return @"Debug";
            break;
            
        case HOPLoggerLevelTrace:
            return @"Trace";
            break;
            
        default:
            break;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    
}
@end
