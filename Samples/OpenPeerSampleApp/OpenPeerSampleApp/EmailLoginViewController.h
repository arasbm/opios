//
//  EmailLoginViewController.h
//  OpenPeerSampleApp
//
//  Created by Sergej on 7/16/13.
//  Copyright (c) 2013 Sergej. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailLoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
- (IBAction)actionLogin:(id)sender;

@end
