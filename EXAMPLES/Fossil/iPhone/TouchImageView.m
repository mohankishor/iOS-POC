//
//  TouchImageView.m
//  MultiTouchDemo
//
//

#import "TouchImageView.h"
#include <execinfo.h>
#include <stdio.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>
@interface UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj;

@end

@interface TouchImageView (Private)

- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches;
- (void)updateOriginalTransformForTouches:(NSSet *)touches;

- (void)cacheBeginPointForTouches:(NSSet *)touches;
- (void)removeTouchesFromCache:(NSSet *)touches;

@end

@implementation UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj
{
    if ((void *)self < (void *)obj) {
        return NSOrderedAscending;
    } else if ((void *)self == (void *)obj) {
        return NSOrderedSame;
    } else {
        return NSOrderedDescending;
    }
}

@end

@implementation TouchImageView (Private)

- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches
{
    NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSInteger numTouches = [sortedTouches count];
    
	// No touches
	if (numTouches == 0) {
        return CGAffineTransformIdentity;
    }
	
	// Single touch
	if (numTouches == 1) {
        UITouch *touch = [sortedTouches objectAtIndex:0];
        CGPoint beginPoint = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
        CGPoint currentPoint = [touch locationInView:self.superview];
		return CGAffineTransformMakeTranslation(currentPoint.x - beginPoint.x, currentPoint.y - beginPoint.y);
	}
	
	// If two or more touches, go with the first two (sorted by address)
	UITouch *touch1 = [sortedTouches objectAtIndex:0];
	UITouch *touch2 = [sortedTouches objectAtIndex:1];
	
    CGPoint beginPoint1 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch1);
    CGPoint currentPoint1 = [touch1 locationInView:self.superview];
    CGPoint beginPoint2 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch2);
    CGPoint currentPoint2 = [touch2 locationInView:self.superview];
	
	double layerX = self.center.x;
	double layerY = self.center.y;
	
	double x1 = beginPoint1.x - layerX;
	double y1 = beginPoint1.y - layerY;
	double x2 = beginPoint2.x - layerX;
	double y2 = beginPoint2.y - layerY;
	double x3 = currentPoint1.x - layerX;
	double y3 = currentPoint1.y - layerY;
	double x4 = currentPoint2.x - layerX;
	double y4 = currentPoint2.y - layerY;
	
	// Solve the system:
	//   [a b t1, -b a t2, 0 0 1] * [x1, y1, 1] = [x3, y3, 1]
	//   [a b t1, -b a t2, 0 0 1] * [x2, y2, 1] = [x4, y4, 1]
	
	double D = (y1-y2)*(y1-y2) + (x1-x2)*(x1-x2);
	if (D < 0.1) {
        return CGAffineTransformMakeTranslation(x3-x1, y3-y1);
    }
	
	double a = (y1-y2)*(y3-y4) + (x1-x2)*(x3-x4);
	double b = (y1-y2)*(x3-x4) - (x1-x2)*(y3-y4);
	double tx = (y1*x2 - x1*y2)*(y4-y3) - (x1*x2 + y1*y2)*(x3+x4) + x3*(y2*y2 + x2*x2) + x4*(y1*y1 + x1*x1);
	double ty = (x1*x2 + y1*y2)*(-y4-y3) + (y1*x2 - x1*y2)*(x3-x4) + y3*(y2*y2 + x2*x2) + y4*(y1*y1 + x1*x1);
	
    return CGAffineTransformMake(a/D, -b/D, b/D, a/D, tx/D, ty/D);
}

- (void)updateOriginalTransformForTouches:(NSSet *)touches
{
    if ([touches count] > 0) {
        CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:touches];
        self.transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
        originalTransform = self.transform;
    }
}

- (void)cacheBeginPointForTouches:(NSSet *)touches
{
    if ([touches count] > 0) {
        for (UITouch *touch in touches) {
            CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
            if (point == NULL) {
                point = (CGPoint *)malloc(sizeof(CGPoint));
                CFDictionarySetValue(touchBeginPoints, touch, point);
            }
            *point = [touch locationInView:self.superview];
        }
    }
}

