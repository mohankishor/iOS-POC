//
//  NSWindow+Flipr.m
//  Media Browser
//
//  Created by Sandeep GS on 31/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "NSWindow+Flipr.h"
#import <QuartzCore/QuartzCore.h>
#include <sys/sysctl.h>

// This is the minimum duration of the animation in seconds. 0.75 seems best.
#define DURATION (0.75)

	// We subclass NSAnimation to maximize frame rate, instead of using progress marks.
@interface FliprAnimation : NSAnimation <NSAnimationDelegate> {
}
@end

@implementation FliprAnimation

	// We initialize the animation with some huge default value.
- (id)initWithAnimationCurve:(NSAnimationCurve)animationCurve 
{
	self = [super initWithDuration:1.0E8 animationCurve:animationCurve];
	return self;
}

	// We call this to start the animation just beyond the first frame.
- (void)startAtProgress:(NSAnimationProgress)value withDuration:(NSTimeInterval)duration 
{
	[super setCurrentProgress:value];
	[self setDuration:duration];
	[self startAnimation];
}

	// Called periodically by the NSAnimation timer.
- (void)setCurrentProgress:(NSAnimationProgress)progress 
{
	[super setCurrentProgress:progress];
	if ([self isAnimating]&&(progress<0.99)) {
		[[self delegate] display];		
	}
}

@end  
	// This is the flipping window's content view.
@interface FliprView : NSView <NSAnimationDelegate>
{
	NSRect originalRect;			// this rect covers the initial and final windows.
	NSWindow* initialWindow;
	NSWindow* finalWindow;
    CIImage* finalImage;			// this is the rendered image of the final window.
	CIFilter* transitionFilter;
	NSShadow* shadow;
	FliprAnimation* animation;
	float direction;				// this will be 1 (forward) or -1 (backward).
	float frameTime;				// time for last drawRect:
}
@end

@implementation FliprView

	// The designated initializer; will be called when the flipping window is set up.
- (id)initWithFrame:(NSRect)frame andOriginalRect:(NSRect)rect 
{
	self = [super initWithFrame:frame];
	if (self) {
		originalRect = rect;
		initialWindow = nil;
		finalWindow = nil;
		finalImage = nil;
		animation = nil;
		frameTime = 0.0;
				// Initialize the CoreImage filter.
		transitionFilter = [[CIFilter filterWithName:@"CIPerspectiveTransform"] retain];
		[transitionFilter setDefaults];
		shadow = [[NSShadow alloc] init];
		[shadow setShadowColor:[[NSColor shadowColor] colorWithAlphaComponent:0.6]];
		[shadow setShadowBlurRadius:5];
		[shadow setShadowOffset:NSMakeSize(0,-4)];
	}
	return self;
}

	// Notice that we don't retain the initial and final windows, so we don't release them here either.
- (void)dealloc 
{
	[finalImage release];
	[transitionFilter release];
	[shadow release];
	[animation release];
	[super dealloc];
}

	// This view, and the flipping window itself, are mostly transparent.
- (BOOL)isOpaque 
{
	return NO;
}

