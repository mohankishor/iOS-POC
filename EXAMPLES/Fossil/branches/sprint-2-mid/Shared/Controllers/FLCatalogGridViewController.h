//
//  FLCatalogGridViewController.h
//  Fossil
//
//  Created by Darshan on 08/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLImageView.h"
#import "FLBaseViewController.h"

@class FLCatalogGridTableDataSource;

@interface FLCatalogGridViewController : FLBaseViewController <UITableViewDelegate>
{
	UITableView					 *mTableView;
	FLCatalogGridTableDataSource *mTableSource;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

+ (UIImage *) combineImageLeft:(UIImage *) leftImage andRight:(UIImage *) rightImage;

+ (UIImage *) imageFromUrlString:(NSString*) path;

- (void) imageTapped:(id) sender;

@end


@interface FLCatalogGridTableDataSource : NSObject<UITableViewDataSource>
{
	id            mImageDelegate;
	UITableViewCell *mCustomCell;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *customCell;

- (id) initWithImageDelegate:(id) delegate;

- (void)setDelegateForViewWithTag:(int) tag atRow:(int) row toCell:(UITableViewCell *) cell;

@end

