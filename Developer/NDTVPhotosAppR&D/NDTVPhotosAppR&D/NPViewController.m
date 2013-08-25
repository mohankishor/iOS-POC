//
//  NPViewController.m
//  NDTVPhotosAppR&D
//
//  Created by test on 04/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NPViewController.h"

@implementation NPViewController
@synthesize textColorEditingTab;
@synthesize blackImageView;
@synthesize isCameraAvailable;
@synthesize photoShootViewController;
@synthesize imageData;
@synthesize tapPhotoView;
@synthesize posterTextField;
@synthesize textFieldView;
@synthesize posterTextView;
@synthesize posterTextLabel;
@synthesize textEditingTab;
@synthesize textFontChooserButton;
@synthesize textColorChooserButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textEditingTab.hidden = YES;
    self.textColorEditingTab.hidden = YES;
    self.textFieldView.hidden = YES;
    self.posterTextField.delegate = self;
    self.title = @"Posters Editing";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Text" style:UIBarButtonItemStylePlain target:self action:@selector(textEditing)];
    self.posterTextView.hidden = YES;
    blackImageView.userInteractionEnabled = YES;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = (id)self;
    [blackImageView addGestureRecognizer:tapGesture];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setBlackImageView:nil];
    [self setTapPhotoView:nil];
    [self setPosterTextField:nil];
    [self setTextFieldView:nil];
    [self setPosterTextView:nil];
    [self setPosterTextLabel:nil];
    [self setTextEditingTab:nil];
    [self setTextFontChooserButton:nil];
    [self setTextColorChooserButton:nil];
    [self setTextColorEditingTab:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:1.5 animations:^{
        self.tapPhotoView.frame = CGRectMake(73, 30, 196, 29);
    }];
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

#pragma mark - pinch Gesture Handler

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
            
    self.photoShootViewController = [[NPPhotoShootViewController alloc]initWithNibName:@"NPPhotoShootViewController" bundle:nil];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIActionSheet *actionSheetForCamera = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:(id)self
                                                         cancelButtonTitle:@"cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Take Photo",@"Choose from Library",nil];
        [actionSheetForCamera showInView:self.view];
        actionSheetForCamera.tag = 1;
        
    }
    
    else{
        UIActionSheet *actionSheetForPhoto = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:(id)self
                                                         cancelButtonTitle:@"cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Choose from Library",nil];
        [actionSheetForPhoto showInView:self.view];
        actionSheetForPhoto.tag =2;
    }
}

#pragma mark - Pinch Gesture Handler

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1;
}

#pragma mark - Rotate Gesture Handler

- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGestureRecognizer
{
    rotateGestureRecognizer.view.transform = CGAffineTransformRotate(rotateGestureRecognizer.view.transform, rotateGestureRecognizer.rotation);
    rotateGestureRecognizer.rotation = 0;
}

#pragma mark - Swipe Gesture Handler

- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    panGestureRecognizer.view.center = CGPointMake(panGestureRecognizer.view.center.x + translation.x, 
                                         panGestureRecognizer.view.center.y + translation.y);
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(panGestureRecognizer.view.center.x + (velocity.x * slideFactor), 
                                         panGestureRecognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            panGestureRecognizer.view.center = finalPoint;
        } completion:nil];
        
    }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {        
    return YES;
}

#pragma mark - PhotoShootViewController Delegate

-(void) sendImageSelected:(NSData *)image{
    [self.tapPhotoView setHidden:YES];
//    for (UIGestureRecognizer *gestureRecognizer in self.blackImageView.gestureRecognizers) {
//        [self.blackImageView removeGestureRecognizer:tapGesture];
//    }
//    blackImageView.userInteractionEnabled = YES;
//    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//    pinchGesture.delegate = (id)self;
//    [blackImageView addGestureRecognizer:pinchGesture];
//    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//    swipeGesture.delegate = (id)self;
//    [blackImageView addGestureRecognizer:swipeGesture];
//    rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
//    rotateGesture.delegate = (id)self;
//    [blackImageView addGestureRecognizer:rotateGesture];
//    self.imageData = image;
//    blackImageView.image =[UIImage imageWithData:image];
}

