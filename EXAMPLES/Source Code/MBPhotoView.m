//
//  MBPhotoView.m
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBPhotoView.h"
#import "MBPhotoController.h"

@interface MBPhotoView (photoview)
	- (BOOL) isPhotoSelectedAtIndex			: (NSUInteger)photoIndex;
	- (NSSize) scaledPhotoSizeForPhotoSize	: (NSSize)size;							
	- (NSRect) rectCenteredInRectWithSize	: (NSRect)rect withSize: (NSSize)size;
	- (NSRect) gridRectForIndex				: (unsigned)photoIndex;
	- (NSRect) photoRectForIndex			: (unsigned)photoIndex;
	- (NSRect) titleRectForPhotoAtIndex		: (unsigned)photoIndex photoRect:(NSRect)rect;
	- (NSUInteger) photoIndexForPoint		: (NSPoint)point;
	- (NSImage*) imageForDraggingFromMouseDownPoint;
	- (NSRange) photoIndexRangeForRect:(NSRect)rect;			// display photos only in visible rect area
@end

@implementation MBPhotoView (photoview)
- (NSRange)photoIndexRangeForRect:(NSRect)rect
{
	if (!mPhotosCount)
		return NSMakeRange(NSNotFound, 0);
	
    unsigned start = [self photoIndexForPoint:rect.origin];
	if (start >= mPhotosCount)
		return NSMakeRange(NSNotFound, 0);
	
	unsigned finish = [self photoIndexForPoint:NSMakePoint(NSMaxX(rect)-1, NSMaxY(rect)-1)];
	if (finish >= mPhotosCount)
		finish = mPhotosCount - 1;
    
	return NSMakeRange(start, (finish + 1) - start);
}


	//Check whether photo is selected at a specified index
- (BOOL) isPhotoSelectedAtIndex: (NSUInteger)photoIndex
{
	if([mPhotoSelectionIndexes containsIndex:photoIndex])
		return YES;
	else 
		return NO;
}

	//Compute aspect ratio of a photo when resized
- (NSSize) scaledPhotoSizeForPhotoSize: (NSSize)size
{
	float longSide = size.width;
	if (longSide < size.height)
        longSide = size.height;
    
    float scale = mPhotoSize.width / longSide;
    
    NSSize scaledSize = size;
	if (scale < 1.0)
	{
		scaledSize.width = size.width * scale;
		scaledSize.height = size.height * scale;
    }
    return scaledSize;	
}

	//Compute rectangle for resized photo
- (NSRect) rectCenteredInRectWithSize: (NSRect)rect withSize: (NSSize)size
{
	float x = NSMidX(rect) - (size.width / 2);
	float y = NSMidY(rect) - (size.height / 2);
    
    return NSMakeRect(x, y, size.width, size.height);
}

	//finding drawing rectangle for photo index 
- (NSRect)photoRectForIndex:(unsigned)photoIndex
{
	NSImage *photo = [NSImage imageNamed:@""];
	if (mPhotoColumns == 0) return NSZeroRect;
	unsigned row = photoIndex / mPhotoColumns;
	unsigned column = photoIndex % mPhotoColumns;
	float x = column * (mPhotoSize.width + mPhotoHorizontalSpacing) + mPhotoHorizontalSpacing;
	float y = row * (mPhotoSize.height + mPhotoVerticalSpacing);
	
	NSRect photoRect = NSMakeRect(x, y, mPhotoSize.width, mPhotoSize.height);
	
	if (mPhotoViewDataSource && [mPhotoViewDataSource respondsToSelector:@selector(photoAtIndex:)]){
		photo = [mPhotoViewDataSource photoAtIndex:photoIndex];
	}
	NSSize scaledSize = [self scaledPhotoSizeForPhotoSize:[photo size]];
	photoRect = [self rectCenteredInRectWithSize:photoRect withSize:scaledSize];
	photoRect = [self centerScanRect:photoRect];
	
	return photoRect;
}

- (NSRect) gridRectForIndex:(unsigned)photoIndex
{
	if (mPhotoColumns == 0) return NSZeroRect;
	unsigned row = photoIndex / mPhotoColumns;
	unsigned column = photoIndex % mPhotoColumns;
	float x = column * (mPhotoSize.width + mPhotoHorizontalSpacing) + mPhotoHorizontalSpacing;
	float y = row * (mPhotoSize.width + mPhotoVerticalSpacing);
	
	return NSMakeRect(x, y, mPhotoSize.width, mPhotoSize.height + mPhotoVerticalSpacing);	
}

- (NSRect) titleRectForPhotoAtIndex:(unsigned)photoIndex photoRect:(NSRect)photoRect 
{
	if (mPhotoViewDataSource && [mPhotoViewDataSource respondsToSelector:@selector(photoTitleAtIndex:)]) {
		mTitleSize = [[mPhotoViewDataSource photoTitleAtIndex:photoIndex] sizeWithAttributes:mPhotoTitleAttributes];
	}
	
	NSDivideRect(mGridRect, &mTitleRect, &mGridRect, mTitleSize.height+ 6.0f, NSMaxYEdge);
	if (NSWidth(mTitleRect) > 20)
		mTitleRect = NSInsetRect(mTitleRect, 6, 0);
	return mTitleRect;
}

