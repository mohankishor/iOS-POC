//
//  OpenMailAppDelegate.h
//  OpenMail
//
//  Created by Brandon Trebitowski on 2/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenMailAppDelegate : NSObject <UIApplicationDelegate,UITextFieldDelegate> {
    UIWindow *window;
	
	IBOutlet UIButton *btnSend;
	IBOutlet UITextField *txtTo;
	IBOutlet UITextField *txtSubject;
	IBOutlet UITextView  *txtBody;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIButton *btnSend;
@property (nonatomic, retain) IBOutlet UITextField *txtTo;
@property (nonatomic, retain) IBOutlet UITextField *txtSubject;
@property (nonatomic, retain) IBOutlet UITextView *txtBody;

-(IBAction)send:(id) sender;
- (void) sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body;

@end

