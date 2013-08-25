//
//  Created by Björn Sållarp on 2009-06-14.
//  NO Copyright 2009 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize managedObjectContext, entityArray, entityName, entitySearchPredicate;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = self.entityName;
	
	// Load locations if we havn't already done so
	if(self.entityArray == nil)
	{
		[self loadLocations];
	}
}

-(void) loadLocations{
	
	if(entitySearchPredicate == nil)
	{
		// Use the CoreDataHelper class to get all objects of the given
		// type sorted by the "Name" key
		NSMutableArray* mutableFetchResults = [CoreDataHelper getObjectsFromContext:self.entityName :@"Name" :YES :managedObjectContext];

		self.entityArray = mutableFetchResults;
	}
	else
	{
		// Use the CoreDataHelper class to search for objects using
		// a given predicate, the result is sorted by the "Name" key
		NSMutableArray* mutableFetchResults = [CoreDataHelper searchObjectsInContext:self.entityName :entitySearchPredicate :@"Name" :YES :managedObjectContext];
		self.entityArray = mutableFetchResults;
	}
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [entityArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
	NSManagedObject *object = (NSManagedObject *)[entityArray objectAtIndex:indexPath.row];

	NSString *CellIdentifier = @"Cell";
	int indicator = UITableViewCellAccessoryNone;
	
	// Check to see if the object has child elements
	if(self.entityName == @"County")
	{
		if([[object valueForKey:@"CountyToProvince"] count] > 0)
		{
			indicator = UITableViewCellAccessoryDisclosureIndicator;
			CellIdentifier = @"CellWithDisclosure";
		}
	}
	else if(self.entityName == @"Province")
	{		
		if([[object valueForKey:@"ProvinceToCity"] count] > 0)
		{
			indicator = UITableViewCellAccessoryDisclosureIndicator;
			CellIdentifier = @"CellWithDisclosure";
		}
		
	}
	
	// Create a cell. It's important to differentiate between cells that have indicators and not. That's
	// why the CellIndentifier is changed if the cell has an indicator.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	cell.accessoryType = indicator;
	cell.textLabel.text = [object valueForKey:@"Name"];
	
	
    return cell;
}




// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


	
	if(self.entityName == @"County" || self.entityName == @"Province")
	{
		// Get the object the user selected from the array
		NSManagedObject *selectedObject = [entityArray objectAtIndex:indexPath.row];
		
		// Create a new table view of this very same class.
		RootViewController *rootViewController = [[RootViewController alloc]
												  initWithStyle:UITableViewStylePlain];
		
		// Pass the managed object context
		rootViewController.managedObjectContext = self.managedObjectContext;
		NSPredicate *predicate = nil;

		
		if(self.entityName == @"County")
		{
			rootViewController.entityName = @"Province";
			
			// Create a query predicate to find all child objects of the selected object. 
			predicate = [NSPredicate predicateWithFormat:@"(ProvinceToCounty == %@)", selectedObject];
			
		} 
		else if(self.entityName == @"Province")
		{
			rootViewController.entityName = @"City";
			
			// Create a query predicate to find all child objects of the selected object.
			predicate = [NSPredicate predicateWithFormat:@"(CityToProvince == %@)", selectedObject];
		}
	
		[rootViewController setEntitySearchPredicate:predicate];

		//Push the new table view on the stack
		[self.navigationController pushViewController:rootViewController animated:YES];
		[rootViewController release];
	}
	else if(self.entityName == @"City")
	{
		// Get the object the user selected from the array
		City *selectedCity = [entityArray objectAtIndex:indexPath.row];
		
		DetailsViewController *detailsView = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:[NSBundle mainBundle]];
		
		
		detailsView.title = selectedCity.Name;
		detailsView.inhabitants = selectedCity.Inhabitants;
		detailsView.description = selectedCity.Description;
		detailsView.phone = selectedCity.Phone;
		detailsView.email = selectedCity.Email;
		
		
		//Push the new table view on the stack
		[self.navigationController pushViewController:detailsView animated:YES];
		[detailsView release];
	}
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	if(entitySearchPredicate != nil)
	{
		[entitySearchPredicate release];
	}
	
	[entityName release];
	[managedObjectContext release];
	[entityArray release];
    [super dealloc];
}


@end

