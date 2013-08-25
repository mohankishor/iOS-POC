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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UITableView *objTableView = [[UITableView alloc] initWithFrame:self.view. bounds style:UITableViewStylePlain];
    objTableView.delegate = self; objTableView.dataSource = self; objTableView.backgroundColor = [UIColor clearColor];
    objTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; [self.view addSubview:objTableView];
    listOfItems = [[NSMutableArray alloc]init];
    [listOfItems addObject:@"India"];
    [listOfItems addObject:@"Pakistan"];
    [listOfItems addObject:@"Sri Lanka"];
    [listOfItems addObject:@"Bangladesh"];
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
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Countries";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Countries Footer";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StatesViewController *objectStatesViewController = [[StatesViewController alloc]init];
    objectStatesViewController.row = indexPath.row;
    [self presentModalViewController:objectStatesViewController animated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    StatesViewController *objectStatesViewController = [[StatesViewController alloc]init];
    objectStatesViewController.row = indexPath.row;
    [self presentModalViewController:objectStatesViewController animated:YES];
}
@end
