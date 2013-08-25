//
//  CustomCellTableViewViewController.m
//  CustomCellTableView
//
//  Created by Anand Kumar Y N on 26/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "CustomCellTableViewViewController.h"

@implementation CustomCellTableViewViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	mainView.backgroundColor = [UIColor blackColor];
	self.view = mainView;
	[mainView release];
	
	
	
	NSString *str =[[NSBundle mainBundle] pathForResource:@"EmployeeDB" ofType:@"plist"];
	
	mNameArray=[[NSMutableArray alloc]init];
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:str];
	[mNameArray addObjectsFromArray:[dic objectForKey:@"Employee"]];
	[dic release];
	
	
	mTable1 = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, 390) style:UITableViewCellStyleValue1];
	mTable1.delegate=self;
	mTable1.dataSource=self;
	mTable1.separatorColor = [UIColor redColor];
	[self.view addSubview:mTable1];	
	

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [mNameArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *iden = @"Identifier1";
	CustomCellForTable *cell = (CustomCellForTable *)[tableView dequeueReusableCellWithIdentifier:iden];
	if(cell == nil)
	{
		cell = [[[CustomCellForTable alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden ] autorelease];
	}
	
	[cell displayCell:[mNameArray objectAtIndex:indexPath.row]];
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Employee *myCell=[[Employee alloc]init];
	
	[myCell viewAtIndexForCell:indexPath.row];
	[self.navigationController pushViewController:myCell animated:YES];

	[myCell release];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 75;
}

-(void)viewWillAppear:(BOOL)animated
{
	self.title = @"Employee DataBase";
	//
//	UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
//	self.navigationItem.rightBarButtonItem=bar;
//	[bar release];
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
