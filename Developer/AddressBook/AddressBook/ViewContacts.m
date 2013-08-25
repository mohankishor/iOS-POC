//
//  ViewContacts.m
//  AddressBook
//
//  Created by test on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewContacts.h"

@implementation ViewContacts
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize mobileNumberLabel;
@synthesize emailLabel;

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
    self.title = @"View Contacts";
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate = (id)self;
    [self presentModalViewController:picker animated:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setFirstNameLabel:nil];
    [self setLastNameLabel:nil];
    [self setMobileNumberLabel:nil];
    [self setEmailLabel:nil];
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
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	// setting the first name
    self.firstNameLabel.text = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	
	// setting the last name
    self.lastNameLabel.text = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);	
	
	// setting the number
	/*
	 this function will set the first number it finds
	 
	 if you do not set a number for a contact it will probably
	 crash
	 */
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);        
        [phones addObject:aPhone];
    }
    if (phones.count > 0) {
      self.mobileNumberLabel.text = [phones objectAtIndex:0];  
    }
    ABMutableMultiValueRef emailMulti = ABRecordCopyValue(person, kABPersonEmailProperty);
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    for (i = 0; i < ABMultiValueGetCount(emailMulti); i++) {
        NSString *aEmail = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailMulti, i);        
        [emails addObject:aEmail];
    }
    if (emails.count > 0) {
        self.emailLabel.text = [emails objectAtIndex:0];  
    }

   // remove the controller
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


@end
