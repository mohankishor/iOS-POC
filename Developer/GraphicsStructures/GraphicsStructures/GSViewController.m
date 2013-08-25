//
//  GSViewController.m
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GSViewController.h"

@implementation GSViewController
@synthesize length = _length;

@synthesize width = _width;

@synthesize drawRectangle = _drawRectangle;

@synthesize drawSquare = _drawSquare;

@synthesize drawCircle = _drawCircle;

@synthesize drawTriangle = _drawTriangle;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = @"Graphic Structures";
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

- (IBAction)rectangleButtonPressed:(UIButton *)sender {
    if (!self.drawRectangle) {
        self.drawRectangle = [[Rectangle alloc] initWithNibName:@"Rectangle" bundle:nil];
    }	
    _length = CGRectGetHeight(self.view.bounds);
    _width = CGRectGetWidth(self.view.bounds);
    self.drawRectangle.length = 100.0;
    self.drawRectangle.width = 150.0;

    [self.navigationController pushViewController:self.drawRectangle animated:YES];
}
- (IBAction)squareButtonPressed:(UIButton *)sender {
    if (!self.drawSquare) {
        self.drawSquare = [[Square alloc] initWithNibName:@"Square" bundle:nil];
    }	
    self.drawSquare.length = 100.0;
    
    [self.navigationController pushViewController:self.drawSquare animated:YES];

}

- (IBAction)circleButtonPressed:(UIButton *)sender {
    if (!self.drawCircle) {
        self.drawCircle = [[Circle alloc]initWithNibName:@"Circle" bundle:nil];
    }	
    
    [self.navigationController pushViewController:self.drawCircle animated:YES];
}

- (IBAction)triangleButtonPressed:(UIButton *)sender {
    if (!self.drawTriangle) {
        self.drawTriangle = [[Triangle alloc] initWithNibName:@"Triangle" bundle:nil];
    }	
    [self.navigationController pushViewController:self.drawTriangle animated:YES];
}
@end
