//
//  StatesViewController.m
//  UITableViewWithProtocols
//
//  Created by test on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatesViewController.h"
#import "TPViewController.h"
@implementation StatesViewController
@synthesize row = _row;
@synthesize statesArray = _statesArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    switch (self.row) {
        case 0:
            self.statesArray = [NSArray arrayWithObjects:@"Tamil nadu",@"Kerala",@"Karnataka",@"Andhra", nil];
            break;
        case 1:
            self.statesArray = [NSArray arrayWithObjects:@"Islamabad",@"Karachi", nil];
            break;
        case 2:
            self.statesArray = [NSArray arrayWithObjects:@"Colombo",nil];
            break;
        case 3:
            self.statesArray = [NSArray arrayWithObjects:@"Dhaka", nil];
        default:
            break;   
    }
    UITableView *objTableView = [[UITableView alloc] initWithFrame:self.view. bounds style:UITableViewStylePlain];
    objTableView.delegate = self; objTableView.dataSource = self; objTableView.backgroundColor = [UIColor clearColor];
    objTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; [self.view addSubview:objTableView];
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
    if (cell == nil) { cell = [[UITableViewCell alloc] initWithStyle:
                               UITableViewCellStyleSubtitle reuseIdentifier:cellId]; } 
    cell.textLabel.text =[self.statesArray objectAtIndex:indexPath.row];
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
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertView *alertobj = [[UIAlertView alloc] initWithTitle:@"State Selected" message:selectedCell.textLabel.text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertobj show];
    //TPViewController *objectStatesViewController = [[TPViewController alloc]init];
    //[self presentModalViewController:objectStatesViewController animated:YES];
[self dismissModalViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{ UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertView *alertobj = [[UIAlertView alloc] initWithTitle:@"State Selected" message:selectedCell.textLabel.text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertobj show];
    //TPViewController *objectStatesViewController = [[TPViewController alloc]init];
    //[self presentModalViewController:objectStatesViewController animated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
@end
