//
//  DetailViewController.m
//  NavControlWithTableViewandStoryBoard
//
//  Created by test on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController
@synthesize detailViewController;
@synthesize statesArray = _statesArray;
@synthesize citiesViewController = _citiesViewController;
@synthesize selectedCountry = _selectedCountry;
- (void)viewDidUnload {
    [self setDetailViewController:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"States";
    UITableView *myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.delegate = (id)self;
    myTableView.dataSource = (id)self;
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:myTableView];
    NSLog(@"%d",_selectedCountry);
    switch (_selectedCountry) {
        case 0:
        {
            _statesArray = [[NSMutableArray alloc] initWithObjects:@"Tamil Nadu",@"Karnataka",@"Kerala",@"Andhra Pradesh", nil];  
            break;
        }
        case 1:
        {
            _statesArray = [[NSMutableArray alloc] initWithObjects:@"Pak1",@"Pak2",@"Pak3",@"Pak4", nil];  
            break;
        }
        case 2:
        {
            _statesArray = [[NSMutableArray alloc] initWithObjects:@"Bang1",@"Bang2",@"Bang3", nil];  
            break;
        }
        case 3:
        {
            _statesArray = [[NSMutableArray alloc] initWithObjects:@"Sri1",@"Sri2", nil];  
            break;
        }
        default:
            break;
    }
  
    
	// Do any additional setup after loading the view, typically from a nib.
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_statesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.statesArray objectAtIndex:indexPath.row];
    //  NSLog(@"%@",indexPath.row);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.citiesViewController) {
        self.citiesViewController = nil;
    }
    self.citiesViewController = [[CitiesViewController alloc] init];
    NSLog(@"%d",indexPath.row);
    NSLog(@"%@",[self.statesArray objectAtIndex:indexPath.row]);
    self.citiesViewController.selectedState = [self.statesArray objectAtIndex:indexPath.row];
  	
    [self.navigationController pushViewController:self.citiesViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

@end
