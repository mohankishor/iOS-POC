//
//  SourceListTableView.m
//  TableTester
//
//  Created by Matt Gemmell on Wed Dec 24 2003.
//  Copyright (c) 2003 Scotland Software. All rights reserved.
//

#import "SourceListTableView.h"
#import "SourceListImageCell.h"
#import "SourceListTextCell.h"

@implementation SourceListTableView

- (void)awakeFromNib
{
    /* Make the intercell spacing similar to that used in iCal's Calendars list. */
    [self setIntercellSpacing:NSMakeSize(0.0, 1.0)];
    
    /* Use our custom NSImageCell subclass for the first column. */
    NSTableColumn *firstCol = [[self tableColumns] objectAtIndex:0];
    SourceListImageCell *theImageCell = [[SourceListImageCell alloc] init];
    [firstCol setDataCell:theImageCell];
    [theImageCell release];
    
    /* Use our custom NSTextFieldCell subclass for the second column. */
    NSTableColumn *secondCol = [[self tableColumns] objectAtIndex:1];
    SourceListTextCell *theTextCell = [[SourceListTextCell alloc] init];
    [secondCol setDataCell:theTextCell];
    [theTextCell release];
}

@end
