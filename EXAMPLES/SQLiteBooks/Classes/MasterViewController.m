/*

===== IMPORTANT =====

This is sample code demonstrating API, technology or techniques in development.
Although this sample code has been reviewed for technical accuracy, it is not
final. Apple is supplying this information to help you plan for the adoption of
the technologies and programming interfaces described herein. This information
is subject to change, and software implemented based on this sample code should
be tested with final operating system software and final documentation. Newer
versions of this sample code may be provided with future seeds of the API or
technology. For information about updates to this and other developer
documentation, view the New & Updated sidebars in subsequent documentation
seeds.

=====================

File: MasterViewController.m
Abstract: 
Controls the table and navigation between master and detail views.  


Version: 1.6

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import "MasterViewController.h"
// Need to import the AppDelegate because it owns the books array and we want access to that property.
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "Book.h"

// Private interface for MasterViewController - internal only methods.
@interface MasterViewController (Private)
- (void)inspectBook:(Book *)book;
@end

@implementation MasterViewController

@synthesize detailViewController, tableView;

- (void)dealloc {
    // Release allocated resources.
    [tableView release];
    [detailViewController release];
    [super dealloc];
}

// Set up the user interface.
- (void)awakeFromNib {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // We use Key-Value-Observing to improve encapsulation between the app delegate, owner of the data, 
    // and management/updates for the views by registering to be notified when the "books" array changes.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate addObserver:self forKeyPath:@"books" 
                    options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

// Update the table before the view displays.
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

// Invoked when the user touches Edit.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Updates the appearance of the Edit|Done button as necessary.
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    // Disable the add button while editing.
    if (editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

// Handle change notifications for observed key paths of other objects.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change 
                context:(void *)context {
    // In this sample, there is only one key path in which this object is interested - "books".
    // All other key path notifications will be passed along to the superclass, IFF it handles such notifications.
    if ([keyPath isEqual:@"books"]) {
        // Test the type of change. Insertions of new data receive special handling.
        if ([[change valueForKey:NSKeyValueChangeKindKey] intValue] == NSKeyValueChangeInsertion) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            // Determine the index that changed, map that to a book object.
            NSUInteger index = [[change valueForKey:NSKeyValueChangeIndexesKey] firstIndex];
            Book *book = (Book *)[appDelegate.books objectAtIndex:index];
            // Load the inspection (detail view) with the newly inserted book.
            [self inspectBook:book];
            [detailViewController setEditing:YES animated:NO];
        }
        // Verify that the superclass does indeed handle these notifications before actually invoking that method.
    } else if ([[self superclass] instancesRespondToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)inspectBook:(Book *)book {
    // Create the detail view lazily
    if (detailViewController == nil) {
        DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
        self.detailViewController = viewController;
        [viewController release];
    }
    // Retrieve the other attributes of the book from the database (if needed).
    [book hydrate];
    // Set the detail controller's inspected item to the currently-selected book.
    detailViewController.book = book;
    // "Push" the detail view on to the navigation controller's stack.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController setEditing:NO animated:NO];
}

#pragma mark Table Delegate and Data Source Methods
// These methods are all part of either the UITableViewDelegate or UITableViewDataSource protocols.

// This table will always only have one section.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 1;
}

// One row per book, the number of books is the number of rows.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.books.count;
}

// The accessory type is the image displayed on the far right of each table cell. In order for the delegate method
// tableView:accessoryButtonClickedForRowWithIndexPath: to be called, you must return the "Detail Disclosure Button" type.
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        // Create a new cell. CGRectZero allows the cell to determine the appropriate size.
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MyIdentifier"] autorelease];
    }
    // Retrieve the book object matching the row from the application delegate's array.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Book *book = (Book *)[appDelegate.books objectAtIndex:indexPath.row];
    cell.text = book.title;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Inspect the book (method defined above).
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self inspectBook:[appDelegate.books objectAtIndex:indexPath.row]];
    return nil;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
                forRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Find the book at the deleted row, and remove from application delegate's array.
        Book *book = [appDelegate.books objectAtIndex:indexPath.row];
        [appDelegate removeBook:book];
        // Animate the deletion from the table.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

