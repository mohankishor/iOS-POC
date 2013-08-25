//
//  CitiesViewController.m
//  UITableViewThreeLevels
//
//  Created by test on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CitiesViewController.h"

@implementation CitiesViewController

@synthesize detailDescriptionLabel = _detailDescriptionLabel;

@synthesize citiesArray = _citiesArray;

@synthesize delegate = _delegate;

@synthesize textData = _textData;



#pragma mark - Managing the detail item

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Cities";
    }
	
	self.citiesArray = [NSArray arrayWithObjects:@"City1",@"City2",@"City3",@"City4", nil];
	
	UITableView *myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
	myTableView.delegate = (id)self;
	myTableView.dataSource = (id)self;
	myTableView.backgroundColor = [UIColor whiteColor];
	myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	[self.view addSubview:myTableView];
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.citiesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellData = @"actionCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellData];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellData];
	}
	
	cell.textLabel.text = [self.citiesArray objectAtIndex:indexPath.row];
	
	//cell.detailTextLabel.text = [self.statesArray objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSString *itemToPassBack = [self.citiesArray objectAtIndex:indexPath.row];
	
	self.textData = itemToPassBack;
	
	[self.delegate sendSelectedItem:self withDataSent:itemToPassBack];
	[self.navigationController popToRootViewControllerAnimated:YES];
	//[self.navigationController popViewControllerAnimated:YES];
}@end
