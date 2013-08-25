//
//  NSViewController.h
//  NewsstandTry
//
//  Created by test on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publisher.h"
#import <NewsstandKit/NewsstandKit.h>
#import <QuickLook/QuickLook.h>

@interface NSViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDownloadDelegate,
QLPreviewControllerDelegate,QLPreviewControllerDataSource,NSURLConnectionDelegate> {
    Publisher *publisher;
    UIBarButtonItem *waitButton;
    UIBarButtonItem *refreshButton;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

-(void)trashContent;
@end
