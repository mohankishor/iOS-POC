//
//  CustomAlertView.h
//  TryOnWatch
//
//  Created by Sanath on 27/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomAlertView : UIAlertView <UIAlertViewDelegate>
{
	id mDelegate;
}

@property(nonatomic, assign) id delegate;

- (void) addButtonWithTitle:(NSString *)title withFrame:(CGRect) theRect andWithButtonIndex:(NSInteger) buttonIndex;

-(void) setBackgroundColor:(UIColor *) background withStrokeColor:(UIColor *) stroke;

@end