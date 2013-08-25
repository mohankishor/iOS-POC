//
//  MRViewController.m
//  MapRouteBetweenCities
//
//  Created by test on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MRViewController.h"

@implementation MRViewController
@synthesize startField;
@synthesize endField;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Map Directions";
    self.startField.delegate = self;
    self.endField.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setStartField:nil];
    [self setEndField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if ((theTextField == self.startField)||(theTextField == self.endField)) {
        [theTextField resignFirstResponder];
    }
    return YES;
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

- (void)dealloc {
    [startField release];
    [endField release];
    [super dealloc];
}

- (IBAction)searchRoute:(id)sender {
    MapDirectionsViewController *controller = [[MapDirectionsViewController alloc] init];
    
    controller.startPoint = startField.text;
    controller.endPoint = endField.text;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

}
@end
