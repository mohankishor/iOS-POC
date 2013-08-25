//
//  CTViewController.m
//  CustomView
//
//  Created by test on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTViewController.h"
#import "CustomCell.h"
@implementation CTViewController

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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithFrame:CGRectZero];
    }
    // Set up the cell…
    switch (indexPath.row) {
        case 0:
            cell.primaryLabel.text = @"Tamil Nadu";
            cell.myImageView.image = [UIImage imageNamed:@"images-4.jpeg"];
             cell.secondaryLabel.text = @"Andhra Pradesh";
            cell.mySecondaryImageView.image = [UIImage imageNamed:@"images-5.jpeg"];
            break;
        case 1:
            cell.primaryLabel.text = @"Kerala";
            cell.myImageView.image = [UIImage imageNamed:@"images-6.jpeg"];
            cell.secondaryLabel.text = @"Karnataka";
            cell.mySecondaryImageView.image = [UIImage imageNamed:@"images-7.jpeg"];
                        break;
        case 2:
            cell.primaryLabel.text = @"Gujarat";
            cell.myImageView.image = [UIImage imageNamed:@"images-8.jpeg"];
            cell.secondaryLabel.text = @"Uttar Pradesh";
            cell.mySecondaryImageView.image = [UIImage imageNamed:@"images-9.jpeg"];
                       break;
        default:
            break;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


@end
