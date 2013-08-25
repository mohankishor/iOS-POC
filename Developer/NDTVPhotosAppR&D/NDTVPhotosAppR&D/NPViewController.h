//
//  NPViewController.h
//  NDTVPhotosAppR&D
//
//  Created by test on 04/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NPPhotoShootViewController.h"

#import "QuartzCore/QuartzCore.h"

@interface NPViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate>
{
    UITapGestureRecognizer *tapGesture;
    UIPinchGestureRecognizer *pinchGesture;
    UIPanGestureRecognizer *panGesture;
    UIRotationGestureRecognizer *rotateGesture;
}
@property (weak, nonatomic) IBOutlet UIImageView *blackImageView;

@property (nonatomic) BOOL isCameraAvailable;

@property (nonatomic,strong) NPPhotoShootViewController *photoShootViewController;

@property (strong ,nonatomic) NSData *imageData;

@property (weak, nonatomic) IBOutlet UIView *tapPhotoView;

@property (weak, nonatomic) IBOutlet UITextField *posterTextField;

@property (weak, nonatomic) IBOutlet UIView *textFieldView;

@property (weak, nonatomic) IBOutlet UIView *posterTextView;

@property (weak, nonatomic) IBOutlet UILabel *posterTextLabel;

@property (weak, nonatomic) IBOutlet UIView *textEditingTab;
@property (weak, nonatomic) IBOutlet UIButton *textFontChooserButton;
@property (weak, nonatomic) IBOutlet UIButton *textColorChooserButton;
- (IBAction)chooseTextFont:(id)sender;
- (IBAction)chooseTextColor:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *textColorEditingTab;
- (IBAction)redButtonPressed:(id)sender;
- (IBAction)blackButtonPressed:(id)sender;
- (IBAction)blueButtonPressed:(id)sender;
- (IBAction)greenButtonPressed:(id)sender;
- (IBAction)violetButtonPressed:(id)sender;
- (IBAction)YellowButtonPressed:(id)sender;
- (IBAction)pinkButtonPressed:(id)sender;


@end
