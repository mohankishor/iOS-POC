//
//  TableSource.m
//  TableTester
//
//  Created by Matt Gemmell on Wed Dec 24 2003.
//  Copyright (c) 2003 Scotland Software. All rights reserved.
//

#import "TableSource.h"


@implementation TableSource


- (id)init
{
    if (self = [super init]) {
        /* Just some sample data for demonstration purposes */
        data = [[NSArray alloc] initWithObjects:@"Personal", @"Work", @"Holidays", @"Birthdays", 
                                                @"Project 1", @"Project 2", @"Project 3", @"Project 4", 
                                                @"Project 5", nil];
        colors = [[NSDictionary alloc] 
            initWithObjects:[NSArray arrayWithObjects:[NSColor cyanColor], [NSColor redColor], 
                                                        [NSColor greenColor], [NSColor magentaColor], 
                                                        [NSColor purpleColor], [NSColor orangeColor], 
                                                        [NSColor yellowColor], [NSColor grayColor], 
                                                        [NSColor blueColor], nil] 
                    forKeys:data];
        
        return self;
    }
    
    return nil;
}


/* Method to return a colored checkbox image with a given color and state. */
- (NSImage *)checkboxWithColor:(NSColor *)color checked:(BOOL)isChecked
{
    NSSize imgSize = NSMakeSize(14, 16); // Must be even values.
    NSRect imgRect = NSMakeRect(0, 0, imgSize.width, imgSize.height);
    
    // Prepare color overlay
    NSImage *colorOverlay = [[NSImage alloc] initWithSize:imgSize];
    [colorOverlay lockFocus];
    [color set];
    [NSBezierPath fillRect:imgRect];
    [colorOverlay unlockFocus];
    
    // Composite color overlay into colormask
    NSImage *colormask = [NSImage imageNamed:@"chkbx2_colormask.png"];
    [colormask lockFocus];
    [colorOverlay drawInRect:imgRect fromRect:imgRect 
                   operation:NSCompositeSourceIn fraction:1.0];
    [colormask unlockFocus];
    [colorOverlay release];
    
    NSImage *finalImg = [[[NSImage alloc] initWithSize:imgSize] autorelease];
    [finalImg lockFocus];
    [[NSImage imageNamed:@"chkbx1_shadow.png"] drawInRect:imgRect 
                                                     fromRect:imgRect 
                                                    operation:NSCompositeSourceOver 
                                                     fraction:1.0];
    [colormask drawInRect:imgRect fromRect:imgRect 
                operation:NSCompositeSourceOver fraction:1.0];
    [[NSImage imageNamed:@"chkbx3_background.png"] drawInRect:imgRect 
                                                     fromRect:imgRect 
                                                    operation:NSCompositeSourceOver 
                                                     fraction:1.0];
    if (isChecked) {
        [[NSImage imageNamed:@"chkbx4_check.png"] drawInRect:imgRect 
                                                    fromRect:imgRect 
                                                   operation:NSCompositeSourceOver 
                                                    fraction:1.0];
    }
    [finalImg unlockFocus];
    
    return finalImg;
}


/* Required method for the NSTableDataSource protocol. */
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [data count];
}


/* Required method for the NSTableDataSource protocol. */
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn row:(int)rowIndex
{
    if ([[aTableColumn identifier] isEqualToString:@"icon"]) {
        return [self checkboxWithColor:[colors objectForKey:[data objectAtIndex:rowIndex]] checked:YES];
    }
    return [data objectAtIndex:rowIndex];
}


@end
