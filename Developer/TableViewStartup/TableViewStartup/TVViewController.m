//
//  TVViewController.m
//  TableViewStartup
//
//  Created by test on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TVViewController.h"

@implementation TVViewController

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
    [listOfItems addObject:@"Pradeep Rajkumar"];
    [listOfItems addObject:@"Mohammed Shahid"];
    [listOfItems addObject:@"Srinivas"];
    [listOfItems addObject:@"Vivek Murali"];
    listOfSubtitleItems = [[NSMutableArray alloc]init];
    [listOfSubtitleItems addObject:@"PR"];
    [listOfSubtitleItems addObject:@"MS"];
    [listOfSubtitleItems addObject:@"SV"];
    [listOfSubtitleItems addObject:@"MV"];
    listOfImageItems = [[NSMutableArray alloc]init];
    [listOfImageItems addObject:@"pradeep.jpeg"];
    [listOfImageItems addObject:@"shahid.jpeg"];
    [listOfImageItems addObject:@"srinivas.jpeg"];
    [listOfImageItems addObject:@"vivek.jpeg"];
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
    return [listOfItems count];
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
    NSString *cellSubtitleValue = [listOfSubtitleItems objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = cellSubtitleValue;
    cell.imageView.image = [UIImage imageNamed:[listOfImageItems objectAtIndex:indexPath.row]];
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Collegues";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Collegues Nicknames Footer";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // indexPath.row tells you index of row tapped
    // here do whatever your logic
    UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:[listOfItems objectAtIndex:indexPath.row] message:[NSString stringWithFormat:@"%@%@", @"His Nickname is ", [listOfSubtitleItems objectAtIndex:indexPath.row]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertObj show];
}
@end
