//
//  InfoViewController.m
//  MainProjectR&D
//
//  Created by test on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController
@synthesize infoArray;
@synthesize infoTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Info";
    self.navigationController.navigationBarHidden = NO;
    self.infoTableView = [[UITableView alloc] initWithFrame:self.view. bounds style:UITableViewStyleGrouped];
    self.infoTableView.delegate = self; 
    self.infoTableView.dataSource = self; 
    self.infoTableView.backgroundColor = [UIColor clearColor];
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.infoTableView];
    NSMutableArray *listOfItems = [[NSMutableArray alloc] init];
    NSArray *expcars = [NSArray arrayWithObjects:@"Rolls Royce", @"Benz",@"BMW",nil];
    NSDictionary *expCarsDict = [NSDictionary dictionaryWithObject:expcars forKey:@"ExpCars"];
    
    NSArray *leastExpcars = [NSArray arrayWithObjects:@"Maruti800", @"Chevy Spark",@"Maruti Alto", nil];
    NSDictionary *leastExpcarsDict = [NSDictionary dictionaryWithObject:leastExpcars forKey:@"LeastExpCars"];
    
    [listOfItems addObject:expCarsDict];
    [listOfItems addObject:leastExpcarsDict];
   // NSLog(@"%@",self.infoArray);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return 2;
}

@end
