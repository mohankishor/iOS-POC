//
//  Employee.h
//  CustomCellTableView
//
//  Created by Anand Kumar Y N on 26/08/10.
//  Copyright 2010 Sourcebits Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Employee : UIViewController {
	
	NSInteger myNumber;
	NSMutableArray *myArray;
	
	UILabel *myName;
	UILabel *myAddress;
	UILabel *myDesignation;
	UIImageView *myImageView;
	UILabel *myContact;
	UILabel *myEmail;
	
	

}
//@property(nonatomic, retain)UILabel *myName;
-(void)viewAtIndexForCell:(NSInteger)inIndex;


@end
