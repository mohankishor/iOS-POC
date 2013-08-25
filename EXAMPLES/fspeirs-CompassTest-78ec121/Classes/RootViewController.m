//
//  RootViewController.m
//  CompassTest
//
//  Created by Fraser Speirs on 18/06/2009.
//  Copyright Connected Flow 2009. All rights reserved.
//

#import "RootViewController.h"
#import "CLLocation-EXExtensions.h"

enum {
	CTTableSectionControls = 0,
	CTTableSectionLocation,
	CTTableSectionHeading,
	CTTableNumberOfSections
};

enum {
	CTTableSectionControlsLocationRow = 0,
	CTTableSectionControlsHeadingRow,
	CTTableSectionControlsNumberOfRows
};

enum {
	CTTableSectionLocationLatitudeRow = 0,
	CTTableSectionLocationLongitudeRow,
	CTTableSectionLocationNumberOfRows
};

enum {
	CTTableSectionHeadingMagneticHeadingRow = 0,
	CTTableSectionHeadingTrueHeadingRow,
	CTTableSectionHeadingAccuracyRow,
	CTTableSectionHeadingTimestampRow,
	CTTableSectionHeadingXRow,
	CTTableSectionHeadingYRow,
	CTTableSectionHeadingZRow,
	CTTableSectionHeadingNumberOfRows
};

@interface RootViewController ()
@property (readwrite) BOOL locationEnabled;
@property (readwrite) BOOL headingEnabled;
@end

@implementation RootViewController
@synthesize mostRecentLocation;
@synthesize mostRecentHeading;
@synthesize locationEnabled;
@synthesize headingEnabled;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	manager = [[CLLocationManager alloc] init];
	manager.delegate = self;
	self.locationEnabled = NO;
	self.headingEnabled = NO;
	
	if(manager.headingAvailable) {
		headingSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
		[headingSwitch addTarget: self 
						  action: @selector(toggleHeadingUpdates:)
				forControlEvents: UIControlEventValueChanged];
	}
	
	locationSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
	[locationSwitch addTarget: self 
					   action: @selector(toggleLocationUpdates:)
			 forControlEvents: UIControlEventValueChanged];
}

- (IBAction)toggleLocationUpdates:(id)sender {
	self.locationEnabled = [(UISwitch *)sender isOn];
	if(self.locationEnabled)
		[manager startUpdatingLocation];
	else {
		[manager stopUpdatingLocation];
		self.mostRecentLocation = nil;
	}
	[self.tableView reloadData];
}

- (IBAction)toggleHeadingUpdates:(id)sender {
	self.headingEnabled = [(UISwitch *)sender isOn];
	if(self.headingEnabled)
		[manager startUpdatingHeading];
	else {
		[manager stopUpdatingHeading];
		self.mostRecentHeading = nil;
	}
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Core location
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	self.mostRecentLocation = newLocation;
	[self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
	// For performance, it might be a good idea to filter out small changes here.
	self.mostRecentHeading = newHeading;
	[self.tableView reloadData];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
	return YES;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CTTableNumberOfSections;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case CTTableSectionControls:
			return CTTableSectionControlsNumberOfRows;
		case CTTableSectionLocation:
			return CTTableSectionLocationNumberOfRows;
		case CTTableSectionHeading:
			return CTTableSectionHeadingNumberOfRows;
		default:
			return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									   reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.detailTextLabel.text = @"Unknown"; // Will re-set later.
    cell.accessoryView = nil; // In case the control rows get re-used.
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	// Configure the cell.
	if(indexPath.section == CTTableSectionControls) {
		cell.detailTextLabel.text = @"";
		
		if(indexPath.row == CTTableSectionControlsLocationRow) {
			cell.textLabel.text = @"Location";
			locationSwitch.on = self.locationEnabled;
			cell.accessoryView = locationSwitch;
		}
		else if(indexPath.row == CTTableSectionControlsHeadingRow) {
			cell.textLabel.text = @"Heading";
			headingSwitch.on = self.headingEnabled;
			if(headingSwitch) {
				cell.accessoryView = headingSwitch;
			}
			else {
				cell.detailTextLabel.text = @"Unsupported";
			}

		}
	}
	else if(indexPath.section == CTTableSectionLocation) {
		switch (indexPath.row) {
			case CTTableSectionLocationLatitudeRow:
				cell.textLabel.text = @"Latitude";
				if(self.mostRecentLocation)
					cell.detailTextLabel.text = [self.mostRecentLocation latitudeString]; 
			break;
			case CTTableSectionLocationLongitudeRow:
				cell.textLabel.text = @"Longitude";
				if(self.mostRecentLocation)
					cell.detailTextLabel.text = [self.mostRecentLocation longitudeString];
			default:
				break;
		}
	}	
	else if(indexPath.section == CTTableSectionHeading) {
		switch (indexPath.row) {
			case CTTableSectionHeadingTrueHeadingRow:
				cell.textLabel.text = @"True Heading";
				if(self.mostRecentHeading)
					cell.detailTextLabel.text = [NSString stringWithFormat: @"%.4f", self.mostRecentHeading.trueHeading];
				break;
			case CTTableSectionHeadingMagneticHeadingRow:
				cell.textLabel.text = @"Magnetic Heading";
				if(self.mostRecentHeading)
					cell.detailTextLabel.text = [NSString stringWithFormat: @"%.4f", self.mostRecentHeading.magneticHeading];
				break;
			case CTTableSectionHeadingAccuracyRow:
				cell.textLabel.text = @"Accuracy";
				if(self.mostRecentHeading)
					cell.detailTextLabel.text = [NSString stringWithFormat: @"%.4f", self.mostRecentHeading.headingAccuracy];
				break;
			case CTTableSectionHeadingTimestampRow:
				cell.textLabel.text = @"Timestamp";
				if(self.mostRecentHeading)
					cell.detailTextLabel.text = [self.mostRecentHeading.timestamp description];
				break;
			case CTTableSectionHeadingXRow:
				cell.textLabel.text = @"X Component";
				if(self.mostRecentHeading)
					cell.detailTextLabel.text = [NSString stringWithFormat: @"%.4f", self.mostRecentHeading.x];
				break;
			case CTTableSectionHeadingYRow:
				cell.textLabel.text = @"Y Component";
				if(self.mostRecentHeading)
					cell.detailTextLabel.text = [NSString stringWithFormat: @"%.4f", self.mostRecentHeading.y];
				break;
			case CTTableSectionHeadingZRow:
				cell.textLabel.text = @"Z Component";
				if(self.mostRecentHeading)
					cell.detailTextLabel.text = [NSString stringWithFormat: @"%.4f", self.mostRecentHeading.z];
				break;
			default:
				break;
		}
	}
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section == CTTableSectionLocation ? @"Location" : @"Heading";
}

- (void)dealloc {
    [super dealloc];
}


@end