- (void)setInitialWindow:(NSWindow*)initial andFinalWindow:(NSWindow*)final forward:(BOOL)forward reflectInto:(NSImageView*)reflection 
{
	NSWindow* flipr = [NSWindow flippingWindow];
	if (flipr) {
		[NSCursor hide];
		initialWindow = initial;
		finalWindow = final;
		direction = forward?1:-1;

		NSRect frame = [initialWindow frame];
		NSRect flp = [flipr frame];
		flp.origin.x = frame.origin.x-originalRect.origin.x;
		flp.origin.y = frame.origin.y-originalRect.origin.y;
		flp.size.width += frame.size.width-originalRect.size.width;
		flp.size.height += frame.size.height-originalRect.size.height;
		[flipr setFrame:flp display:NO];
		originalRect.size = frame.size;
// Here we get an image of the initial window and make a CIImage from it.
		NSView* view = [[initialWindow contentView] superview];
		flp = [view bounds];
		NSBitmapImageRep* bitmap = [view bitmapImageRepForCachingDisplayInRect:flp];
		[view cacheDisplayInRect:flp toBitmapImageRep:bitmap];
		CIImage* initialImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
		if (reflection)
		{
			CIImage *im = initialImage;
			CIFilter *f;

			NSAffineTransform *t = [NSAffineTransform transform];
			[t translateXBy:flp.size.width yBy:0];
			[t scaleXBy:-1.0 yBy:1.0];
			
			f = [CIFilter filterWithName:@"CIAffineTransform"];
			[f setValue:t forKey:@"inputTransform"];
			[f setValue:im forKey:@"inputImage"];
			im = [f valueForKey:@"outputImage"];
			
			f = [CIFilter filterWithName:@"CIGaussianBlur"];
			[f setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputRadius"];
			[f setValue:im forKey:@"inputImage"];
			im = [f valueForKey:@"outputImage"];

			f = [CIFilter filterWithName:@"CIColorControls"];
			[f setValue:[NSNumber numberWithFloat:0.42] forKey:@"inputBrightness"];
			[f setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputSaturation"];
			[f setValue:[NSNumber numberWithFloat:0.15] forKey:@"inputContrast"];
			[f setValue:im forKey:@"inputImage"];
			im = [f valueForKey:@"outputImage"];

			f = [CIFilter filterWithName:@"CICrop"];
			[f setValue:[CIVector vectorWithX: 0
											Y: 0
											Z: flp.size.width
											W: flp.size.height] forKey:@"inputRectangle"];
			[f setValue:im forKey:@"inputImage"];
			im = [f valueForKey:@"outputImage"];

			NSCIImageRep *ir = [NSCIImageRep imageRepWithCIImage:im];
			NSImage* reflex = [[[NSImage alloc] initWithSize:flp.size] autorelease];
			[reflex addRepresentation:ir];
			[reflection setImage:reflex];
		}
		[transitionFilter setValue:initialImage forKey:@"inputImage"];
		[initialImage release];
		NSDisableScreenUpdates();
		[finalWindow setAlphaValue:0];
		[finalWindow makeKeyAndOrderFront:self];
		view = [[finalWindow contentView] superview];
		flp = [view bounds];
		bitmap = [view bitmapImageRepForCachingDisplayInRect:flp];
		[view cacheDisplayInRect:flp toBitmapImageRep:bitmap];
		finalImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
		[initialWindow orderOut:self];
		animation = [[FliprAnimation alloc] initWithAnimationCurve:NSAnimationEaseInOut];
		[animation setDelegate:self];
		[animation setCurrentProgress:0.0];
		[flipr orderWindow:NSWindowBelow relativeTo:[finalWindow windowNumber]];
		
		float duration = DURATION;
		if ([[NSApp currentEvent] modifierFlags]&NSShiftKeyMask) {
			duration *= 5.0;
		}
		float totalTime = frameTime;
		[animation setCurrentProgress:DURATION/15];
		NSEnableScreenUpdates();
		totalTime += frameTime;
		if ((duration-totalTime)<(frameTime*5)) {
			duration = totalTime+frameTime*5;
		}
		[animation startAtProgress:totalTime/duration withDuration:duration];
	}
}

	// This is called when the animation has finished.
- (void)animationDidEnd:(NSAnimation*)theAnimation 
{
	NSDisableScreenUpdates();
	[[NSWindow flippingWindow] orderOut:self];
	[finalWindow setAlphaValue:1.0];
	[finalWindow display];
	NSEnableScreenUpdates();

	[animation autorelease];
	animation = nil;
	initialWindow = nil;
	finalWindow = nil;
	[finalImage release];
	finalImage = nil;
	[NSCursor unhide];
}

	// Drawing the flipping animation.

- (void)drawRect:(NSRect)rect 
{
	if (!initialWindow) {
		return;
	}
	AbsoluteTime startTime = UpTime();

	float time = [animation currentValue];
	float radius = originalRect.size.width/2;
	float width = radius;
	float height = originalRect.size.height/2;
	float dist = 1600; // visual distance to flipping window, 1600 looks about right. You could try radius*5, too.
	float angle = direction*M_PI*time;
	float px1 = radius*cos(angle);
	float pz = radius*sin(angle);
	float pz1 = dist+pz;
	float px2 = -px1;
	float pz2 = dist-pz;
	if (time>0.5) {
		if (finalImage) {
			[transitionFilter setValue:finalImage forKey:@"inputImage"];
			[finalImage release];
			finalImage = nil;
		}
		float ss;
		ss = px1; px1 = px2; px2 = ss;
		ss = pz1; pz1 = pz2; pz2 = ss;
	}
	float sx1 = dist*px1/pz1;
	float sy1 = dist*height/pz1;
	float sx2 = dist*px2/pz2;
	float sy2 = dist*height/pz2;

	[transitionFilter setValue:[CIVector vectorWithX:width+sx1 Y:height+sy1] forKey:@"inputTopRight"];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx2 Y:height+sy2] forKey:@"inputTopLeft" ];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx1 Y:height-sy1] forKey:@"inputBottomRight"];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx2 Y:height-sy2] forKey:@"inputBottomLeft"];
	CIImage* outputCIImage = [transitionFilter valueForKey:@"outputImage"];

	[shadow set];
	NSRect bounds = [self bounds];
	[outputCIImage drawInRect:bounds fromRect:NSMakeRect(-originalRect.origin.x,-originalRect.origin.y,bounds.size.width,bounds.size.height) operation:NSCompositeSourceOver fraction:1.0];