- (NSUInteger)photoIndexForPoint:(NSPoint)point
{
	unsigned column = point.x / (mPhotoSize.width + mPhotoHorizontalSpacing);
	unsigned row = point.y / (mPhotoSize.height + mPhotoVerticalSpacing);
	
	NSUInteger photoIndex = ((row * mPhotoColumns) + column);
	return photoIndex;
}

- (NSImage*) imageForDraggingFromMouseDownPoint
{
	NSImage *dragImage = nil;
	NSImage *clickedImage = [NSImage imageNamed:@""];
	unsigned clickedIndex = [self photoIndexForPoint:mouseDownPoint];
	clickedIndex = MIN(clickedIndex, mPhotosCount-1);
	
	if (mPhotoViewDataSource && [mPhotoViewDataSource respondsToSelector:@selector(photoAtIndex:)]){
		clickedImage = [mPhotoViewDataSource photoAtIndex:clickedIndex];
	}
	NSImage *badgeImage = [NSImage imageNamed:@"dragBadge.tiff"];
	NSSize scaledSize = [self scaledPhotoSizeForPhotoSize:[clickedImage size]];
	
	NSMutableDictionary *countAttributes = [[NSMutableDictionary alloc] init];
	[countAttributes setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	[countAttributes setObject:[NSFont fontWithName:@"Helvetica Bold" size:16] forKey:NSFontAttributeName];
	
	NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc] init];
	[titleAttributes setObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
	[titleAttributes setObject:[NSFont labelFontOfSize:[NSFont labelFontSize]] forKey:NSFontAttributeName];
	
	NSAttributedString *badgeString = [[NSAttributedString alloc] initWithString:[[NSNumber numberWithInt:[mPhotoSelectionIndexes count]] stringValue] attributes:countAttributes];
	NSSize countSize = [badgeString size];
	
		// to draw title of a photo
	dragImage = [[[NSImage alloc] initWithSize:scaledSize] autorelease];		// creating an empty image
	
	[dragImage lockFocus];
	[clickedImage setFlipped:NO];
	[clickedImage drawInRect:NSMakeRect(0,0,scaledSize.width,scaledSize.height) fromRect:NSMakeRect(0,0,[clickedImage size].width,[clickedImage size].height)  operation:NSCompositeSourceOver fraction:1];
	[dragImage unlockFocus];
	
	if ([mPhotoSelectionIndexes count] > 1) {
		float badgeMargin = 3.0;				
		float badgePadding = 0.3;	
		float badgeDiameter = countSize.width;
		
		if (countSize.height > badgeDiameter){
			badgeDiameter = countSize.height;	
		} 
		badgeDiameter += (badgeDiameter * badgePadding);
		
		NSRect badgeRect = NSMakeRect(scaledSize.width - badgeDiameter - badgeMargin, scaledSize.height - badgeDiameter - badgeMargin, badgeDiameter, badgeDiameter); 
		
		[dragImage lockFocus];			// lock the image to draw something on it
		
		[badgeImage drawInRect:badgeRect fromRect:NSMakeRect(0,0,[badgeImage size].width,[badgeImage size].height) operation:NSCompositeSourceOver fraction:1];
		NSPoint stringPoint;
		stringPoint.x = NSMinX(badgeRect) + ((badgeDiameter - countSize.width) / 2);
		stringPoint.y = NSMinY(badgeRect) + ((badgeDiameter - countSize.height) / 2);
		[badgeString drawAtPoint:stringPoint];				// draw the string							
		
		[dragImage unlockFocus];		// unlock the image after drawing
	}
	[badgeString release];
	[countAttributes release];
	[titleAttributes release];
	
	return dragImage;	
}
@end

@implementation MBPhotoView

@synthesize mPhotoSize;
@synthesize mPhotoHorizontalSpacing,mPhotoVerticalSpacing;
@synthesize mPhotoColumns,mPhotoRows;
@synthesize mPhotoSelectionIndexes;
@synthesize mPhotoViewDataSource;
@synthesize mPhotoViewDelegate;

- (id) initWithFrame: (NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
		mPhotoSelectionIndexes = [[NSMutableIndexSet alloc]init];
		mPhotoSize = NSMakeSize(80, 80);
		mPhotoHorizontalSpacing = 0;
		mPhotoVerticalSpacing = 30;
		mPhotoCaptionState = YES;

		NSMutableParagraphStyle *aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
		[aParagraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
		[aParagraphStyle setAlignment:NSCenterTextAlignment];
		
			// used to set attributes for photo title
		mPhotoTitleAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
													[NSColor darkGrayColor],NSForegroundColorAttributeName,
													[NSFont labelFontOfSize:[NSFont labelFontSize]], NSFontAttributeName,
													 aParagraphStyle, NSParagraphStyleAttributeName,
													 nil];			
		[aParagraphStyle release];
    }
    return self;
}

