//
//  ZoomedImageView.h
//  FlickrImageDisplay
//
//  Created by test on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomedImageView : UIView
{
    UIImageView *fullsizeImage;
}

- (id)initWithURL:(NSURL *)url;
@end
