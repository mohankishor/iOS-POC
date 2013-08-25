//
//  CMViewController.m
//  ColorManipulationUsingKVCAndKVO
//
//  Created by test on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CMViewController.h"
@implementation CMViewController
@synthesize colorField;
@synthesize colorDisplay;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self addObserver:self forKeyPath:@"colorField.text" options:NSKeyValueObservingOptionNew context:NULL];
    self.colorField.delegate = self;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setColorField:nil];
    [self removeObserver:self forKeyPath:@"colorField.text"];
    [self setColorDisplay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.colorField) {
        [theTextField resignFirstResponder];
    }
    return YES;
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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"colorField.text"]) {        
            SEL blackSel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", self.colorField.text, @"Color"]);
            UIColor* tColor = nil;
            if ([UIColor respondsToSelector: blackSel])
                    tColor  = [UIColor performSelector:blackSel];
            else
            {
                tColor = [UIColor whiteColor];
                UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Color" message:@"Enter a proper color" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertObj show];
            }
                self.colorDisplay.backgroundColor = tColor;
               
    } 
}
@end
