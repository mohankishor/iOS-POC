//
//  PhotoAppViewController.h
//  PhotoApp
//
//  Created by Brandon Trebitowski on 7/28/09.
//  Copyright RightSprite 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAppViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;

-(IBAction) getPhoto:(id) sender;

@end

