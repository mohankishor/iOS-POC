//
//  ABViewController.m
//  AddressBook
//
//  Created by test on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABViewController.h"

@implementation ABViewController
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
    self.title = @"Address Book";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _dataSource = [[NSMutableArray alloc]initWithObjects:@"Add Contact",@"View Contact",@"Edit Contact",@"Delete Contact", nil];
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
        ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
        view.newPersonViewDelegate = (id)self;
        
        UINavigationController *newNavigationController = [[UINavigationController alloc]
                                                           initWithRootViewController:view];
        [self presentModalViewController:newNavigationController
                                animated:YES];
    }
    if (indexPath.row == 1) {
        ViewContacts *viewContacts = [[ViewContacts alloc]initWithNibName:@"ViewContacts" bundle:nil];
        [self.navigationController pushViewController:viewContacts animated:YES];   
    }
    if (indexPath.row == 2) {
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
        picker.peoplePickerDelegate = (id)self;
        [self presentModalViewController:picker animated:YES];
    }
    if (indexPath.row == 3) {
        DeleteContacts *deleteContacts = [[DeleteContacts alloc]initWithNibName:@"DeleteContacts" bundle:nil];
        [self.navigationController pushViewController:deleteContacts animated:YES];
    }
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	
    // remove the controller
    [self dismissModalViewControllerAnimated:YES];
    // setting the first name
    ABPersonViewController *view = [[ABPersonViewController alloc] init];
    
    view.personViewDelegate = (id)self;
    view.displayedPerson = person;
    view.allowsEditing = YES;
    [self.navigationController pushViewController:view animated:YES];

    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

@end