// Calculate the time spent drawing
	frameTime = UnsignedWideToUInt64(AbsoluteDeltaToNanoseconds(UpTime(),startTime))/1E9;
}

@end

@implementation NSWindow (Flip)

// This function checks if the CPU can perform flipping. We assume all Intel Macs can do it,
// but PowerPC Macs need AltiVec.

static BOOL CPUIsSuitable() {
#ifdef __LITTLE_ENDIAN__
	return YES;
#else
	int altivec = 0;
	size_t length = sizeof(altivec);
	int error = sysctlbyname("hw.optional.altivec",&altivec,&length,NULL,0);
	return error?NO:altivec!=0;
#endif
}

	// There's only one flipping window!
static NSWindow* flippingWindow = nil;

+ (NSWindow*)flippingWindow 
{
	if (!flippingWindow) {
		if (CPUIsSuitable()) {
			NSRect frame = NSMakeRect(128,128,512,768);
			flippingWindow = [[NSWindow alloc] initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
			[flippingWindow setBackgroundColor:[NSColor clearColor]];
			[flippingWindow setOpaque:NO];	
			[flippingWindow setHasShadow:NO];
			[flippingWindow setOneShot:YES];
			frame.origin = NSZeroPoint;
			FliprView* view = [[[FliprView alloc] initWithFrame:frame andOriginalRect:NSInsetRect(frame,64,256)] autorelease];
			[view setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
			[flippingWindow setContentView:view];
		}
	}
	return flippingWindow;
}

	// Release the flipping window.
+ (void)releaseFlippingWindow 
{
	[flippingWindow autorelease];
	flippingWindow = nil;
}

	// This is called from outside to start the animation process.
- (void)flipToShowWindow:(NSWindow*)window forward:(BOOL)forward reflectInto:(NSImageView*)reflection 
{
	[window setFrame:[self frame] display:NO];
	NSWindow* flipr = [NSWindow flippingWindow];
	if (!flipr) {
		[window makeKeyAndOrderFront:self];
		[self orderOut:self];
		return;
	}
	[flipr setLevel:[self level]];
	[(FliprView*)[flipr contentView] setInitialWindow:self andFinalWindow:window forward:forward reflectInto:reflection];
}

@end