#pragma mark - Action Sheet delegate Method

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag ==1){
        //Camera Select
        if(buttonIndex == 0){
            self.photoShootViewController.selectedOption = @"Camera";
            self.photoShootViewController.imagedelegate = (id)self;
            [self.navigationController pushViewController:self.photoShootViewController animated:YES];
        }
        else if(buttonIndex == 1){ //Camera Album Select
            self.photoShootViewController.selectedOption = @"CameraAlbum";
            self.photoShootViewController.imagedelegate = (id)self;
            [self.navigationController pushViewController:self.photoShootViewController animated:YES];
        }
    }
    else if(actionSheet.tag == 2){
        if(buttonIndex == 0){
            self.photoShootViewController.selectedOption = @"CameraAlbum";
            self.photoShootViewController.imagedelegate = (id)self;
            [self.navigationController pushViewController:self.photoShootViewController animated:YES];
        }
    }
}

#pragma mark - TextField Delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [self.textFieldView setFrame:CGRectMake(0.0, 157.0, self.textFieldView.frame.size.width, self.textFieldView.frame.size.height)];
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    
    [textFieldView setFrame:CGRectMake(0.0, 368.0, textFieldView.frame.size.width, textFieldView.frame.size.height)];
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( textField == self.posterTextField ) {
        posterTextView.userInteractionEnabled = YES;
        pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        pinchGesture.delegate = (id)self;
        [posterTextView addGestureRecognizer:pinchGesture];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = (id)self;
        [posterTextView addGestureRecognizer:panGesture];
        rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
        rotateGesture.delegate = (id)self;
        [posterTextView addGestureRecognizer:rotateGesture];
        self.posterTextView.hidden = NO;
        self.textFieldView.hidden = YES;
        self.posterTextView.layer.borderColor = [UIColor blueColor].CGColor;
        self.posterTextView.layer.borderWidth = 2.0f;
        self.posterTextLabel.text = textField.text;
        [textField resignFirstResponder];
        self.textEditingTab.hidden = NO;
    }
    return YES;
}


#pragma mark - Text editing

-(void)textEditing
{
    self.textFieldView.hidden = NO;
    [self.posterTextField becomeFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [self.textFieldView setFrame:CGRectMake(0.0, 157.0, self.textFieldView.frame.size.width, self.textFieldView.frame.size.height)];
    [UIView commitAnimations];
}
- (IBAction)chooseTextFont:(id)sender {
    
}

- (IBAction)chooseTextColor:(id)sender {
    self.textEditingTab.hidden = YES;
    self.textColorEditingTab.hidden = NO;
}
- (IBAction)redButtonPressed:(id)sender {
    self.posterTextLabel.textColor = [UIColor redColor];
}

- (IBAction)blackButtonPressed:(id)sender {
     self.posterTextLabel.textColor = [UIColor blackColor];
}

- (IBAction)blueButtonPressed:(id)sender {
      self.posterTextLabel.textColor = [UIColor colorWithRed:91.0/255.0 green:230.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (IBAction)greenButtonPressed:(id)sender {
     self.posterTextLabel.textColor = [UIColor greenColor];
}

- (IBAction)violetButtonPressed:(id)sender {
     self.posterTextLabel.textColor = [UIColor colorWithRed:5.0/255.0 green:31.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (IBAction)YellowButtonPressed:(id)sender {
     self.posterTextLabel.textColor = [UIColor yellowColor];
}

- (IBAction)pinkButtonPressed:(id)sender {
     self.posterTextLabel.textColor = [UIColor colorWithRed:194.0/255.0 green:97.0/255.0 blue:229.0/255.0 alpha:1.0];
}
@end
