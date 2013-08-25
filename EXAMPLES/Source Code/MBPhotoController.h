//
//  MBPhotoController.h
//  Media Browser
//
//  Created by Sandeep GS on 27/07/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBPhotoView.h"
#import "MBOutlineView.h"
#import "MBDatabase.h"

@class MBPhotoData;
@class RBSplitView;

@interface MBPhotoController : NSObject <PhotoViewObjectDatasource, PhotoViewObjectDelegate, OutlineViewObjectDelegate>
{
	MBDatabase					*mDBObj;
	IBOutlet MBOutlineView		*mPhotoOutlineView;				// custom class to control outlineview key events	
	IBOutlet MBPhotoView		*mPhotoView;					// custom class control to display photos		
	IBOutlet NSSlider			*mPhotoSlider;					// slider control for photo visiblity
	IBOutlet NSTextField		*mLoadPhotosLabel;				// label for indicator
	IBOutlet NSProgressIndicator*mLoadPhotos;					// indicator for loading photos
	IBOutlet NSPredicateEditor	*mPredicateEditor;	
	IBOutlet NSProgressIndicator*mWriteMetaData;

	IBOutlet NSButton			*mShowCaption;
	IBOutlet NSButton			*mRetrieveMDButton;
	IBOutlet NSTextField		*mPhotoCountField;				// control to display number of photos
	IBOutlet NSTextField		*mFileCountField;
	IBOutlet NSTextField		*mSearchTextBar;
	IBOutlet NSScrollView		*mPredicateEditorScroll;

	NSString					*mDraggedFolder;				// used to store dragged url path	
	NSMutableArray				*mPhotoLibraryPaths;			// used to store paths of photo libraries
	NSMutableArray				*mPhotoDataSource;				// used to store data for libraries
	NSMutableArray				*mFilteredPhotos;				// used to store filtered photos of search operation
	
	NSMutableArray				*mPhotoTypes;					// used to store image types
	NSMutableArray				*mThumbPaths;					// used to store paths of thumbnail photos
	NSString					*mTemporaryPath;				// used for creating temporary folder
	
	NSUInteger					mPhotoCount,mTotalPhotosCount,mTotalSearchCount;	
	
	CFDateRef					mDate;							// to get the actual date from unix timestamp
	CFLocaleRef					mCurrentLocale;
	CFDateFormatterRef			mDateFormatter;
	CFStringRef					mFormattedString;	
	
	float						mSliderCurVal;
	BOOL						mSearch;						// used for checking whether search operation is performed or not
}

	// interface control methods
- (IBAction) retrieveMetaData				:	(id)sender;
- (IBAction) cancelMetaData					:	(id)sender;
- (IBAction) predicateEditorChanged			:	(id)sender;
- (IBAction) showCaptionSelected			:	(id)sender;
- (IBAction) sliderSelected					:	(id)sender;
- (IBAction) zoomOut						:	(id)sender;
- (IBAction) zoomIn							:	(id)sender;

	// database methods
- (void) didEndWritingToDatabase			:	(NSNumber*)dirCount;
- (void) filesAtPath						:	(NSString *)path;

	// search methods
- (void) refreshPhotoView					:	(NSNumber *)countValue;
- (void) searchPhotos;
- (NSArray *)formattedPartsFromPredicate	:	(NSArray*)unFormattedParts;
- (void) displaySearchResult				:	(NSMutableArray *)queryResult;
- (void) displaySearchStatus				:	(NSNumber*)searchCount;
- (NSString *)queryStringForSearch			:	(NSArray*)expParts;
@end
