//
//  Square.m
//  GraphicsStructures
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Square.h"

@implementation Square
@synthesize squarex = _squarex,squarey = _squarey,button = _button,drawSquare = _drawSquare,length = _length;
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
    _squarex = arc4random()%320;
    _squarey = arc4random()%480;
    self.title = @"Square";    
    _drawSquare = [[DrawSquare alloc]initWithFrame:CGRectMake(100.0,100.0,100.0,100.0)];
    _drawSquare.length = _length;
    [self.view addSubview:_drawSquare];
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button addTarget:self 
                action:@selector(buttonPressed)
      forControlEvents:UIControlEventTouchDown];
    [_button setTitle:@"Animate" forState:UIControlStateNormal];
    _button.frame = CGRectMake(100.0, 10.0, 100.0, 45.0);
    [self.view addSubview:_button];

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
-(void)buttonPressed {
    _button.hidden = YES;
    [UIView beginAnimations:@"Making The Square Around" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _drawSquare.frame = CGRectMake(_squarex,_squarey,_drawSquare.frame.size.width,_drawSquare.frame.size.height);
    [UIView commitAnimations];
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(SEL)aSelector {  
    if (finished) {
        _squarex = arc4random()%220;
        _squarey = arc4random()%300;
        [self buttonPressed];
    }
}
@end