- (BOOL) isFlipped
{
	return YES;
}

- (void) drawRect: (NSRect)dirtyRect 
{
	[self removeAllToolTips];
	[self isFlipped];
	[[NSColor whiteColor]set];
	NSRectFill([self bounds]);
	
	if (mPhotoViewDataSource && [mPhotoViewDataSource respondsToSelector:@selector(numberOfPhotosInArray)]){
		mPhotosCount = [mPhotoViewDataSource numberOfPhotosInArray];	// get the number of photos
	}
	if (mPhotoViewDataSource && [mPhotoViewDataSource respondsToSelector:@selector(upgradeFrameContentAndSize)]){
		[mPhotoViewDataSource upgradeFrameContentAndSize];				// set the view frame size and draw content 
	}
	
	NSRange rangeToDraw = [self photoIndexRangeForRect:[self visibleRect]]; 	
	NSUInteger firstIndex;
	NSUInteger lastIndex = rangeToDraw.location + rangeToDraw.length;
	NSString	*photoTitle = @"";
	NSImage		*photo = [NSImage imageNamed:@""];
	
	if(mPhotosCount !=0){
		for(firstIndex = rangeToDraw.location; firstIndex < lastIndex; firstIndex++){
			mPhotoRect = NSZeroRect;
			mTitleRect = NSZeroRect;
			mGridRect = NSZeroRect;
			
			if (mPhotoViewDataSource && [mPhotoViewDataSource respondsToSelector:@selector(photoAtIndex:)]){
				photo = [mPhotoViewDataSource photoAtIndex:firstIndex];
			}
			
			mPhotoRect = [self photoRectForIndex:firstIndex];
			mGridRect = [self gridRectForIndex:firstIndex];
			[photo setFlipped:YES];
			if (mPhotoViewDataSource && [mPhotoViewDataSource respondsToSelector:@selector(photoTitleAtIndex:)]){
				photoTitle = [mPhotoViewDataSource photoTitleAtIndex:firstIndex];
			}
			mTitleRect = [self titleRectForPhotoAtIndex:firstIndex photoRect:mPhotoRect];
			BOOL isSelected = [self isPhotoSelectedAtIndex:firstIndex];
			NSSize imageSize = [photo size];
			NSRect imageRect = NSMakeRect(0, 0, imageSize.width, imageSize.height);

				//Draw things when photo is selected
			if(isSelected){
				[[NSColor colorWithCalibratedWhite:0.1 alpha:0.2]set];
				NSRect selectionRect = NSMakeRect(mGridRect.origin.x - 5, mGridRect.origin.y, mGridRect.size.width + 10, mGridRect.size.height-5);
				NSBezierPath *ovalPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:8.0 yRadius:8.0];
				[ovalPath fill];

				if (mPhotoCaptionState) {
					float x;
					float y = mTitleRect.origin.y;
					float height = mTitleSize.height;
					float width;
					if (mTitleSize.width > mTitleRect.size.width) {
						x = mTitleRect.origin.x;
						width = mTitleRect.size.width;		
					}
					else {
						x = NSMidX(mTitleRect) - (mTitleSize.width+10)/2;
						width = mTitleSize.width+10;
					}
					
					[[NSColor colorWithCalibratedRed:0.206 green:0.683 blue:0.219 alpha:0.9]set];
					NSRect titleFillRect = NSMakeRect(x,y, width, height);
					NSBezierPath *ovalPath= [NSBezierPath bezierPathWithRoundedRect:titleFillRect xRadius:5.0 yRadius:5.0];
					[ovalPath fill];
				}
				[[NSColor blackColor]set];
				[NSBezierPath setDefaultLineWidth:1.0];
				[NSBezierPath strokeRect:mPhotoRect];
				
				[mPhotoTitleAttributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
				[mPhotoTitleAttributes setValue:[NSFont boldSystemFontOfSize:10] forKey:NSFontAttributeName];
				[photoTitle drawInRect:mTitleRect withAttributes:mPhotoTitleAttributes];
			} 

				// register the tooltip area
			[self addToolTipRect:mPhotoRect owner:self userData:nil];

			[photo drawInRect:mPhotoRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1];	
				//Draw title
			if(mPhotoCaptionState && !isSelected){
				[mPhotoTitleAttributes setValue:[NSColor darkGrayColor] forKey:NSForegroundColorAttributeName];
				[mPhotoTitleAttributes setValue:[NSFont labelFontOfSize:[NSFont labelFontSize]] forKey:NSFontAttributeName];
				[photoTitle drawInRect:mTitleRect withAttributes:mPhotoTitleAttributes];
			}
		}								

		if(mDragInitiated){
			NSBezierPath *windowPath;
			windowPath = [NSBezierPath bezierPathWithRect:mSelectionRect];
			[windowPath setLineWidth:0.3];
			[[NSColor colorWithCalibratedRed:1 green:0 blue:0 alpha:0.1]set];
			[NSBezierPath fillRect:mSelectionRect];
			[[NSColor yellowColor]set];
			[windowPath stroke];		
		}
	}
}

