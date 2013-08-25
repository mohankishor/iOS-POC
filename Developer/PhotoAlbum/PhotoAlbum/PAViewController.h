//
//  PAViewController.h
//  PhotoAlbum
//
//  Created by test on 27/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (weak, nonatomic) IBOutlet UIButton *PhotoButton;
- (IBAction)getPhoto:(id)sender;

@end
