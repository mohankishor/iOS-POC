//
//  DAddViewController.m
//  DGeoFence
//
//  Created by Darshan Sonde on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAddViewController.h"

@implementation DAddViewController
@synthesize identifierTextField;
@synthesize delegate;
@synthesize radiusSlider;
@synthesize radiusLabel;
@synthesize accuracySegment;

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.identifierTextField becomeFirstResponder];
    
    [self.radiusSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    self.radiusSlider.value = 10.0f;
}


- (void)viewDidUnload
{
    [self setIdentifierTextField:nil];
    [self setRadiusSlider:nil];
    [self setAccuracySegment:nil];
    [self setRadiusLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneClicked:(id)sender {
    if([self.identifierTextField.text length]>0) {
        if(self.delegate) {
            [self.delegate addPinWithIdentifier:self.identifierTextField.text
                                         radius:self.radiusSlider.value 
                                       accuracy:kCLLocationAccuracyBest]; 
        }
        [self dismissModalViewControllerAnimated:YES];
    } else {
        self.identifierTextField.placeholder = @"PLESE ENTER SOME IDENTIFIER";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneClicked:nil];
    return YES;
}

-(void) sliderChanged:(id)sender
{
    self.radiusLabel.text = [NSString stringWithFormat:@"%.1f",self.radiusSlider.value];
}
@end