#pragma mark tooltip Method
- (NSString *)view:(NSView *)view stringForToolTip:(NSToolTipTag)tag point:(NSPoint)point userData:(void *)userData
{
	unsigned photoIndex = [self photoIndexForPoint:point];
	if (photoIndex < mPhotosCount){
		return [mPhotoViewDataSource photoTitleAtIndex:photoIndex];
	}
	return nil;
}
#pragma mark -

#pragma mark instance methods
- (void) captionsForPhotos:(NSUInteger)state
{
	mPhotoCaptionState = state;
	[self setNeedsDisplay:YES];
}
#pragma mark -

#pragma mark Responder Methods : (Mouse and keyboard)
- (void) mouseDown: (NSEvent *)event
{
	NSRect photoRect = NSZeroRect;
	mouseDownPoint = [self convertPoint:[event locationInWindow] fromView:nil];
	NSUInteger clickedIndex = [self photoIndexForPoint:mouseDownPoint];

	if(clickedIndex!=-1 && clickedIndex < mPhotosCount){
		photoRect = [self photoRectForIndex:clickedIndex];
	}
	unsigned int flags = [event modifierFlags];
	BOOL photoHit = NSPointInRect(mouseDownPoint, photoRect);
	
	if(photoHit){
		[self scrollRectToVisible:[self photoRectForIndex:clickedIndex]];
		if (flags & NSCommandKeyMask) {
				// Flip current image selection state.
			if ([mPhotoSelectionIndexes containsIndex:clickedIndex]) {
				[mPhotoSelectionIndexes removeIndex:clickedIndex];
			} else {
				[mPhotoSelectionIndexes addIndex:clickedIndex];
			}
		} else {
			if (flags & NSShiftKeyMask) {
					// Add range to selection.
				if ([mPhotoSelectionIndexes count] == 0) {
					[mPhotoSelectionIndexes addIndex:clickedIndex];
				} else {
					unsigned int origin = (clickedIndex < [mPhotoSelectionIndexes lastIndex]) ? clickedIndex :[mPhotoSelectionIndexes lastIndex];
					unsigned int length = (clickedIndex < [mPhotoSelectionIndexes lastIndex]) ? [mPhotoSelectionIndexes lastIndex] - clickedIndex : clickedIndex - [mPhotoSelectionIndexes lastIndex];
					
					length++;
					[mPhotoSelectionIndexes addIndexesInRange:NSMakeRange(origin, length)];
				}
			} else {
				if (![self isPhotoSelectedAtIndex:clickedIndex]) {
						// Photo selection without modifiers.
					[mPhotoSelectionIndexes removeAllIndexes];
					[mPhotoSelectionIndexes addIndex:clickedIndex];
					[self setNeedsDisplay:YES];
				}
			}
		}
	mDragPhoto = YES;
	}
	else {
		if ((flags & NSShiftKeyMask) == 0) {
			[mPhotoSelectionIndexes removeAllIndexes];
			[self setNeedsDisplay:YES];
		}
		mDragPhoto = NO;
	}
	
		// calls when mouse is clicked twice for opening photo or photos based on number of photos selected
	if([event clickCount] > 1)
	{
		if([mPhotoSelectionIndexes count] == 1){
		if (mPhotoViewDelegate && [mPhotoViewDelegate respondsToSelector:@selector(openPhotoAtIndex:)]){
			[mPhotoViewDelegate openPhotoAtIndex:clickedIndex];
		}
		}
		else {
			NSUInteger photoIndex = [mPhotoSelectionIndexes firstIndex];
			while (photoIndex != NSNotFound) {
			if (mPhotoViewDelegate && [mPhotoViewDelegate respondsToSelector:@selector(openPhotoAtIndex:)]){
				[mPhotoViewDelegate openPhotoAtIndex:photoIndex];		
			}
				photoIndex = [mPhotoSelectionIndexes indexGreaterThanIndex:photoIndex];
			}
		}
	}
}

