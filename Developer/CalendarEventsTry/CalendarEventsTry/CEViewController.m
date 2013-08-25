//
//  CEViewController.m
//  CalendarEventsTry
//
//  Created by test on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CEViewController.h"

@implementation CEViewController
@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize eventsList,eventStore,defaultCalendar;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Calendar Events";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _dataSource = [[NSMutableArray alloc]initWithObjects:@"Add Event",@"View Event",@"Edit and Delete Event", nil];
	// Initialize an event store object with the init method. Initilize the array for events.
	self.eventStore = [[EKEventStore alloc] init];
    
	self.eventsList = [[NSMutableArray alloc] initWithArray:0];
	
	// Get the default calendar from store.
	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
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
        EKEventEditViewController *addController = [[EKEventEditViewController alloc]initWithNibName:nil bundle:nil];
        addController.eventStore = self.eventStore;
        [self presentModalViewController:addController animated:YES];
        //[self.navigationController pushViewController:addController animated:YES];
        addController.editViewDelegate = (id)self;
    }
    if (indexPath.row == 1) {
        ViewEvents *viewEvents = [[ViewEvents alloc]initWithNibName:@"ViewEvents" bundle:nil];
        [self.navigationController pushViewController:viewEvents animated:YES];  
    }
    if (indexPath.row == 2) {
        EditEvents *editEvents = [[EditEvents alloc]initWithNibName:@"EditEvents" bundle:nil];
        [self.navigationController pushViewController:editEvents animated:YES];  
    }
}
#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
        {
			// Edit action canceled, do nothing. 
			break;
		}	
		case EKEventEditViewActionSaved:
        {  
            EKEvent *event = [EKEvent eventWithEventStore:controller.eventStore];
            
            int min = 5;
            
            event.title = controller.event.title;
            
            event.startDate = controller.event.startDate;
       
            event.endDate = controller.event.endDate;
            
            NSTimeInterval interval = 60* -min;
            
            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval]; //Create object of alarm
            
            [event addAlarm:alarm]; //Add alarm to your event
            NSLog(@"%@",[NSString stringWithFormat:@"%f",interval]);
            [event setCalendar:[controller.eventStore defaultCalendarForNewEvents]];
            
           if (self.defaultCalendar ==  thisEvent.calendar) {
				[self.eventsList addObject:thisEvent];
			}
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
        }
		default:
			break;
	}
	// Dismiss the modal view controller
    //[self.navigationController popToRootViewControllerAnimated:YES];
	[controller dismissModalViewControllerAnimated:YES];
	
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = self.defaultCalendar;
	return calendarForEdit;
}



@end
