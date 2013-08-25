//
//  RDSpeakUpViewController.h
//  RedDeluxe
//
//  Created by Pradeep Rajkumar on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDSpeakUpViewController : UIViewController<NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *homeAddressField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UIToolbar *doneToolBar;

- (IBAction)donePressed:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
- (IBAction)sendMessage:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (weak, nonatomic) IBOutlet UIView *contactCongressMenView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)giveManyCongressManAlert:(id)sender;

@end
