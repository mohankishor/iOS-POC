//
//  GHViewController.m
//  GestureHandling
//
//  Created by test on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GHViewController.h"

@implementation GHViewController
@synthesize tapRecognizer = _tapRecognizer;
@synthesize pinchRecognizer = _pinchRecognizer;
@synthesize swipeRecognizer = _swipeRecognizer;
@synthesize myLabelForTap = _myLabelForTap,tapCount = _tapCount,swipeCount = _swipeCount,pinchCount = _pinchCount,myLabelForPinch = _myLabelForPinch,myLabelForSwipe = _myLabelForSwipe,currentX = _currentX,currentY = _currentY,previousX = _previousX,previousY = _previousY,myLayer = _myLayer;
@synthesize catImage = _catImage;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UIImageView *catImageObject = [[UIImageView alloc]initWithFrame:CGRectMake(0.0,100.0,300.0,75.0)];
    catImageObject.contentMode = UIViewContentModeCenter;
    _catImage = catImageObject;
    _catImage.image = [UIImage imageNamed:@"cat.jpg"];
    [self.view addSubview:_catImage];

    _myLabelForTap = [[UILabel alloc]initWithFrame:CGRectMake(0.0,150.0,300.0,300.0)];
    _myLabelForTap.backgroundColor = [UIColor clearColor];
    _myLabelForTap.textAlignment = UITextAlignmentCenter;
    _myLabelForTap.text = @"Tap Count:0";
    [self.view addSubview:_myLabelForTap];
    _myLabelForSwipe = [[UILabel alloc]initWithFrame:CGRectMake(0.0,180.0,300.0,300.0)];
    _myLabelForSwipe.backgroundColor = [UIColor clearColor];
    _myLabelForSwipe.textAlignment = UITextAlignmentCenter;
    _myLabelForSwipe.text = @"Swipe Count:0";
    [self.view addSubview:_myLabelForSwipe];

    _myLabelForPinch = [[UILabel alloc]initWithFrame:CGRectMake(0.0,210.0,300.0,300.0)];
    _myLabelForPinch.backgroundColor = [UIColor clearColor];
    _myLabelForPinch.textAlignment = UITextAlignmentCenter;
    _myLabelForPinch.text = @"Pinch Count:0";
    [self.view addSubview:_myLabelForPinch];
    
        
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tapRecognizer = nil;
    self.pinchRecognizer = nil;
    self.swipeRecognizer = nil;
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
-(IBAction)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:recognizer.view];
    _tapCount = _tapCount+1;
    _myLabelForTap.text = [NSString stringWithFormat:@"Tap Count:%d(%f,%f)",_tapCount,point.x,point.y];
    if ((_tapCount%2) == 1) {
        _previousX = point.x;
        _previousY = point.y;
        NSLog(@"Entered 1");
    }
    else
    {
        NSLog(@"Entered 2");
        _currentX = point.x;
        _currentY = point.y;
       /* Line *drawLine = [[Line alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,480.0)];
        drawLine.previousX = _previousX;
        drawLine.previousY = _previousY;
        drawLine.currentX = _currentX;
        drawLine.currentY = _currentY;
        [self.view addSubview:drawLine];*/
        self.myLayer = [CALayer layer];
        self.myLayer.backgroundColor = [UIColor whiteColor].CGColor;
        self.myLayer.cornerRadius = 20.0;
        self.myLayer.frame = CGRectMake(60, 100, 200, 200);
        self.myLayer.shadowOffset = CGSizeMake(0, 3);
        self.myLayer.shadowRadius = 5.0;
        self.myLayer.shadowColor = [UIColor blackColor].CGColor;
        self.myLayer.shadowOpacity = 0.8;
        
        [self.view.layer addSublayer:self.myLayer];
    }
        
    
}
-(IBAction)handleSwipeGestureRecognizer:(UISwipeGestureRecognizer *)recognizer
{
    _swipeCount = _swipeCount+1;
    _myLabelForSwipe.text = [NSString stringWithFormat:@"Swipe Count:%d",_swipeCount];
}

-(IBAction)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer
{
    _pinchCount = _pinchCount+1;
    _myLabelForPinch.text = [NSString stringWithFormat:@"Pinch Count:%d",_pinchCount];
    CGAffineTransform transForm = CGAffineTransformMakeScale(recognizer.scale,recognizer.scale);
    _catImage.transform = transForm;
}

@end
