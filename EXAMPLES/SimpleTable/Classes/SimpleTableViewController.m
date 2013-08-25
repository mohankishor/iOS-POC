//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Adeem on 17/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "NextViewController.h"
@implementation SimpleTableViewController



/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	arryData = [[NSMutableArray alloc] initWithObjects:@"iPhone",@"iPod",@"MacBook",@"MacBook Pro",nil];
	self.title = @"Edit Table Exmaple";
	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(AddButtonAction:)];
	//	[self.navigationItem setRightBarButtonItem:addButton];
	//	UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(DeleteButtonAction:)];
	//	[self.navigationItem setLeftBarButtonItem:deleteButton];
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
	[self.navigationItem setLeftBarButtonItem:addButton];
    [super viewDidLoad];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [arryData count];
	if(self.editing) count++;
	return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.hidesAccessoryWhenEditing = YES;
    }
    int count = 0;
	if(self.editing && indexPath.row != 0)
		count = 1;
	
	NSLog([NSString stringWithFormat:@"%i,%i",indexPath.row,(indexPath.row-count)]);
	
	
    // Set up the cell...
	if(indexPath.row == ([arryData count]) && self.editing){
		cell.text = @"add new row";
		return cell;
	}
	
	if(self.editing && [[arryData objectAtIndex:indexPath.row] isEqualToString:@"nil"]) {
		UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(40,5,200,50)];
		[cell addSubview:textfield];
		textfield.delegate = self;
		textfield.tag = indexPath.row;
		cell.text = @"";
		[textfield release];
	}
	else {
		cell.text = [arryData objectAtIndex:indexPath.row];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
	[arryData replaceObjectAtIndex:textField.tag withObject:textField.text];
	[textField resignFirstResponder];
	[textField removeFromSuperview];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NextViewController *nextController = [[NextViewController alloc] initWithNibName:@"NextView" bundle:nil];
	[self.navigationController pushViewController:nextController animated:YES];
	[nextController changeProductText:[arryData objectAtIndex:indexPath.row]];
}

//- (IBAction)AddButtonAction:(id)sender{
//	[arryData addObject:@"Mac Mini"];
//	[tblSimpleTable reloadData];
//}

- (IBAction)DeleteButtonAction:(id)sender{
	[arryData removeLastObject];
	[tblSimpleTable reloadData];
}

- (IBAction) EditTable:(id)sender{
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[tblSimpleTable setEditing:NO animated:NO];
		[tblSimpleTable reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[tblSimpleTable setEditing:YES animated:YES];
		[tblSimpleTable reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.    
    if (self.editing && indexPath.row == ([arryData count])) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
    return UITableViewCellEditingStyleNone;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [arryData removeObjectAtIndex:indexPath.row];
		[tblSimpleTable reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [arryData insertObject:@"nil" atIndex:[arryData count]];
		[tblSimpleTable reloadData];
    }
}

#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// Process the row move. This means updating the data model to correct the item indices.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	  toIndexPath:(NSIndexPath *)toIndexPath {
	NSString *item = [[arryData objectAtIndex:fromIndexPath.row] retain];
	[arryData removeObject:item];
	[arryData insertObject:item atIndex:toIndexPath.row];
	[item release];
}

@end
