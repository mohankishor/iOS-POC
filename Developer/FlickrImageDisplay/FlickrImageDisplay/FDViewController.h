//
//  FDViewController.h
//  FlickrImageDisplay
//
//  Created by test on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "ZoomedImageView.h"
@interface FDViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *theTableView;
    NSMutableArray  *photoTitles;         // Titles of images
    NSMutableArray  *photoSmallImageData; // Image data (thumbnail)
    NSMutableArray  *photoURLsLargeImage; // URL to larger image
    UITextField     *searchTextField;
    ZoomedImageView  *fullImageViewController;
    UIActivityIndicatorView *activityIndicator;      
}
@end
