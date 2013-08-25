//
//  Created by Björn Sållarp on 2009-07-17.
//  NO Copyright 2009 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MLUtils.h"

@interface DetailsViewController : UIViewController <MFMailComposeViewControllerDelegate>{
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *inhabitantsLabel;
	IBOutlet UIButton *phoneButton;
	IBOutlet UIButton *emailButton;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UIScrollView *descriptionScrollView;
	NSString *cityName;
	NSNumber *inhabitants;
	NSString *description;
	NSString *email;
	NSString *phone;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *inhabitantsLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UIButton *phoneButton;
@property (nonatomic, retain) UIButton *emailButton;
@property (nonatomic, retain) UIScrollView *descriptionScrollView;

@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSNumber *inhabitants;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;


-(IBAction) phoneButtonClicked:(id)sender;
-(IBAction) emailButtonClicked:(id)sender;

- (void)openInAppEmail:(NSArray*)recipients
		   mailSubject:(NSString*)mailSubject
			  mailBody:(NSString*)mailBody
				isHtml:(BOOL)isHtml;

@end
