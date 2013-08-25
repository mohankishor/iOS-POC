//
//  TPViewController.m
//  UITableViewWithProtocols
//
//  Created by test on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TPViewController.h"

#import "StatesViewController.h"

@implementation TPViewController
@synthesize statesViewController = _statesViewController;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Countries";
        listOfItems = [[NSMutableArray alloc]init];
        [listOfItems addObject:@"India"];
        [listOfItems addObject:@"Pakistan"];
        [listOfItems addObject:@"Sri Lanka"];
        [listOfItems addObject:@"Bangladesh"];
        UITableView *myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.backgroundColor = [UIColor whiteColor];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [self.view addSubview:myTableView];

  }
    return self;
}

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath; {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
    if (cell == nil) { cell = [[UITableViewCell alloc] initWithStyle:
                               UITableViewCellStyleSubtitle reuseIdentifier:cellId]; } 
    NSString *cellValue = [listOfItems objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.statesViewController) {
      self.statesViewController = [[StatesViewController alloc] initWithNibName:@"StatesViewController" bundle:nil];
//        self.statesViewController = [[StatesViewController alloc] init];

    }
    //NSLog(@"%@",indexPath.row);
    self.statesViewController.row = indexPath.row;
	self.statesViewController.delegate = (id)self;
	
    [self.navigationController pushViewController:self.statesViewController animated:YES];
}
- (void) sendSelectedItem:(UIViewController *)controller withDataSent:(NSString *)data
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"State And City Selected" message:[NSString stringWithFormat:@"Selected State :%@ \n Selected City:%@",self.statesViewController.selectedState, data] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
