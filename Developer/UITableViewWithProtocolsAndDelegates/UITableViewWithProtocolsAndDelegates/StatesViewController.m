//
//  StatesViewController.m
//  UITableViewWithProtocols
//
//  Created by test on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatesViewController.h"
#import "TPViewController.h"
#import "CitiesViewController.h"
@implementation StatesViewController
@synthesize selectedState = _selectedState;
@synthesize statesArray = _statesArray;
@synthesize textData  = _textdata;
@synthesize delegate = _delegate;
@synthesize citiesViewController = _citiesViewController;
@synthesize row = _row;
/*- (id)initWithStyle:(UITableViewStyle)style
{
  //  self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
       
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //NSLog(@"%@",self.row);
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"States";
        UITableView *myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.backgroundColor = [UIColor whiteColor];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self.view addSubview:myTableView];
 self.statesArray = [NSArray arrayWithObjects:@"State1",@"State2",@"State3",@"State4", nil];
    }
    
    return self;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.statesArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath; {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
    if (cell == nil) { cell = [[UITableViewCell alloc] init]; } 
    cell.textLabel.text =[self.statesArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"States";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"States Footer";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedState = [self.statesArray objectAtIndex:indexPath.row];
    NSLog(@"%@",self.selectedState);
    if (!self.citiesViewController) {
        self.citiesViewController = [[CitiesViewController alloc] initWithNibName:@"CitiesViewController" bundle:nil];
    }
	//self.citiesViewController.row = indexPath.row;
    // NSLog(@"%@",indexPath.row);
	self.citiesViewController.delegate = (id)self;
	
    [self.navigationController pushViewController:self.citiesViewController animated:YES];

    /*NSString *itemToPassBack = [self.statesArray objectAtIndex:indexPath.row];
	
	self.textData = itemToPassBack;
	
	[self.delegate sendSelectedItem:self withDataSent:itemToPassBack];
	
	//[self.navigationController popViewControllerAnimated:YES];
    TPViewController *objectStatesViewController = [[TPViewController alloc]init];
    [self presentModalViewController:objectStatesViewController animated:YES];*/
    //[self dismissModalViewControllerAnimated:YES];
}

- (void) sendSelectedItem:(UIViewController *)controller withDataSent:(NSString *)data
{
   /* [self.navigationController popViewControllerAnimated:YES];
    TPViewController *objectStatesViewController = [[TPViewController alloc]init];
    [self presentModalViewController:objectStatesViewController animated:YES];*/
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"State And City Selected" message:[NSString stringWithFormat:@"Selected State :%@ \n Selected City:%@",self.selectedState, data] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
