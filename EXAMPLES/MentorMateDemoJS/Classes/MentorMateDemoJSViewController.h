//
//  MentorMateDemoJSViewController.h
//  MentorMateDemoJS
//
//
//  Created by Iordan Iordanov on 2/26/10.
//  Copyright MentorMate 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentorMateDemoJSViewController : UIViewController 
{

	IBOutlet UIWebView *imgWebView;
	IBOutlet UIButton *updateBtn;
}

@property(nonatomic, retain)UIWebView *imgWebView;
@property(nonatomic, retain)UIButton *updateBtn;


//----- Buttons Action Definition
- (IBAction) updateBtnClicked:(id)sender;

-(void) showWebViewOnTimer:(NSTimer *)timer;
-(void) showWebView;


-(void) getGraph:(NSMutableString *)graphURL;
-(NSString *) getLegendTable;

@end

