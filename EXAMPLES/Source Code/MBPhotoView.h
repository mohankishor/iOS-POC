//
//  MBPhotoView.h
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MBPhotoController;
@protocol PhotoViewObjectDatasource;
@protocol PhotoViewObjectDelegate;

@interface MBPhotoView : NSView {
	NSObject <PhotoViewObjectDatasource>		*mPhotoViewDataSource;
	NSObject <PhotoViewObjectDelegate>			*mPhotoViewDelegate;
	
	NSUInteger					mPhotoCaptionState;
	NSUInteger					mPhotosCount,mPhotoColumns,mPhotoRows;
	NSMutableIndexSet			*mPhotoSelectionIndexes;
	
	NSPoint						mouseDownPoint, mouseCurrentPoint;		
	NSSize						mPhotoSize,mTitleSize;
	NSRect						mSelectionRect,mPhotoRect,mTitleRect,mGridRect;
	NSMutableDictionary			*mPhotoTitleAttributes;
	NSTimer						*mAutoScrollTimer;

	float						mPhotoVerticalSpacing,mPhotoHorizontalSpacing;
	BOOL						mDragInitiated,mDragPhoto;
}

@property (nonatomic, assign) NSSize			mPhotoSize;
@property (nonatomic, assign) float				mPhotoVerticalSpacing;
@property (nonatomic, assign) float				mPhotoHorizontalSpacing;
@property (nonatomic, assign) NSUInteger		mPhotoColumns;
@property (nonatomic, assign) NSUInteger		mPhotoRows;
@property (nonatomic, assign) NSMutableIndexSet *mPhotoSelectionIndexes;
@property (nonatomic, assign) NSObject <PhotoViewObjectDatasource>	*mPhotoViewDataSource;
@property (nonatomic, assign) NSObject <PhotoViewObjectDelegate>	*mPhotoViewDelegate;

	// Instance methods
- (void) captionsForPhotos		: (NSUInteger)state;
@end

	//Protocol datasource methods to implement
@protocol PhotoViewObjectDatasource <NSObject>
- (NSInteger) numberOfPhotosInArray;
- (void) upgradeFrameContentAndSize;
- (NSImage *) photoAtIndex			: (NSUInteger)index;
- (NSString *) photoPathAtIndex		: (NSUInteger)index;
- (NSString *) photoTitleAtIndex	: (NSUInteger)index;
@end

	//Protocol delegate methods to implement
@protocol PhotoViewObjectDelegate <NSObject>
- (void) openPhotoAtIndex: (NSUInteger)index;
- (void) revealPhotoInFinderAtIndex:(NSUInteger)index;
- (void) quickLookPhotoAtIndex:(NSUInteger)index;
- (void) photoView:(MBPhotoView *)view fillPasteboardForDrag:(NSPasteboard *)pboard;
@end