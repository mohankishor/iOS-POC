//
//  QTViewController.m
//  Quartz2DTry
//
//  Created by test on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QTViewController.h"

@implementation QTViewController
@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Quartz2D Functions";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _dataSource = [[NSMutableArray alloc]initWithObjects:@"Polygon Manipulation",@"Layer Drawing",@"PDF Manipulation",@"Text Manipulation", nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
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

#pragma TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"Bitmap" sender:self];
    }
    if (indexPath.row == 1) {
       [self performSegueWithIdentifier:@"LayerDrawing" sender:self];
    }
    if (indexPath.row == 2) {
    [self performSegueWithIdentifier:@"Pdf" sender:self];
    }
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"Text" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Bitmap"]) {
        [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"LayerDrawing"]) {
        [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"Pdf"]) {
        [segue destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"Text"]) {
        [segue destinationViewController];
    }
}
@end