- (void) mouseDragged:(NSEvent *)theEvent
{
	mDragInitiated = YES;
	NSPoint loc = [ self convertPoint:[theEvent locationInWindow] fromView:nil];
	mouseCurrentPoint = loc;
	NSRect startRect;
	
	if(!mDragPhoto){
		startRect.origin.x = MIN(mouseDownPoint.x, mouseCurrentPoint.x);
		startRect.origin.y = MIN(mouseDownPoint.y, mouseCurrentPoint.y);
		startRect.size.width = ABS(mouseDownPoint.x - mouseCurrentPoint.x);
		startRect.size.height = ABS(mouseDownPoint.y - mouseCurrentPoint.y);
		mSelectionRect = startRect;		
		
			// call autoscroll while dragging outside of contentview
		if (mAutoScrollTimer == nil) {
			mAutoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(autoscroll) userInfo:nil repeats:YES];
		}		
		
		NSRange visiblePhotoRange = [self photoIndexRangeForRect:[self visibleRect]];
		NSUInteger firstIndex;
		NSUInteger lastIndex = visiblePhotoRange.location + visiblePhotoRange.length;
		
		for(firstIndex = visiblePhotoRange.location; firstIndex < lastIndex; firstIndex++){
			NSRect photoRect = [self photoRectForIndex:firstIndex];
			if(NSIntersectsRect(mSelectionRect, photoRect)){
				[mPhotoSelectionIndexes addIndex:firstIndex];
			}
			else{
				[mPhotoSelectionIndexes removeIndex:firstIndex];
			}
		}			
	}
	
	if(mDragPhoto)
	{
		NSImage *dragImage = [self imageForDraggingFromMouseDownPoint];		
		NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
		[pboard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType]  owner:self];
		if (mPhotoViewDelegate && [mPhotoViewDelegate respondsToSelector:@selector(photoView:fillPasteboardForDrag:)]) {
			[mPhotoViewDelegate photoView:self fillPasteboardForDrag:pboard];
		}
			// perform the drag operation
		[self dragImage:dragImage at:mouseDownPoint offset:NSZeroSize event:theEvent pasteboard:pboard source:self slideBack:YES];
	}
	[self setNeedsDisplay:YES];
}	

- (void) mouseUp:(NSEvent *)theEvent
{
	NSRect endRect;
	endRect.origin.x = MIN(mouseDownPoint.x, mouseCurrentPoint.x);
	endRect.origin.y = MIN(mouseDownPoint.y, mouseCurrentPoint.y);
	endRect.size.width = ABS(mouseDownPoint.x - mouseCurrentPoint.x);
	endRect.size.height = ABS(mouseDownPoint.y - mouseCurrentPoint.y);
	
	if (mAutoScrollTimer != nil) {
		[mAutoScrollTimer invalidate];
		mAutoScrollTimer = nil;
	}
	mDragInitiated = NO;
	[self setNeedsDisplay:YES];
	mSelectionRect = NSZeroRect;
}

- (void) autoscroll
{
	NSView *myClipView = [self superview];
	if ([myClipView isKindOfClass:[NSClipView class]])
	{
		NSPoint windowBasedPoint = [[NSApp currentEvent] locationInWindow];
		NSPoint clipViewBasedPoint = [myClipView convertPoint:windowBasedPoint fromView:nil];
		if (NSPointInRect(clipViewBasedPoint, [myClipView bounds]) == NO)
		{		
			[super autoscroll:[NSApp currentEvent]];
			
				// Calling mouseDragged: forces the selection to update, otherwise not happen while autoscrolling
			[self mouseDragged:[NSApp currentEvent]];
		}
	}
}

- (BOOL) acceptsFirstResponder
{
	return (mPhotosCount>0);
}

- (BOOL) resignFirstResponder
{
	return YES;
}

	// calls when any key is pressed
- (void) keyDown:(NSEvent *)theEvent
{
	NSString *chars = [theEvent characters];
	unichar keyChar ='\0';
	NSUInteger photoIndex;
	
	if ([chars length] == 1)
	{
		keyChar = [chars characterAtIndex:0];
		switch (keyChar)
		{
			case ' ':
					photoIndex = [mPhotoSelectionIndexes firstIndex];				
					while (photoIndex != NSNotFound) {
						if (mPhotoViewDelegate && [mPhotoViewDelegate respondsToSelector:@selector(quickLookPhotoAtIndex:)]) {
							[mPhotoViewDelegate quickLookPhotoAtIndex:photoIndex];		
						}
						photoIndex = [mPhotoSelectionIndexes indexGreaterThanIndex:photoIndex];
					}
					return;	
			case NSHomeFunctionKey:
			{
				[self scrollRectToVisible:[self gridRectForIndex:0]];
				return;
			}
			case NSEndFunctionKey:
			{
				[self scrollRectToVisible:[self gridRectForIndex:mPhotosCount-1]];
				return;
			}
			case NSTabCharacter:	
			{
				[self resignFirstResponder];		
			}
		}
	}
	else if (keyChar == NSEnterCharacter){
		[super keyDown:theEvent];
		return;
	}
	[self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

	//keyboard command+a (select all) event
- (void)selectAll:(id)sender
{
	if(mPhotosCount > 0){
		NSIndexSet *allIndexes = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, mPhotosCount)];
		mPhotoSelectionIndexes = [allIndexes mutableCopy];
        [allIndexes release];
	}
	[self setNeedsDisplay:YES];
}

	//keyboard left arrow event
- (void)moveLeft:(id)sender
{
	NSMutableIndexSet	*newIndexes = [[NSMutableIndexSet alloc]init];
		
	if(([mPhotoSelectionIndexes count] > 0) && (![mPhotoSelectionIndexes containsIndex:0])){
		NSUInteger index = [mPhotoSelectionIndexes firstIndex];
		[newIndexes addIndex:index-1];
	}
	else {
		if(([mPhotoSelectionIndexes count] == 0) || ([mPhotoSelectionIndexes count] == mPhotosCount) && (mPhotosCount > 0)){
			[newIndexes addIndex:mPhotosCount - 1];
		}
	}
	
	if([newIndexes count] > 0){
		mPhotoSelectionIndexes = [newIndexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[newIndexes firstIndex]]];
	}
	
	[self setNeedsDisplay:YES];
	[newIndexes release];
}

	//keyboard left arrow and shift keys event
