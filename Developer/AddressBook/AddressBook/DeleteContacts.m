//
//  DeleteContacts.m
//  AddressBook
//
//  Created by test on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeleteContacts.h"

@implementation DeleteContacts

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = (id)self;
    [self presentModalViewController:picker animated:YES];
    // Do any additional setup after loading the view from its nib.
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
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
    [self dismissModalViewControllerAnimated:YES];

	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	
    // remove the controller
    [self dismissModalViewControllerAnimated:YES];
    
    ABAddressBookRef addressBook; 
	CFErrorRef error = NULL; 
	addressBook = ABAddressBookCreate(); 
    ABAddressBookRemoveRecord(addressBook, (ABRecordRef)person, &error );
    
    if(error !=NULL)
    {
        UIAlertView  *errorAlert =[[UIAlertView alloc] initWithTitle:@"error" message:@"deleting" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"OK",nil];
        [errorAlert show];
    }
    
    ABAddressBookSave(addressBook, NULL);
    CFRelease(addressBook);

    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


@end