- (void)removeTouchesFromCache:(NSSet *)touches
{
    for (UITouch *touch in touches) {
        CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
        if (point != NULL) {
            free((void *)CFDictionaryGetValue(touchBeginPoints, touch));
            CFDictionaryRemoveValue(touchBeginPoints, touch);
        }
    }
}

@end

@implementation TouchImageView

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame] == nil) {
        return nil;
    }

    originalTransform = CGAffineTransformIdentity;
	originalTransform = CGAffineTransformTranslate(originalTransform,160-100,240-100);
	self.transform = originalTransform;
    touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.exclusiveTouch = YES;

    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {
        [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }
    [self cacheBeginPointForTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:[event touchesForView:self]];
    self.transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            [self.superview bringSubviewToFront:self];
        }
    }

    [self updateOriginalTransformForTouches:[event touchesForView:self]];
    [self removeTouchesFromCache:touches];

    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


-(UIImage*) getImage:(UIImage*) camImage
{	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat width = 320;
	CGFloat height = 480-54;
	NSUInteger bitsPerComponent = 5;
	NSUInteger bytesPerRow = 0;
	
	CGContextRef context = CGBitmapContextCreate (nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaNoneSkipFirst);
	CGContextSaveGState(context); 
	CGContextRotateCTM(context,  - M_PI / 2);  
	
	CGContextTranslateCTM(context, -height, 0);
	
	CGContextDrawImage(context, CGRectMake(0,0,height,width), camImage.CGImage); //width height rotated by 90
	
	CGContextRestoreGState(context); 
	
	CGContextSaveGState(context);
	
	
	CGContextSetFillColorWithColor(context,[[UIColor redColor] CGColor]);
	CGRect watchRect = CGRectMake(0,0,200,200);
	
	NSLog(@"watchRect: %f %f %f %f",watchRect.origin.x, watchRect.origin.y, watchRect.size.width, watchRect.size.height);
	//NSLog(@"transformedRect: %f %f %f %f",transformedRect.origin.x, transformedRect.origin.y, transformedRect.size.width, transformedRect.size.height);
	//NSLog(@"transfrom:%f %f %f %f %f %f",originalTransform.a,originalTransform.b,originalTransform.c,originalTransform.d,originalTransform.tx,originalTransform.ty);
	
	double a = atan(originalTransform.b/originalTransform.a);
	double sx = originalTransform.a/cos(a);
	NSLog(@"scale = %f angle=%f",sx,a);
	
	CGContextTranslateCTM(context, 
						  originalTransform.tx-(watchRect.size.width*(sx-1)/2),
						  height-originalTransform.ty-(watchRect.size.height) -(watchRect.size.height*(sx-1)/2) );
	
	CGContextScaleCTM(context,sx,sx);
	CGContextRotateCTM(context,-a);
	
	
	CGAffineTransform identity=CGAffineTransformIdentity;
	identity = CGAffineTransformRotate(identity,a);
	
	CGRect rectTransformed =  CGRectApplyAffineTransform(watchRect,identity);
	NSLog(@"rectTransformed: %f %f %f %f",rectTransformed.origin.x, rectTransformed.origin.y, rectTransformed.size.width, rectTransformed.size.height);
	
	float widDiff = rectTransformed.size.width - 200;
	
	rectTransformed.size.width = 200;
	rectTransformed.size.height = 200;
	
	rectTransformed.origin.x += widDiff/2;
	rectTransformed.origin.y += widDiff/2;
	
	
	//CGContextFillRect(context,rectTransformed);
	CGContextDrawImage(context, rectTransformed,self.image.CGImage);
	
	
	CGContextRestoreGState(context);
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage *ret = [[UIImage alloc] initWithCGImage:imageRef];
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	CGImageRelease(imageRef);
	
	return [ret autorelease];
}

- (void)dealloc
{
    CFRelease(touchBeginPoints);
    
    [super dealloc];
}

@end
