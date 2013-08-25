//
//  DetailsViewController.m
//  UITableViewThreeLevels
//
//  Created by test on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"
#import "ViewController.h"
@implementation DetailsViewController
@synthesize row = _row;

@synthesize citiesViewController;

@synthesize detailDescriptionLabel = _detailDescriptionLabel;

@synthesize statesArray = _statesArray;

@synthesize delegate = _delegate;

@synthesize textData = _textData;

- (void)dealloc
{
    [_detailDescriptionLabel release];
    [super dealloc];
}

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
        self.title = @"States";
    }
	
	self.statesArray = [NSArray arrayWithObjects:@"State1",@"State2",@"State3",@"State4", nil];
	
	UITableView *myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.backgroundColor = [UIColor whiteColor];
	myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	[self.view addSubview:myTableView];
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.statesArray count];
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
	
	cell.textLabel.text = [self.statesArray objectAtIndex:indexPath.row];
	
	//cell.detailTextLabel.text = [self.statesArray objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
    if (!self.citiesViewController) {
        self.citiesViewController = [[[CitiesViewController alloc] initWithNibName:@"StatesViewController" bundle:nil] autorelease];
    }
	//self.citiesViewController.row = indexPath.row;
    // NSLog(@"%@",indexPath.row);
	self.citiesViewController.delegate = (id)self;
	
    [self.navigationController pushViewController:self.citiesViewController animated:YES];
	/*NSString *itemToPassBack = [self.statesArray objectAtIndex:indexPath.row];
	
	self.textData = itemToPassBack;
	
	[self.delegate sendSelectedItem:self withDataSent:itemToPassBack];
	
	[self.navigationController popViewControllerAnimated:YES];*/
}

- (void) sendSelectedItem:(UIViewController *)controller withDataSent:(NSString *)data
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"City Selected" message:[NSString stringWithFormat:@"%@", data] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
