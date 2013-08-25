//
//  Rectangle.m
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle
@synthesize drawRectangle = _drawRectangle,rectanglex = _rectanglex,rectangley = _rectangley;
@synthesize length = _length,width = _width,button = _button;
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
    _rectanglex = arc4random()%320;
    _rectangley = arc4random()%480;
    self.title = @"Rectangle";    
    _drawRectangle = [[DrawRectangle alloc]initWithFrame:CGRectMake(100.0,100.0,100.0,150.0)];
     _drawRectangle.length = _length;
     _drawRectangle.width = _width;
     [self.view addSubview:_drawRectangle];
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button addTarget:self 
               action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchDown];
    [_button setTitle:@"Animate" forState:UIControlStateNormal];
    _button.frame = CGRectMake(100.0, 10.0, 100.0, 45.0);
    [self.view addSubview:_button];

}
-(void)buttonPressed {
    _button.hidden = YES;
    [UIView beginAnimations:@"Making The Rectangle Around" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     _drawRectangle.frame = CGRectMake(_rectanglex,_rectangley,_drawRectangle.frame.size.width,_drawRectangle.frame.size.height);
    [UIView commitAnimations];
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(SEL)aSelector {  
    if (finished) {
        _rectanglex = arc4random()%220;
        _rectangley = arc4random()%300;
        [self buttonPressed];
    }
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

@end
