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

File: AppDelegate.m
Abstract: 
This class is the application delegate. That means it receives (and should
handle) messages 
from the application informing it of launch and termination state. The
application delegate 
initiates the user interface setup and acts as a central coordinator for the
database backing 
the application.


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

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "Book.h"

// Private interface for AppDelegate - internal only methods.
@interface AppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end

@implementation AppDelegate

// Instruct the compiler to create accessor methods for the property. It will use the internal 
// variable with the same name for storage.
@synthesize books, window, navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // The application ships with a default database in its bundle. If anything in the application
    // bundle is altered, the code sign will fail. We want the database to be editable by users, 
    // so we need to create a copy of it in the application's Documents directory.     
    [self createEditableCopyOfDatabaseIfNeeded];
    // Call internal method to initialize database connection
    [self initializeDatabase];
    // Add the navigation controller's view to the window
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // "dehydrate" all data objects - flushes changes back to the database, removes objects from memory
    [books makeObjectsPerformSelector:@selector(dehydrate)];
}

- (void)dealloc {
    [navigationController release];   
    [window release];
    [books release];
    [super dealloc];
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"bookdb.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bookdb.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initializeDatabase {
    NSMutableArray *bookArray = [[NSMutableArray alloc] init];
    self.books = bookArray;
    [bookArray release];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"bookdb.sql"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT pk FROM book";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // We "step" through the results - once for each row.
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                int primaryKey = sqlite3_column_int(statement, 0);
                // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
                // autorelease is slightly more expensive than release. This design choice has nothing to do with
                // actual memory management - at the end of this block of code, all the book objects allocated
                // here will be in memory regardless of whether we use autorelease or release, because they are
                // retained by the books array.
				
				
				
                Book *book = [[Book alloc] initWithPrimaryKey:primaryKey database:database];
                [books addObject:book];
                [book release];
            }
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
}

// Save all changes to the database, then close it.
- (void)applicationWillTerminate:(UIApplication *)application {
    // Save changes.
    [books makeObjectsPerformSelector:@selector(dehydrate)];
    [Book finalizeStatements];
    // Close the database.
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
}

// Remove a specific book from the array of books and also from the database.
// Granular (specific to only the index of the affected book) Key-Value-Observing notifications will be posted.
- (void)removeBook:(Book *)book {
    NSUInteger index = [books indexOfObject:book];
    // In this application, it's unlikely that this would occur - but it's better to check for such errors.
    if (index == NSNotFound) return;
    // Delete from the database first. The book knows how to do this (see Book.m)
    [book deleteFromDatabase];
    // Create an index set so that we can post a fine-grained notification of the change that occurs.
    // A coarse grained notification would simply indicate that the entire array changed, this indicates the row
    // and type of change.
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"books"];
    [books removeObject:book];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:@"books"];
}

// Create a new book in the database and add it to the array of books.
// Granular (specific to only the index of the affected book) Key-Value-Observing notifications will be posted.
- (void)addBook:(id)sender {
    // Create a new record in the database and get its automatically generated primary key.
    NSInteger primaryKey = [Book insertNewBookIntoDatabase:database];
    // The number of books will equal the index at which the new object should be inserted.
    NSUInteger count = [books count];
    // Create an index set to use in fine grained KVO notifications.
    NSIndexSet *indexSet = [[[NSIndexSet alloc] initWithIndex:count] autorelease];
    // Create and autorelease a new book object here. It's safe to autorelease because this method will only
    // be invoked by user action, which is too slow to create many objects in a short period.
    Book *newBook = [[Book alloc] initWithPrimaryKey:primaryKey database:database];
    // Insert and post notifications of changes.
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"books"];
    [books insertObject:newBook atIndex:count];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"books"];
    [newBook release];
}

@end
