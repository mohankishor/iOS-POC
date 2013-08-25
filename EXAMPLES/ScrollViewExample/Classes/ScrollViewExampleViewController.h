//
//  ScrollViewExampleViewController.h
//  ScrollViewExample
//
//  Created by Chakra on 31/03/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewExampleViewController : UIViewController {

	IBOutlet UIScrollView *scrollview;
    IBOutlet UITextField *textField1;
    IBOutlet UITextField *textField2;
	
	BOOL displayKeyboard;
	CGPoint  offset;
	UITextField *Field;
}

@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain) IBOutlet UITextField *textField1;
@property(nonatomic,retain) IBOutlet UITextField *textField2;


@end

