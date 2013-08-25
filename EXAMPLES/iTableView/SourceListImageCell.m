//
//  SourceListImageCell.m
//  TableTester
//
//  Created by Matt Gemmell on Mon Dec 29 2003.
//  Copyright (c) 2003 Scotland Software. All rights reserved.
//

#import "SourceListImageCell.h"


@implementation SourceListImageCell

- (id)init
{
    if (self = [super init]) {
        [self setImageAlignment:NSImageAlignTop];
        
        return self;
    }
    return nil;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSImage *gradient;
    /* Determine whether we should draw a blue or grey gradient. */
    /* We will automatically redraw when our parent view loses/gains focus, 
    or when our parent window loses/gains main/key status. */
    if (([[controlView window] firstResponder] == controlView) && 
        [[controlView window] isMainWindow] &&
        [[controlView window] isKeyWindow]) {
        gradient = [NSImage imageNamed:@"highlight_blue.tiff"];
    } else {
        gradient = [NSImage imageNamed:@"highlight_grey.tiff"];
    }
    
    /* Make sure we draw the gradient the correct way up. */
    [gradient setFlipped:YES];
    int i = 0;
    
    if ([self isHighlighted]) {
        [controlView lockFocus];
        
        /* We're selected, so draw the gradient background. */
        NSSize gradientSize = [gradient size];
        for (i = cellFrame.origin.x; i < (cellFrame.origin.x + cellFrame.size.width); i += gradientSize.width) {
            [gradient drawInRect:NSMakeRect(i, cellFrame.origin.y, gradientSize.width, cellFrame.size.height)
                        fromRect:NSMakeRect(0, 0, gradientSize.width, gradientSize.height)
                       operation:NSCompositeSourceOver
                        fraction:1.0];
        }
        
        /* Now draw our image. */
        NSImage *img = [self image];
        NSSize imgSize = [img size];
        [img compositeToPoint:NSMakePoint(cellFrame.origin.x + (floor(cellFrame.size.width / 2) - floor(imgSize.width / 2)), 
                                   cellFrame.origin.y + cellFrame.size.height - 2) // Can we determine the correct inset?
               fromRect:NSMakeRect(0, 0, imgSize.width, imgSize.height) 
              operation:NSCompositeSourceOver 
               fraction:1.0];
        
        [controlView unlockFocus];
    } else {
        /* We're not selected, so ask our superclass to draw our content normally. */
        [super drawInteriorWithFrame:cellFrame inView:controlView];
    }
}

@end
