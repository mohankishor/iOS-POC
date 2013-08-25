//
//  CustomCellForTable.h
//  CustomCellTableView
//
//  Created by Anand Kumar Y N on 26/08/10.
//  Copyright 2010 Sourcebits Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellForTable : UITableViewCell {
	
	UILabel *mName;
	UILabel *mAddress;
	UILabel *mDesignation;
	UIImageView *mImageView;


}
-(void)displayCell:(NSMutableDictionary *)details;
//-(void)viewAtIndex:(NSInteger)inIndex;


@end
