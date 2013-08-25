//
//  NPPhotoShootViewController.h
//  NDTVPhotosAppR&D
//
//  Created by test on 04/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@protocol PhotoShootViewControllerDelegate <NSObject>

- (void) sendImageSelected:(NSData *) image;

@end

@interface NPPhotoShootViewController : UIViewController<UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSString *selectedOption;

@property (retain,nonatomic) id <PhotoShootViewControllerDelegate> imagedelegate;

@property (nonatomic) BOOL newMedia;

- (void)useCamera;

- (void)useCameraAlbum;

@end
