//
//  DTableView.m
//  DRssReader
//
//  Created by Darshan on 15/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DTableView.h"
#import "XMLParser.h"

@implementation DTableView

@synthesize managedObjectContext = mManagedObjectContext;
@synthesize coordinator = mCoordinator;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.title = @"All";
		self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1] autorelease];

    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSManagedObjectContext *context =[[NSManagedObjectContext alloc] init];
	[context setPersistentStoreCoordinator:self.coordinator];
	
	self.managedObjectContext = context;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	// Configure the request's entity, and optionally its predicate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	NSEntityDescription *desc=[NSEntityDescription entityForName:@"ItemEntity" inManagedObjectContext:context];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setEntity:desc];
	[desc release];
	[sortDescriptors release];
	[sortDescriptor release];
	
	mFetchedResultsController = [[NSFetchedResultsController alloc]
											  initWithFetchRequest:fetchRequest
											  managedObjectContext:context
											  sectionNameKeyPath:nil
											  cacheName:nil];
	[fetchRequest release];
	
	NSError *error;
	BOOL success = [mFetchedResultsController performFetch:&error];
	NSLog(@"fetch result = %d",success);
	
	mTableView.delegate = self;
	mTableView.dataSource = self;
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.managedObjectContext =nil;
	self.coordinator = nil;
    [super dealloc];
}

#pragma mark table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
	NSLog(@"secinosts = %d",[[mFetchedResultsController sections] count]);
    return [[mFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	NSLog(@"rows = %d",[[mFetchedResultsController sections] objectAtIndex:section]);
    id <NSFetchedResultsSectionInfo> sectionInfo = [[mFetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section { 
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[mFetchedResultsController sections] objectAtIndex:section];
  /*  if ([fetchSectioningControl selectedSegmentIndex] == 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"Top %d songs", @"Top %d songs"), [sectionInfo numberOfObjects]];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"%@ - %d songs", @"%@ - %d songs"), [sectionInfo name], [sectionInfo numberOfObjects]];
    }*/
	return @"";
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)table {
    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    return [mFetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)table sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    // tell table which section corresponds to section title/index (e.g. "B",1))
    return [mFetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"SongCell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    Item *item = [mFetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", item.title];
    return cell;
}

/*- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
    self.detailController.song = [mFetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:self.detailController animated:YES];
}*/

@end
