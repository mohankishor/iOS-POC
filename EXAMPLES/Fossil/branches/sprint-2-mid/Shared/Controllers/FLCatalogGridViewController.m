//
//  FLCatalogGridViewController.m
//  Fossil
//
//  Created by Darshan on 08/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCatalogGridViewController.h"
#import "FLDataManager.h"
#import "QuartzCore/QuartzCore.h"

@implementation FLCatalogGridViewController

@synthesize tableView = mTableView;

- (void) viewDidLoad
{
    [super viewDidLoad];
	
	[self createToolbarItems:self];
	
	self.view.backgroundColor = [UIColor clearColor];

	if (mTableView)
	{
		[mTableView removeFromSuperview];
		self.tableView = nil;
	}
	
	mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
	mTableView.delegate = self;
	mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	mTableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	
	if(FL_IS_IPAD)
	{
		mTableView.rowHeight = FL_IPAD_CELL_ROW_HEIGHT;
	}
	else
	{
		mTableView.rowHeight = FL_IPHONE_CELL_ROW_HEIGHT;
	}
	
	[self.view addSubview:mTableView];
	
	if (mTableSource)
	{
		[mTableSource release];
	}
	mTableSource = [[FLCatalogGridTableDataSource alloc] initWithImageDelegate:self];
	mTableView.dataSource = mTableSource;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) didReceiveMemoryWarning
{
	[[FLDataManager sharedInstance] clearCache];
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
	[mTableSource release];
}

- (void) dealloc
{
	//table source deallocated in viewDidUnload
    self.tableView = nil;
    [super dealloc];
}

- (void) imageTapped:(id)sender
{
	FLImageView *imView = (FLImageView*) sender;
	//NSString *imageName = [NSString stringWithFormat:@"Image %d clicked", imView.number];
	[self.navigationController gotoCatalogPageViewControllerWithPage:imView.number];
	[self barsVisible:NO];
}

+ (UIImage *) combineImageLeft:(UIImage *) leftImage andRight:(UIImage *) rightImage
{
	if(leftImage.size.height != rightImage.size.height)
	{
		return nil;
	}
	
	int totalWidth = leftImage.size.width+rightImage.size.width;
	CGSize size = CGSizeMake(totalWidth, leftImage.size.height);
	
	UIGraphicsBeginImageContext(size);
	[leftImage drawAtPoint:CGPointMake(0, 0)];
	[rightImage drawAtPoint:CGPointMake(leftImage.size.width, 0)];
	UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return combinedImage;
}

+ (UIImage *) imageFromUrlString:(NSString*) path
{
	UIImage *image = nil;

	if (path && (![path isEqualToString:@""])) 
	{
		NSURL *url = [[NSURL alloc] initWithString:path];
		NSData *data = [[NSData alloc] initWithContentsOfURL:url];
		image = [[[UIImage alloc] initWithData:data] autorelease];
		[data release];
		[url release];
	}
	return image;
}

@end


#pragma mark -
#pragma mark Data source methods

@implementation FLCatalogGridTableDataSource

@synthesize customCell = mCustomCell;

- (id) initWithImageDelegate:(id) delegate
{
	self = [super init];

	if(self) 
	{
		mImageDelegate = delegate;
	}
	return self;
}

- (void) dealloc
{
	self.customCell = nil;
	[super dealloc];
}

- (NSInteger) tableView:(UITableView *) table numberOfRowsInSection:(NSInteger) section
{
	return [[FLDataManager sharedInstance] noOfPages]/6 + FL_COVER_OFFSET;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath 
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FL_CATALOG_GRID_VIEW_CELL_IDENTIFIER];
	
	if (!cell)
	{
		if (FL_IS_IPAD)
		{
			[[NSBundle mainBundle] loadNibNamed:@"FLCustomCell_iPad" owner:self options:nil];
		} 
		else
		{
			[[NSBundle mainBundle] loadNibNamed:@"FLCustomCell_iPhone" owner:self options:nil];
		}
		cell = mCustomCell;
		self.customCell = nil;
		cell.contentView.backgroundColor = [UIColor whiteColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	[[FLDataManager sharedInstance] loadPagesWithCell:cell tableView:tableView indexPath:indexPath];
	[self setDelegateForViewWithTag:1 atRow:indexPath.row toCell:cell];
	[self setDelegateForViewWithTag:2 atRow:indexPath.row toCell:cell];
	[self setDelegateForViewWithTag:3 atRow:indexPath.row toCell:cell];
	return cell;
}

- (void) setDelegateForViewWithTag:(int) tag atRow:(int) row toCell:(UITableViewCell *) cell
{
	id view = [cell viewWithTag:tag];
    
	if ([view isKindOfClass:[FLImageView class]])
	{
		FLImageView *imageView = (FLImageView *)view;
		imageView.delegate = mImageDelegate;
		imageView.number = row *3 +tag;
		if(imageView.number > ([[FLDataManager sharedInstance] noOfPages]-1)/2) {
			imageView.userInteractionEnabled = NO;
		}
		else {
			imageView.userInteractionEnabled = YES;
		}

		
		
		[imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
		[imageView.layer setBorderWidth:1.0];
	}
	else
	{
		NSLog(@"image from the cell not an FLImage type");
	}
}

@end

