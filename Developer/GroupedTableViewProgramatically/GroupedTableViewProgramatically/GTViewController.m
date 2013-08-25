//
//  GTViewController.m
//  GroupedTableViewProgramatically
//
//  Created by test on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GTViewController.h"

@implementation GTViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    UITableView *objTableView = [[UITableView alloc] initWithFrame:self.view. bounds style:UITableViewStyleGrouped];
    objTableView.delegate = self; objTableView.dataSource = self; objTableView.backgroundColor = [UIColor clearColor];
    objTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; [self.view addSubview:objTableView];
    listOfItems = [[NSMutableArray alloc] init];
    NSArray *expcars = [NSArray arrayWithObjects:@"Rolls Royce", @"Benz",@"BMW",nil];
    NSDictionary *expCarsDict = [NSDictionary dictionaryWithObject:expcars forKey:@"ExpCars"];
    
    NSArray *leastExpcars = [NSArray arrayWithObjects:@"Maruti800", @"Chevy Spark",@"Maruti Alto", nil];
    NSDictionary *leastExpcarsDict = [NSDictionary dictionaryWithObject:leastExpcars forKey:@"LeastExpCars"];
    
    [listOfItems addObject:expCarsDict];
    [listOfItems addObject:leastExpcarsDict];
    
    //Set the title
    self.navigationItem.title = @"Cars";
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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath; {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
    if (cell == nil) { cell = [[UITableViewCell alloc] initWithStyle:
                               UITableViewCellStyleDefault reuseIdentifier:cellId]; } 
    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
    NSArray *array = [dictionary objectForKey:@"ExpCars"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
   }
    else if(indexPath.section == 1)
    {
        NSArray *array = [dictionary objectForKey:@"LeastExpCars"];
        NSString *cellValue = [array objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
    }
        
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Expensive cars";
     else 
            return @"Affordable cars";
    return @"Cars";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0)
        return @"Expensive cars Footer";
    else 
        return @"Affordable cars Footer";
    return @"Cars";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [listOfItems count];
}

@end