- (void)moveLeftAndModifySelection:(id)sender
{
    NSIndexSet *indexes = [mPhotoSelectionIndexes retain];
	if (([indexes count] > 0) && (![indexes containsIndex:0])) {
		NSMutableIndexSet * newIndexes = [indexes mutableCopy];
        [newIndexes addIndex:([newIndexes firstIndex] - 1)];
		mPhotoSelectionIndexes = [newIndexes retain];
		
		[self scrollRectToVisible:[self gridRectForIndex:[newIndexes firstIndex]]];
		[self setNeedsDisplay:YES];
        [newIndexes release];
	}
	[indexes release];
}

	//keyboard right arrow event
- (void)moveRight:(id)sender
{
	NSMutableIndexSet	*newIndexes = [[NSMutableIndexSet alloc]init];
	
	if(([mPhotoSelectionIndexes count] > 0) && (![mPhotoSelectionIndexes containsIndex:mPhotosCount-1])){
		NSUInteger index = [mPhotoSelectionIndexes lastIndex];
		[newIndexes addIndex:index+1];
	}
	else {
		if(([mPhotoSelectionIndexes count] == 0) || ([mPhotoSelectionIndexes count] == mPhotosCount) && (mPhotosCount > 0)){
			[newIndexes addIndex:0];
		}
	}
	
	if([newIndexes count] > 0){
		mPhotoSelectionIndexes = [newIndexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[newIndexes lastIndex]]];
	}
	
	[self setNeedsDisplay:YES];
	[newIndexes release];
}

	//keyboard right arrow and shift keys event
- (void)moveRightAndModifySelection:(id)sender
{
    NSIndexSet *indexes = [mPhotoSelectionIndexes retain];
	if (([indexes count] > 0) && (![indexes containsIndex:mPhotosCount-1])) {
		NSMutableIndexSet * newIndexes = [indexes mutableCopy];
        [newIndexes addIndex:([newIndexes lastIndex] + 1)];
		mPhotoSelectionIndexes = [newIndexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[newIndexes lastIndex]]];
		
		[self setNeedsDisplay:YES];
        [newIndexes release];
	}
	[indexes release];
}

	//keyboard down arrow event
- (void)moveDown:(id)sender
{
	NSMutableIndexSet *newIndexes = [[NSMutableIndexSet alloc]init];
	unsigned int destIndex = [mPhotoSelectionIndexes lastIndex] + mPhotoColumns;
	unsigned int lastIndex = mPhotosCount - 1;
	
	
	if(([mPhotoSelectionIndexes count] > 0) && (destIndex <=lastIndex)){
		[newIndexes addIndex:destIndex];
	}
	else {
		if(([mPhotoSelectionIndexes count] == 0) || ([mPhotoSelectionIndexes count] == mPhotosCount) && (mPhotosCount > 0)){
			[newIndexes addIndex:0];
		}
	}
	
	if([newIndexes count] > 0){
		mPhotoSelectionIndexes = [newIndexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[newIndexes lastIndex]]];
	}
	
	[self setNeedsDisplay:YES];
	[newIndexes release];
}

	//keyboard down arrow and shift keys event
- (void)moveDownAndModifySelection:(id)sender
{
    NSIndexSet *indexes = [mPhotoSelectionIndexes retain];
	unsigned int destIndex = [mPhotoSelectionIndexes lastIndex] + mPhotoColumns;
	unsigned int lastIndex = mPhotosCount - 1;
	
	if (([indexes count] > 0) && (destIndex <= lastIndex)) {
		NSMutableIndexSet * newIndexes = [indexes mutableCopy];
		NSRange addRange;
		
		addRange.location = [indexes lastIndex] + 1;
		addRange.length = mPhotoColumns;
		
        [newIndexes addIndexesInRange:addRange];
		mPhotoSelectionIndexes = [newIndexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[newIndexes lastIndex]]];
		
		[self setNeedsDisplay:YES];
        [newIndexes release];
	}
	[indexes release];
}

	//keyboard up arrow event
- (void)moveUp:(id)sender
{
	NSMutableIndexSet *newIndexes = [[NSMutableIndexSet alloc]init];
	
	if(([mPhotoSelectionIndexes count] > 0) && [mPhotoSelectionIndexes firstIndex] >= mPhotoColumns){
		[newIndexes addIndex:[mPhotoSelectionIndexes firstIndex] - mPhotoColumns];
	}
	else {
		if(([mPhotoSelectionIndexes count] == 0) || ([mPhotoSelectionIndexes count] == mPhotosCount) && (mPhotosCount > 0)){
			[newIndexes addIndex:mPhotosCount - 1];
		}
	}
	
	if([newIndexes count] > 0){
		mPhotoSelectionIndexes = [newIndexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[newIndexes firstIndex]]];
	}
	
	[self setNeedsDisplay:YES];
	[newIndexes release];
}

	//keyboard up arrow and shift keys event
