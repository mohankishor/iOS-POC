//
//  PickImageAppDelegate.h
//  PickImage
//
//  Created by test on 27/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickImageAppDelegate :
NSObject <UIApplicationDelegate,
UIImagePickerControllerDelegate>
{
    UIWindow* window;
    UIImagePickerController* imagePickerController;
    UIImageView* imageView;
}

@property (nonatomic, retain) UIWindow *window;

- (void)applicationDidFinishLaunching:(UIApplication *)application;
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
@end