- (void)moveUpAndModifySelection:(id)sender
{
	NSMutableIndexSet *indexes = [mPhotoSelectionIndexes mutableCopy];
	
	if (([indexes count] > 0) && ([indexes firstIndex] >= mPhotoColumns)) {
		[indexes addIndexesInRange:NSMakeRange(([indexes firstIndex] - mPhotoColumns), mPhotoColumns + 1)];
       	mPhotoSelectionIndexes = [indexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[indexes firstIndex]]];
	}
	[indexes release];
	[self setNeedsDisplay:YES];
}

	//command and right arrow event
- (void)moveToEndOfLine:(id)sender
{
	NSIndexSet *indexes = [mPhotoSelectionIndexes mutableCopy];
	if ([indexes count] > 0) {
		unsigned int destinationIndex = ([indexes lastIndex] + mPhotoColumns) - ([indexes lastIndex] % mPhotoColumns) - 1;
		if (destinationIndex >= mPhotosCount) {
			destinationIndex = mPhotosCount - 1;
		}
		NSIndexSet *newIndexes = [[NSIndexSet alloc] initWithIndex:destinationIndex];
		mPhotoSelectionIndexes = [newIndexes mutableCopy];
		[self scrollRectToVisible:[self gridRectForIndex:destinationIndex]];
        [newIndexes release];
	}
	[indexes release];
	[self setNeedsDisplay:YES];
}

- (void)moveToEndOfLineAndModifySelection:(id)sender
{
	NSMutableIndexSet *indexes = [mPhotoSelectionIndexes mutableCopy];
	if ([indexes count] > 0) {
		unsigned int destinationIndexPlusOne = ([indexes lastIndex] + mPhotoColumns) - ([indexes lastIndex] % mPhotoColumns);
		if (destinationIndexPlusOne >= mPhotosCount) {
			destinationIndexPlusOne = mPhotosCount;
		}
		[indexes addIndexesInRange:NSMakeRange(([indexes lastIndex]), (destinationIndexPlusOne - [indexes lastIndex]))];
		mPhotoSelectionIndexes = [indexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[indexes lastIndex]]];
	}
	[indexes release];
	[self setNeedsDisplay:YES];
}

- (void)moveToBeginningOfLine:(id)sender
{
	NSIndexSet *indexes = [mPhotoSelectionIndexes mutableCopy];
	if ([indexes count] > 0) {
		unsigned int destinationIndex = [indexes firstIndex] - ([indexes firstIndex] % mPhotoColumns);
		NSIndexSet *newIndexes = [[NSIndexSet alloc] initWithIndex:destinationIndex];
        mPhotoSelectionIndexes = [newIndexes mutableCopy];
		[self scrollRectToVisible:[self gridRectForIndex:destinationIndex]];
		[newIndexes release];
	}
	[indexes release];
	[self setNeedsDisplay:YES];
}

- (void)moveToBeginningOfLineAndModifySelection:(id)sender
{
	NSMutableIndexSet *indexes = [mPhotoSelectionIndexes mutableCopy];
	if ([indexes count] > 0) {
		unsigned int destinationIndex = [indexes firstIndex] - ([indexes firstIndex] % mPhotoColumns);
		[indexes addIndexesInRange:NSMakeRange(destinationIndex, ([indexes firstIndex] - destinationIndex))];
		mPhotoSelectionIndexes = [indexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:destinationIndex]];
	}
	[indexes release];
	[self setNeedsDisplay:YES];
}

- (void)moveToBeginningOfDocument:(id)sender
{
    if (mPhotosCount > 0){ 
		NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:0];
		mPhotoSelectionIndexes = [indexes mutableCopy];
		[self scrollRectToVisible:[self gridRectForIndex:0]];
    }
	[self setNeedsDisplay:YES];
}

- (void)moveToBeginningOfDocumentAndModifySelection:(id)sender
{
	NSMutableIndexSet *indexes = [mPhotoSelectionIndexes mutableCopy];
	if ([indexes count] > 0) {
		[indexes addIndexesInRange:NSMakeRange(0, [indexes firstIndex])];
		mPhotoSelectionIndexes = [indexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:0]];
	}
	[indexes release];
	[self setNeedsDisplay:YES];
}

- (void)moveToEndOfDocument:(id)sender
{
	NSIndexSet *indexes;
    if (mPhotosCount > 0){ 
		indexes = [NSIndexSet indexSetWithIndex:(mPhotosCount - 1)];
		mPhotoSelectionIndexes = [indexes mutableCopy];
        [self scrollRectToVisible:[self gridRectForIndex:mPhotosCount - 1]];
    }
//	[indexes release];
	[self setNeedsDisplay:YES];
}

- (void)moveToEndOfDocumentAndModifySelection:(id)sender
{
	NSMutableIndexSet *indexes = [mPhotoSelectionIndexes mutableCopy];
	if ([indexes count] > 0) {
		[indexes addIndexesInRange:NSMakeRange([indexes lastIndex], (mPhotosCount - [indexes lastIndex]))];
		mPhotoSelectionIndexes = [indexes retain];
		[self scrollRectToVisible:[self gridRectForIndex:[indexes lastIndex]]];
	}
	[indexes release];
	[self setNeedsDisplay:YES];
}

- (void)scrollToEndOfDocument:(id)sender
{
	[self scrollPoint:NSZeroPoint];
}

- (void)scrollToBeginningOfDocument:(id)sender
{
    [self scrollRectToVisible:[self gridRectForIndex:0]];
}

- (void)scrollPageDown:(id)sender
{
	NSScrollView *scrollView = [self enclosingScrollView];
	NSRect r = [scrollView documentVisibleRect];
    [self scrollPoint:NSMakePoint(NSMinX(r), NSMaxY(r) - [scrollView verticalPageScroll])];	
}

- (void)scrollPageUp:(id)sender
{
	NSScrollView *scrollView = [self enclosingScrollView];
	NSRect r = [scrollView documentVisibleRect];
    [self scrollPoint:NSMakePoint(NSMinX(r), (NSMinY(r) - NSHeight(r)) + [scrollView verticalPageScroll])];
}

- (void)insertTab:(id)sender
{
	[[self window] selectKeyViewFollowingView:self];
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{	
	NSMenu *menu = [[[NSMenu alloc] init] autorelease];
	if ([mPhotoSelectionIndexes count] > 0) {
		NSMenuItem *openInPreviewMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Open in Preview" 
																		action:@selector(openInPreview) keyEquivalent:@""] autorelease];
		[openInPreviewMenuItem setTarget:self];
		[menu addItem:openInPreviewMenuItem];
		
		NSMenuItem *revealInFinderMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Reveal in Finder"
																		 action:@selector(revealInFinder) keyEquivalent:@""] autorelease];
		[revealInFinderMenuItem setTarget:self];
		[menu addItem:revealInFinderMenuItem];
		
		NSMenuItem *quickLookMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Quicklook"
																	action:@selector(quickLook) keyEquivalent:@""] autorelease];
		[quickLookMenuItem setTarget:self];
		[menu addItem:quickLookMenuItem];
		
		return menu;				
	}
	else {
		NSMenuItem *selectAllPhotosItem = [[[NSMenuItem alloc] initWithTitle:@"Select All" action:@selector(selectAll:) keyEquivalent:@"a"]autorelease];
		[selectAllPhotosItem setTarget:self];
		[menu addItem:selectAllPhotosItem];
		return menu;
//		NSBeginAlertSheet(@"Please select an image", @"OK", nil, nil, [self window], self, nil, nil, nil, @"select an image before open");
//		return nil;
	}
}
		
- (void) openInPreview
{
	NSUInteger photoIndex = [mPhotoSelectionIndexes firstIndex];
	
	while (photoIndex != NSNotFound) {
		if (mPhotoViewDelegate && [mPhotoViewDelegate respondsToSelector:@selector(openPhotoAtIndex:)]){
			[mPhotoViewDelegate openPhotoAtIndex:photoIndex];		
		}
		photoIndex = [mPhotoSelectionIndexes indexGreaterThanIndex:photoIndex];
	}
}

- (void) revealInFinder
{
	NSUInteger photoIndex = [mPhotoSelectionIndexes firstIndex];
	
	while (photoIndex != NSNotFound) {
		if (mPhotoViewDelegate && [mPhotoViewDelegate respondsToSelector:@selector(revealPhotoInFinderAtIndex:)]) {
			[mPhotoViewDelegate revealPhotoInFinderAtIndex:photoIndex];		
		}
		photoIndex = [mPhotoSelectionIndexes indexGreaterThanIndex:photoIndex];
	}	
}

- (void) quickLook
{
	NSUInteger photoIndex = [mPhotoSelectionIndexes firstIndex];
	
	while (photoIndex != NSNotFound) {
		if (mPhotoViewDelegate && [mPhotoViewDelegate respondsToSelector:@selector(quickLookPhotoAtIndex:)]) {
			[mPhotoViewDelegate quickLookPhotoAtIndex:photoIndex];		
		}
		photoIndex = [mPhotoSelectionIndexes indexGreaterThanIndex:photoIndex];
	}		
}
#pragma mark -

- (void) dealloc
{
	if (mPhotoSelectionIndexes) {
		[mPhotoSelectionIndexes release];
		mPhotoSelectionIndexes = nil;
	}

	if (mAutoScrollTimer !=nil) {
		mAutoScrollTimer = nil;	
	}
	mPhotoViewDataSource = nil;
	mPhotoViewDelegate = nil;
	
	if (mPhotoTitleAttributes) {	
		[mPhotoTitleAttributes release];
		mPhotoTitleAttributes = nil;
	}
	[super dealloc];
}
@end