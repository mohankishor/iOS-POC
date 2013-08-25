//
//  MBPhotoController.m
//  Media Browser
//
//  Created by Sandeep GS on 27/07/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBPhotoController.h"
#import "MBPhotoLibraryNode.h"
#import "MBPhotoData.h"
#import "MBPhotoView.h"
#import "MBOutlineViewCell.h"

	// constants
#define		FILEPATH			@"Filepath"
#define		TEMPPATH			NSTemporaryDirectory()			// temporary path store for thumbnail photos
#define		MINSIZE				80
#define		MAXSIZE				300
#define		PHOTO_PERCENTAGE	(MAXSIZE-MINSIZE)/100

	// user default constants
#define		CUSTOMFOLDERS	@"OutlineViewFolders"
#define		SELECTEDROW		@"OutlineviewSelectedRow"
#define		PHOTOSIZE		@"PhotoSize"
#define		SLIDERVALUE		@"PhotoSliderValue"
#define		TITLE			@"Title"

static BOOL	mSearchThread=YES;
static BOOL mPhotoThread=YES;
static BOOL mTempThread=YES;

@interface MBPhotoController (PhotoController)
		// Thread Methods
	- (void) loadPhotosFromLibraryAtPath		:	(NSString *)path;
	- (void) createThumbnailFromPhotoDetails	:	(NSMutableDictionary *)photoDict;
	- (void) thumbnailsAtPath					:	(NSString *)fullPath;
	- (void) loadPhotos;

		// photo parsing methods	
	- (void) photosAtPathToThumbnailsAtPath		:	(NSString *)dirPath intoDirectory:(NSString *)toDirPath;
	- (void) addCustomFolderPath				:	(NSString *)path;
	- (void) totalPhotosAtLibraryPath			:	(NSString *)path;
	- (void) writeItems							:	(NSArray *)items toPasteboard:(NSPasteboard *)pboard;

		// user default methods
	- (void) loadUserDefaultValues;
	- (void) storeUserDefaultValues;
	- (void) writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard;
@end

@implementation MBPhotoController (PhotoController)
#pragma mark user default methods
- (void) loadUserDefaultValues
{
	NSInteger selectedRow = [[NSUserDefaults standardUserDefaults] integerForKey:SELECTEDROW];
	if(selectedRow<[mPhotoLibraryPaths count]){
		[mPhotoOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];	
	}
	float sliderValue = [[NSUserDefaults standardUserDefaults] floatForKey:SLIDERVALUE];
	float photoSize = [[NSUserDefaults standardUserDefaults] floatForKey:PHOTOSIZE];
	if(sliderValue){
		[mPhotoSlider setFloatValue:sliderValue]; 
		mPhotoView.mPhotoSize = NSMakeSize(photoSize, photoSize);
		[mPhotoView setNeedsDisplay:YES];		
	}
}

- (void) storeUserDefaultValues
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:mPhotoLibraryPaths forKey:CUSTOMFOLDERS];	
	[userDefaults setInteger:[mPhotoOutlineView selectedRow] forKey:SELECTEDROW];
	[userDefaults setFloat:[mPhotoSlider floatValue] forKey:SLIDERVALUE];	
	[userDefaults setFloat:mPhotoView.mPhotoSize.width forKey:PHOTOSIZE];
	[userDefaults synchronize];
}

- (void) showPhotoFields
{
	[mPhotoCountField setHidden:NO];
}

- (void) hidePhotoFields
{
	[mPhotoCountField setHidden:YES];
}
#pragma mark -

#pragma mark Threads
	// read photos from libraries
- (void) loadPhotosFromLibraryAtPath:(NSString *)path
{
	@synchronized(self){
		mPhotoThread = NO;	
	}
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if ([[path lastPathComponent] isEqualToString:@"Pictures"]) {
		path = [NSString stringWithFormat:@"%@/Pictures",NSHomeDirectory()];
	}
	NSString *newDirPath = [NSString stringWithFormat:@"%@%@",mTemporaryPath,path]; 		
	
	if (![mThumbPaths containsObject:newDirPath]) {
		[mThumbPaths addObject:newDirPath];		
	}
	
	[[NSFileManager defaultManager] createDirectoryAtPath:newDirPath
							  withIntermediateDirectories:YES  
											   attributes:nil 
													error:nil];
	[self photosAtPathToThumbnailsAtPath:path intoDirectory:newDirPath];								
	
		//	[mLoadPhotos stopAnimation:self];
	[mLoadPhotosLabel setHidden:YES];
	[mLoadPhotos setHidden:YES];	
	[pool release];
//	NSLog(@"thumbs path array:%@",mThumbPaths);	
}

- (void)loadPhotos
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	NSString		*path;
	NSDictionary	*dict;
	mTotalPhotosCount = 0;
	for(int i=0; i<[mPhotoLibraryPaths count]; i++){
		dict = [mPhotoLibraryPaths objectAtIndex:i];
		path = [dict objectForKey:@"Filepath"];
		if ([[path lastPathComponent] isEqualToString:@"Pictures"]) {
			path = [NSString stringWithFormat:@"%@/Pictures",NSHomeDirectory()];
		}
		[self totalPhotosAtLibraryPath:path];
	}	
	[pool release];
}

- (void) totalPhotosAtLibraryPath:(NSString*)path
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	NSFileManager	*folderManager = [NSFileManager defaultManager];
	NSArray			*folderContents;
	NSString		*filePath;
	NSString		*fileType;
	
	folderContents = [folderManager contentsOfDirectoryAtPath:path error:nil];
	
	for(int i=0; i<[folderContents count]; i++){
		filePath = [NSString stringWithFormat:@"%@/%@",path,[folderContents objectAtIndex:i]];
		BOOL isDir, valid = [folderManager fileExistsAtPath:filePath isDirectory:&isDir];
		[[NSWorkspace sharedWorkspace] getInfoForFile:filePath application:nil type:&fileType];
		
		NSURL *urlPath = [NSURL fileURLWithPath:filePath];
		NSArray *keys = [NSArray arrayWithObjects:NSURLNameKey, NSURLLocalizedNameKey,
						 NSURLIsRegularFileKey, NSURLIsDirectoryKey,
						 NSURLIsSymbolicLinkKey, NSURLIsPackageKey, NSURLIsHiddenKey, NSURLContentAccessDateKey, NSURLLabelColorKey, nil];
		
		NSDictionary *fileValues= [urlPath resourceValuesForKeys:keys error:nil];
		NSUInteger hiddenValue = [[fileValues objectForKey:NSURLIsHiddenKey]intValue];
		if(valid && !isDir && [mPhotoTypes containsObject:[fileType lowercaseString]] && !hiddenValue){
			mTotalPhotosCount++;
		}
		if(isDir && !hiddenValue){
			[self totalPhotosAtLibraryPath:filePath];
		}
	}	
	[pool release];			
}
#pragma mark  -

#pragma mark photo parsing methods
- (void) addCustomFolderPath:(NSString *)path
{
	BOOL valid=NO,flag=NO,isDir=NO;    
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:path forKey:@"Filepath"];
	[dict setObject:[NSNumber numberWithBool:YES] forKey:@"isEditable"];
	
	for(int i=0; i<[mPhotoLibraryPaths count]; i++){
		NSDictionary *temp = [mPhotoLibraryPaths objectAtIndex:i];
		NSString *oldPath = [temp objectForKey:@"Filepath"];
		valid = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
		if(valid)
		{
			if([oldPath isEqualToString:path]){
				flag = YES;
				break;
			}
			else {
				flag = NO;
			}
		}
	}
	if(!flag && isDir){
		[mPhotoLibraryPaths addObject:dict];	
		[mRetrieveMDButton setHidden:NO];
		[mPredicateEditorScroll setHidden:YES];
//		[mSearchTextBar setHidden:YES];
		
		[NSThread detachNewThreadSelector:@selector(loadPhotos) toTarget:self withObject:nil];
	}
	[mPhotoOutlineView reloadData];			
	[mPhotoOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:[mPhotoLibraryPaths count]-1] byExtendingSelection:NO];
}

- (void) thumbnailsAtPath:(NSString *)fullPath
{	
	@synchronized(self){
		mTempThread = NO;
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	for(int i=0; i<[mThumbPaths count]; i++){
		NSRange range = [[mThumbPaths objectAtIndex:i] rangeOfString:TEMPPATH];
		NSString *newString = [[mThumbPaths objectAtIndex:i] stringByReplacingCharactersInRange:range withString:@""];
		
		if([newString isEqualToString:fullPath]){
			NSArray *photoThumbs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[mThumbPaths objectAtIndex:i] error:nil];
			
			for(int j=0; j<[photoThumbs count]; j++){
				NSMutableString *subPath = [NSString stringWithFormat:@"%@/%@",[mThumbPaths objectAtIndex:i],[photoThumbs objectAtIndex:j]];
				BOOL isDir, valid = [[NSFileManager defaultManager] fileExistsAtPath:subPath isDirectory:&isDir];
				if(valid && !isDir){
					if([[photoThumbs objectAtIndex:j] characterAtIndex:0]!='.'){
						MBPhotoData *pNode = [[MBPhotoData alloc]init];
						pNode.mPhotoPath = fullPath;
						pNode.mPhotoType = [[photoThumbs objectAtIndex:j]pathExtension];
						pNode.mPhotoTitle = [[photoThumbs objectAtIndex:j]stringByDeletingPathExtension];
						pNode.mPhotoThumb = [[NSImage alloc] initByReferencingFile:[NSString stringWithFormat:@"%@/%@.%@",[mThumbPaths objectAtIndex:i],pNode.mPhotoTitle,pNode.mPhotoType]];			
						@synchronized(self){
//							NSLog(@"pnode description:%@",pNode);
							[mPhotoDataSource addObject:pNode];	
						}	
						
						[pNode.mPhotoThumb release];
						[pNode release];
						[self performSelectorOnMainThread:@selector(refreshPhotoView:) withObject:nil waitUntilDone:NO];
					}
				}
				if(isDir){
					[self thumbnailsAtPath:[NSString stringWithFormat:@"%@/%@",fullPath,[subPath lastPathComponent]]];
				}				
			}
		}
		@synchronized(self){
			if(mTempThread){
				break;
			}
		}
	}	
	[mLoadPhotos stopAnimation:self];
	[mLoadPhotosLabel setHidden:YES];
	[mLoadPhotos setHidden:YES];	
	[pool release];
}

	//Traverse through a directory for files including subdirectories
- (void) photosAtPathToThumbnailsAtPath: (NSString *)dirPath intoDirectory:(NSString *)toDirPath
{ 
	[mLoadPhotosLabel setStringValue:@"Please Wait!! Loading Photos"];
	NSFileManager	*folderManager = [NSFileManager defaultManager];
	NSArray			*folderContents;
	NSString		*filePath, *newPath;
	NSString		*fileType;
	
	folderContents = [folderManager contentsOfDirectoryAtPath:dirPath error:nil];
	
	for(int i=0; i<[folderContents count]; i++){
		filePath = [NSString stringWithFormat:@"%@/%@",dirPath,[folderContents objectAtIndex:i]];
		newPath = [NSString stringWithFormat:@"%@/%@",toDirPath,[folderContents objectAtIndex:i]];
		BOOL isDir, valid = [folderManager fileExistsAtPath:filePath isDirectory:&isDir];
		[[NSWorkspace sharedWorkspace] getInfoForFile:filePath application:nil type:&fileType];
		
		NSURL *urlPath = [NSURL fileURLWithPath:filePath];
		NSArray *keys = [NSArray arrayWithObjects:NSURLIsHiddenKey,nil];
		
		NSDictionary *fileValues= [urlPath resourceValuesForKeys:keys error:nil];
		NSUInteger hiddenValue = [[fileValues objectForKey:NSURLIsHiddenKey]intValue];
		
		if(valid && !isDir && [mPhotoTypes containsObject:[fileType lowercaseString]] && !hiddenValue){
			NSMutableDictionary *photoDict = [NSMutableDictionary dictionary];
			
			NSString *photoPath = dirPath;
			NSString *photoTitle = [[folderContents objectAtIndex:i]stringByDeletingPathExtension];
			
			[photoDict setObject:filePath forKey:@"PhotoFullPath"];
			[photoDict setObject:photoTitle forKey:@"PhotoTitle"];
			[photoDict setObject:toDirPath forKey:@"PhotoDestPath"];
			[photoDict setObject:photoPath forKey:@"PhotoRootPath"];
			[photoDict setObject:fileType forKey:@"PhotoType"];
			
			[self createThumbnailFromPhotoDetails:photoDict];
		}
		if(isDir && !hiddenValue){
			BOOL valid=NO;
			for(int j=0; j<[mThumbPaths count]; j++){
				if([newPath isEqualToString:[mThumbPaths objectAtIndex:j]]){
					valid = YES;
				}
			}
			if(!valid){
				[mThumbPaths addObject:newPath];	
			}
			[[NSFileManager defaultManager] createDirectoryAtPath:newPath
									  withIntermediateDirectories:NO 
													   attributes:nil 
															error:nil];
			[self photosAtPathToThumbnailsAtPath:filePath intoDirectory:newPath];
		}
		@synchronized(self){
			if (mPhotoThread){
				break;
			}			
		}
	}
}

- (void) createThumbnailFromPhotoDetails : (NSMutableDictionary *)photoDict
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	
	NSImage		*photo = [[NSImage alloc] initByReferencingFile:[photoDict objectForKey:@"PhotoFullPath"]];
	NSUInteger	photoResolution = 32;
	NSSize		photoSize = NSMakeSize(256, 256);
	NSString	*photoTitle = [photoDict objectForKey:@"PhotoTitle"];
	NSString	*toDirPath = [photoDict objectForKey:@"PhotoDestPath"];
	NSString	*fromDirPath = [photoDict objectForKey:@"PhotoRootPath"];
	NSString	*photoType = [photoDict objectForKey:@"PhotoType"];
	NSSize		originalImageSize = NSZeroSize;
	
	originalImageSize = [photo size];
	int newWidth = originalImageSize.width, newHeight = originalImageSize.height;
	
	if((originalImageSize.width > photoSize.width) || (originalImageSize.height > photoSize.height))
	{
		float widthRatio, heightRatio;
		widthRatio = originalImageSize.width/(float)photoSize.width;
		heightRatio = originalImageSize.height/(float)photoSize.height;
		
		if(widthRatio > heightRatio){				//checks landscape photo
			newWidth = photoSize.width;
			newHeight = originalImageSize.height/widthRatio;
		}
		else{										//checks portrait photo
			newWidth = originalImageSize.width/heightRatio;
			newHeight = photoSize.height;
		}
	}
	
	NSBitmapImageRep *originalRep = [[NSBitmapImageRep alloc] initWithData:[photo TIFFRepresentation]];
	NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes	:NULL
																	   pixelsWide	:newWidth  
																	   pixelsHigh	:newHeight
																	bitsPerSample	:8
																  samplesPerPixel	:4
																		 hasAlpha	:YES    
																		 isPlanar	:NO
																   colorSpaceName	:NSCalibratedRGBColorSpace
																	  bytesPerRow	:0
																	 bitsPerPixel	:0];
	
	[NSGraphicsContext saveGraphicsState];
	NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:newRep];
	[NSGraphicsContext setCurrentContext:context];
	
	NSImage *tmpImg = [[NSImage alloc] init];
	[tmpImg addRepresentation: originalRep];
	
	[originalRep release];
	
	[tmpImg drawInRect:NSMakeRect( 0, 0, newWidth, newHeight) fromRect:NSZeroRect //	 or NSZeroRect when using the whole image
			 operation:NSCompositeSourceOver
			  fraction:1.0];
	
	float dpiX = photoResolution;   // source x resolution
	float dpiY = photoResolution;    // source x resolution
	NSSize size = [tmpImg size];
	size.width = 32.0 * [newRep pixelsWide] / dpiX;
	size.height = 32.0 * [newRep pixelsHigh] / dpiY;
	[NSGraphicsContext restoreGraphicsState];
	[newRep setSize:size];
	
	NSData  *finalImage = [newRep representationUsingType:NSJPEGFileType properties:nil];
	[newRep release];
	[tmpImg release];		
	[photo release];
	
	[finalImage writeToFile:[NSString stringWithFormat:@"%@/%@.%@",toDirPath,photoTitle,photoType] atomically:YES];
	
	MBPhotoData *pNode = [[MBPhotoData alloc]init];
	NSImage *tempImage = [[NSImage alloc] initByReferencingFile:[NSString stringWithFormat:@"%@/%@.%@",toDirPath,photoTitle,photoType]];			 
	pNode.mPhotoPath = fromDirPath;
	pNode.mPhotoTitle = photoTitle;
	pNode.mPhotoType = photoType;
	pNode.mPhotoThumb = tempImage;
	[tempImage release];
	
	NSArray *prevPathComponents = [pNode.mPhotoPath pathComponents];
	NSArray *curPathComponents = [[[mPhotoOutlineView itemAtRow:[mPhotoOutlineView selectedRow]]fullPath]pathComponents]; 
	NSString *prevPath = [NSString stringWithFormat:@"%@/%@/%@",[prevPathComponents objectAtIndex:0],[prevPathComponents objectAtIndex:1],[prevPathComponents objectAtIndex:2]];
	NSString *curPath = [NSString stringWithFormat:@"%@/%@/%@",[curPathComponents objectAtIndex:0],[curPathComponents objectAtIndex:1],[curPathComponents objectAtIndex:2]];
	
	if (mSearch) {
		@synchronized(self){
			[mFilteredPhotos addObject:pNode];	
		}
		[self performSelectorOnMainThread:@selector(displaySearchStatus:) withObject:[NSNumber numberWithInt:[mFilteredPhotos count]] waitUntilDone:NO];
	}
	
	else {
		if([prevPath isEqualToString:curPath]){
			@synchronized(self){
				[mPhotoDataSource addObject:pNode];
			}
		}			
  	}
	[pNode release];
	[self performSelectorOnMainThread:@selector(refreshPhotoView:) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

- (void)writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
	NSMutableArray *files = [NSMutableArray array];	
	NSEnumerator *e = [items objectEnumerator];
	MBPhotoData	*pNode;
	NSString *draggedFile;
	
	while (pNode = [e nextObject]){
		draggedFile = [NSString stringWithFormat:@"%@/%@.%@",pNode.mPhotoPath,pNode.mPhotoTitle,pNode.mPhotoType];
		[files addObject:draggedFile];
	}
	[pboard setPropertyList:files forType:NSFilenamesPboardType];
}
#pragma mark -
@end

@implementation MBPhotoController
- (id) init
{
	self = [super init];
	if (self != nil) {
		mPhotoDataSource	= [[NSMutableArray alloc] init];				// used to store photos for a particular folder specified
	 	mFilteredPhotos		= [[NSMutableArray alloc] init];				// used to store filtered photos performed in search operation
		mThumbPaths			= [[NSMutableArray alloc]init];					// used to store paths for temporary folders where thumbnails of photos stored	
		mPhotoTypes			= [[NSMutableArray alloc]initWithObjects:@"jpg",@"png",@"gif",@"tif",@"jpeg",@"bmp",@"jp2",nil];					// used to store photo types to parse folder for images
		mTotalPhotosCount	= 0;
		mTotalSearchCount	= 0;
		mPhotoCount			= 0;
		mDBObj				= [[MBDatabase alloc]init];
		
		mTemporaryPath		= [NSTemporaryDirectory() retain];
		mPhotoLibraryPaths	= [[NSUserDefaults standardUserDefaults] objectForKey:CUSTOMFOLDERS];	
		
		if([mPhotoLibraryPaths count]==0){
			NSString *photoPlistPath = [[NSBundle mainBundle] pathForResource:@"Photos" ofType:@"plist"];		// read library paths from property list file
			mPhotoLibraryPaths = [[NSMutableArray arrayWithContentsOfFile:photoPlistPath] retain];						
		}
		mShowCaption.state = 1;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeUserDefaultValues) name:@"kStoreDefaultValuesNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPhotoFields) name:@"kPhotoButtonSelected" object:nil];		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePhotoFields) name:@"kLinkButtonSelected" object:nil];		
	}
	return self;
}

- (void) awakeFromNib
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *mTitle = nil;
	if (standardUserDefaults) 
		mTitle = [standardUserDefaults objectForKey:TITLE];
	if (mTitle != nil){
		[self loadUserDefaultValues];	
	}
	else {
		[mPhotoOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:YES];		
	}
	
//	[mLoadPhotos setHidden:YES];
//	[mLoadPhotosLabel setHidden:YES];
//	[mSearchTextBar setHidden:YES];
		
	[mPhotoOutlineView setDoubleAction:@selector(openLibraryPhotoPath:)];
	[mPhotoOutlineView setTarget:self];
	
	[mPhotoOutlineView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
	
		// register outlineviews for drag and drop folders
	[mPhotoOutlineView registerForDraggedTypes:[NSArray arrayWithObjects:(NSString *)kUTTypeFileURL, nil]];
	[mPhotoOutlineView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
	
	mPhotoView.mPhotoViewDataSource = self;																	// implementing mPhotoView methods
	mPhotoView.mPhotoViewDelegate = self;
	mPhotoOutlineView.mOutlineDelegate = self;																// implementing outlineview subclass methods
	
	MBOutlineViewCell *photoOutlineCell = [[[MBOutlineViewCell alloc]init]autorelease];						// photos outlineview customization	
	[[mPhotoOutlineView tableColumnWithIdentifier:@"Photos"] setDataCell:photoOutlineCell];
	
	[NSThread detachNewThreadSelector:@selector(loadPhotos) toTarget:self withObject:nil];
}

#pragma mark Interface control methods
- (IBAction) showCaptionSelected:(id)sender
{
	NSUInteger state = [mShowCaption state];
	[mPhotoView captionsForPhotos:state];
}

	//To increase or reduce photo size
- (IBAction) sliderSelected:(id)sender
{
	float x,y;
	float minValue = [sender minValue];
	float percentage,width,height; 
	float maxValue = [sender maxValue];
	mSliderCurVal = [sender floatValue];
	
	x = maxValue - minValue; 
	y = mSliderCurVal - minValue;
	percentage = (y * 100) / x;
	
	if(percentage == 100.0){
		width = height = MAXSIZE;
	}
	else {
		width = height = MINSIZE + (PHOTO_PERCENTAGE * percentage);
	}
	mPhotoView.mPhotoSize = NSMakeSize(width, height);
	[mPhotoView setNeedsDisplay:YES];
}

- (IBAction) zoomOut : (id)sender
{
	[mPhotoSlider setDoubleValue:[mPhotoSlider minValue]];
	[mPhotoSlider performClick:self];
	mPhotoView.mPhotoSize = NSMakeSize(80, 80);
	[mPhotoView setNeedsDisplay:YES];
}

- (IBAction) zoomIn : (id)sender
{
	[mPhotoSlider setDoubleValue:[mPhotoSlider maxValue]];
	[mPhotoSlider performClick:self];
	mPhotoView.mPhotoSize = NSMakeSize(300, 300);
	[mPhotoView setNeedsDisplay:YES];
}
#pragma mark -

#pragma mark OutlineView dataSource methods
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item 
{
	return (item == nil) ? [mPhotoLibraryPaths count] : [item numberOfChildren];	
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	return (item == nil) ? YES : ([item numberOfChildren] != 0);	
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item 
{
	MBPhotoLibraryNode *node = nil;  
	if(item == nil){
		NSDictionary *rootLocation = [mPhotoLibraryPaths objectAtIndex:index];
		NSString *filePath = [rootLocation objectForKey:FILEPATH];
		if([[filePath lastPathComponent] isEqualToString:@"Pictures"]){
			filePath = [NSString stringWithFormat:@"%@/Pictures",NSHomeDirectory()];
		}
		node = [[MBPhotoLibraryNode alloc] initWithNode:filePath parent:nil];
	}
	else{
		node = [(MBPhotoLibraryNode *)item childAtIndex:index];
	}		
	return node;				// need to release
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item 
{
	id returnObj = nil;
	returnObj = (item == nil) ? @"/" : (id)[item relativeNode];	
	return returnObj;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	return NO;	
}

	// customize each cell of outlineview
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSImage *folderIcon;
	MBOutlineViewCell *outlineCell = cell;
	NSUInteger row;
	row = [mPhotoOutlineView rowForItem:item];
	MBPhotoLibraryNode *node = [mPhotoOutlineView itemAtRow:row];
	
	NSURL *folderURL = [NSURL fileURLWithPath:[node fullPath]];
	folderIcon  = [[NSWorkspace sharedWorkspace] iconForFile:[folderURL path]];
	
	outlineCell.mFolderImage = [folderIcon retain];			// need to release
	outlineCell.mFolderName	= [[node relativeNode] retain] ;// need to release
}
#pragma mark -

#pragma mark OutlineView drag and drop methods
/* This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the outline view once this call returns with YES.  The items array is the list of items that will be participating in the drag.*/
- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pb
{
	mDraggedFolder = [[items objectAtIndex:0] fullPath];
	[pb setString:mDraggedFolder forType:(NSString*)kUTTypeFileURL];
	return YES;
}

/* This method is used by NSOutlineView to determine a valid drop target. Based on the mouse position, the outline view will suggest a proposed child 'index' for the drop to happen as a child of 'item'. This method must return a value that indicates which NSDragOperation the data source will perform. The data source may "re-target" a drop, if desired, by calling setDropItem:dropChildIndex: and returning something other than NSDragOperationNone. One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position). On Leopard linked applications, this method is called only when the drag position changes or the dragOperation changes (ie: a modifier key is pressed). Prior to Leopard, it would be called constantly in a timer, regardless of attribute changes. */
- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
	NSDragOperation result = NSDragOperationNone;
	NSPasteboard *pboard = [info draggingPasteboard];				// get the pasteboard
	
	if([[info draggingSource] isKindOfClass:[NSOutlineView class]]) // if dragged source is outlineview, then its outlineview to finder
	{
		NSURL *url = [NSURL URLFromPasteboard:pboard];
		BOOL valid, isDir;
		valid = [[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir];
		
		if(valid && isDir){
			if([[url path] isEqualToString:mDraggedFolder] && [[info draggingDestinationWindow] isNotEqualTo:[mPhotoOutlineView window]]){   
				result = NSDragOperationCopy;
			}
			else{       
				result = NSDragOperationNone; 
			}
		}
	}
	else{															// its finder to outlineview
		result = NSDragOperationCopy;
	}
	return result;
}

/* This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method. The data source should incorporate the data from the dragging pasteboard at this time. 'index' is the location to insert the data as a child of 'item', and are the values previously set in the validateDrop: method. */
- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index
{
	NSPasteboard *pboard = [info draggingPasteboard];
	NSURL *url = [NSURL URLFromPasteboard:pboard];		
	NSString *path = [url path];
	[self addCustomFolderPath:path];
	return YES;		
}
#pragma mark -

#pragma mark outline delegate method
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	@synchronized(self){			
		[mPhotoDataSource removeAllObjects];	
		[mFilteredPhotos removeAllObjects];	
	}
	mSearch = NO;
	mSearchThread = YES;
	mTempThread = YES;
	mPhotoThread = YES;	
		
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchPhotos) object:nil];
	[mPhotoView.mPhotoSelectionIndexes removeAllIndexes];
	
	unsigned row = [mPhotoOutlineView selectedRow];
	NSString *selectedRowFullPath = [[mPhotoOutlineView itemAtRow:row]fullPath];
	
	BOOL isExist = [mThumbPaths containsObject:[NSString stringWithFormat:@"%@%@",TEMPPATH,selectedRowFullPath]];
	
	[mLoadPhotosLabel setHidden:NO];
	[mLoadPhotos setHidden:NO];
	[mLoadPhotos startAnimation:self];
	[mLoadPhotosLabel setStringValue:@"Please Wait!! Loading Photos"];
	
	if(isExist){
		[self performSelector:@selector(loadThumbnails:) withObject:selectedRowFullPath afterDelay:0.1];
	}
	
	else if(!isExist){
		[self performSelector:@selector(loadLibraryPhotos:) withObject:selectedRowFullPath afterDelay:0.1];
	}

	if ([mPhotoDataSource count]==0){
		[mPhotoCountField setStringValue:[NSString stringWithFormat:@"%d photos",[mPhotoDataSource count]]];		
		[mPhotoView setNeedsDisplay:YES];
	}
}

- (void) loadThumbnails:(NSString *)selectedRowFullPath
{
	[NSThread detachNewThreadSelector:@selector(thumbnailsAtPath:) toTarget:self withObject:selectedRowFullPath];	
}

- (void) loadLibraryPhotos:(NSString *)selectedRowFullPath
{
	[NSThread detachNewThreadSelector:@selector(loadPhotosFromLibraryAtPath:) toTarget:self withObject:selectedRowFullPath];	
}

- (void)openLibraryPhotoPath:(id)sender
{
	int clickedRow = [mPhotoOutlineView clickedRow];
	NSString *selectedRowFullPath = [[mPhotoOutlineView itemAtRow:clickedRow] fullPath];
	
	BOOL pathFound = [[NSFileManager defaultManager] fileExistsAtPath:selectedRowFullPath];
	if(pathFound)
		[[NSWorkspace sharedWorkspace] openFile:selectedRowFullPath];
	else
		return;
}
#pragma mark -

#pragma mark PhotoView class methods implementation
- (NSInteger) numberOfPhotosInArray	
{
	if(mSearch)	{
		return [mFilteredPhotos count];
	}
	else {
		return [mPhotoDataSource count];
	}
}

- (NSImage *) photoAtIndex:(NSUInteger)index
{
	MBPhotoData *pNode;
	if(mSearch){
		pNode = [mFilteredPhotos objectAtIndex:index];
	}
	else {
		pNode = [mPhotoDataSource objectAtIndex:index];	
	}
	return pNode.mPhotoThumb;
}

- (NSString *) photoPathAtIndex : (NSUInteger)index
{
	MBPhotoData *pNode;
	if(mSearch){
		pNode = [mFilteredPhotos objectAtIndex:index];
	}
	else {
		pNode = [mPhotoDataSource objectAtIndex:index];	
	}
	return ([NSString stringWithFormat:@"%@/%@.%@",pNode.mPhotoPath,pNode.mPhotoTitle,pNode.mPhotoType]);
}

- (NSString *) photoTitleAtIndex: (NSUInteger)index
{
	MBPhotoData *pNode;
	if(mSearch){
		pNode = [mFilteredPhotos objectAtIndex:index];
	}
	else {
		pNode = [mPhotoDataSource objectAtIndex:index];	
	}
	return pNode.mPhotoTitle;	
}

- (void)upgradeFrameContentAndSize
{
	int photoCount;
	if(mSearch){
		photoCount = [mFilteredPhotos count];	
	}
	else {
		photoCount = [mPhotoDataSource count];
	}
	
    if (photoCount == 0) 
	{
		mPhotoView.mPhotoColumns = 0;
		mPhotoView.mPhotoRows = 0;
        float width = [mPhotoView frame].size.width;
        float height = [[[mPhotoView enclosingScrollView] contentView] frame].size.height;
        [mPhotoView setFrameSize:NSMakeSize(width, height)];
        return;
    }
    
		//calculating number of mPhotoColumns to draw
    float width = [mPhotoView frame].size.width;
	mPhotoView.mPhotoColumns = width / (mPhotoView.mPhotoSize.width + mPhotoView.mPhotoVerticalSpacing);
    
    if (mPhotoView.mPhotoColumns < 1)
        mPhotoView.mPhotoColumns = 1;
    
    if (photoCount < mPhotoView.mPhotoColumns)
		mPhotoView.mPhotoColumns = photoCount;
	
		//calculating number of rows to draw
	mPhotoView.mPhotoRows = photoCount / mPhotoView.mPhotoColumns;
	if ((photoCount % mPhotoView.mPhotoColumns) > 0)
		mPhotoView.mPhotoRows++;
	
    float height = mPhotoView.mPhotoRows * (mPhotoView.mPhotoSize.height + mPhotoView.mPhotoVerticalSpacing);
    
	NSScrollView *scroll = [mPhotoView enclosingScrollView];
	if ((scroll != nil) && (height < [[scroll contentView] frame].size.height)){
		height = [[scroll contentView] frame].size.height;	
	}
	[mPhotoView setFrameSize:NSMakeSize(width, height)];
	
	mPhotoView.mPhotoHorizontalSpacing = ([mPhotoView frame].size.width - mPhotoView.mPhotoColumns * mPhotoView.mPhotoSize.width)/ (mPhotoView.mPhotoColumns+1);
} 

	// PhotoView delegate method to perform opening a photo
- (void) openPhotoAtIndex: (NSUInteger)index
{
	NSWorkspace		*photoOpenWorkspace = [NSWorkspace sharedWorkspace];
	NSFileManager	*photoManager = [NSFileManager defaultManager];
	MBPhotoData		*pNode;
	NSString		*photoPath;	
	if(mSearch){
		pNode = [mFilteredPhotos objectAtIndex:index];
	}
	else {
		pNode = [mPhotoDataSource objectAtIndex:index]; 
	}
	photoPath = [NSString stringWithFormat:@"%@/%@.%@",pNode.mPhotoPath,pNode.mPhotoTitle,pNode.mPhotoType];
	
	BOOL photoFound = [photoManager fileExistsAtPath:photoPath];
	if(photoFound)
		[photoOpenWorkspace openFile:photoPath withApplication:nil andDeactivate:NO];
	else
		return;
}

- (void) revealPhotoInFinderAtIndex:(NSUInteger)index
{
	NSWorkspace		*photoOpenWorkspace = [NSWorkspace sharedWorkspace];
	NSFileManager	*photoManager = [NSFileManager defaultManager];
	MBPhotoData		*pNode;
	NSString		*photoPath;	
	if(mSearch){
		pNode = [mFilteredPhotos objectAtIndex:index];
	}
	else {
		pNode = [mPhotoDataSource objectAtIndex:index]; 
	}
	photoPath = [NSString stringWithFormat:@"%@/%@.%@",pNode.mPhotoPath,pNode.mPhotoTitle,pNode.mPhotoType];
	
	BOOL photoFound = [photoManager fileExistsAtPath:photoPath];
	if(photoFound)
		[photoOpenWorkspace selectFile:photoPath inFileViewerRootedAtPath:@""];
	else
		return;
}

- (void) quickLookPhotoAtIndex:(NSUInteger)index
{
	MBPhotoData		*pNode;
	NSString		*photoPath;
	if(mSearch){
		pNode = [mFilteredPhotos objectAtIndex:index];
	}
	else {
		pNode = [mPhotoDataSource objectAtIndex:index]; 
	}
	photoPath = [NSString stringWithFormat:@"%@/%@.%@",pNode.mPhotoPath,pNode.mPhotoTitle,pNode.mPhotoType];
	
	if(photoPath){
        NSPasteboard *pboard = [NSPasteboard pasteboardWithUniqueName];
        [pboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
        [pboard setString:photoPath forType:NSStringPboardType];
        NSPerformService(@"Finder/Show Info", pboard);		
    }
	
}
#pragma mark -

#pragma mark outlineViewSubClass Methods
- (BOOL) isFolderEditable
{
	NSUInteger row = [mPhotoOutlineView selectedRow];
	NSString *path = [[mPhotoOutlineView itemAtRow:row]fullPath];  
	BOOL retVal = NO;
	if(path){
		for(int i=0; i<[mPhotoLibraryPaths count]; i++){
			NSDictionary *inDict = [mPhotoLibraryPaths objectAtIndex:i];
			NSString *inPath = [inDict objectForKey:@"Filepath"];
			BOOL flag = [[inDict objectForKey:@"isEditable"] boolValue]; 
			if([inPath isEqualToString:path] && flag){
				retVal =  YES;
			}
		}
	}
	else{
		retVal = NO;	
	}
	return retVal;
}

- (void)addCustomFolders
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanCreateDirectories:YES];
	[openPanel setCanChooseFiles:NO];
	[openPanel setPrompt:@"Add"];
    
    if ([openPanel runModalForDirectory:NULL file:NULL types:NULL] == NSOKButton){
        NSString *folderPath = [openPanel filename];
		[self addCustomFolderPath:folderPath];
	}
}

- (void)removeCustomFolders
{
	NSUInteger row = [mPhotoOutlineView selectedRow];
	NSString *path = [[mPhotoOutlineView itemAtRow:row]fullPath];   //get the fullpath for item selected in outlineview
	
	for(int i=0; i<[mPhotoLibraryPaths count]; i++){
		NSDictionary *inDict = [mPhotoLibraryPaths objectAtIndex:i];
		NSString *inPath = [inDict objectForKey:@"Filepath"];
		BOOL flag = [[inDict objectForKey:@"isEditable"] boolValue]; //delete item only if it is editable		
		BOOL isExist = [mThumbPaths containsObject:[NSString stringWithFormat:@"%@%@",TEMPPATH,path]];
		
		if([inPath isEqualToString:path] && flag && isExist)
		{
			[mThumbPaths removeObject:[NSString stringWithFormat:@"%@%@",TEMPPATH,path]];
			[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@",TEMPPATH,path] error:nil];
			[mPhotoLibraryPaths removeObjectAtIndex:i];
			
			[mRetrieveMDButton setHidden:NO];
			[mPredicateEditorScroll setHidden:YES];
//			[mSearchTextBar setHidden:YES];
			
			[mPhotoOutlineView reloadData];
			[mPhotoOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:[mPhotoLibraryPaths count]-1] byExtendingSelection:NO];	// sets selection to previous item of deleted item in outlineview
		}
	}
	[NSThread detachNewThreadSelector:@selector(loadPhotos) toTarget:self withObject:nil];
}

- (void) reloadItem
{
	[mPhotoDataSource removeAllObjects];
	mSearchThread = YES;
	mSearch = NO;
	[mLoadPhotos stopAnimation:self];
	[mLoadPhotosLabel setHidden:NO];
	[mLoadPhotos setHidden:NO];
	[mLoadPhotos startAnimation:self];
	[mLoadPhotosLabel setStringValue:@"Please Wait!! Loading Photos"];
	
	NSString *selectedRowFullPath = [[mPhotoOutlineView itemAtRow:[mPhotoOutlineView selectedRow]]fullPath];
	[NSThread detachNewThreadSelector:@selector(loadPhotosFromLibraryAtPath:) toTarget:self withObject:selectedRowFullPath];
}

- (void) showItemInfoInFinder
{
	NSString *selectedRowFullPath = [[mPhotoOutlineView itemAtRow:[mPhotoOutlineView selectedRow]] fullPath];
	
	BOOL pathFound = [[NSFileManager defaultManager] fileExistsAtPath:selectedRowFullPath];
	if(pathFound)
		[[NSWorkspace sharedWorkspace] selectFile:selectedRowFullPath inFileViewerRootedAtPath:@""];
	else
		return;	
}

- (void) photoView:(MBPhotoView *)view fillPasteboardForDrag:(NSPasteboard *)pboard
{
	NSMutableArray *items = [NSMutableArray array];
	NSUInteger photoIndex = [mPhotoView.mPhotoSelectionIndexes firstIndex];
	MBPhotoData	*pNode;	
	
	if (mSearch) {
		while (photoIndex != NSNotFound) {
			pNode = [mFilteredPhotos objectAtIndex:photoIndex];
			[items addObject:pNode];
			photoIndex = [mPhotoView.mPhotoSelectionIndexes indexGreaterThanIndex:photoIndex];
		}		
	}
	else {
		while (photoIndex != NSNotFound) {
			pNode = [mPhotoDataSource objectAtIndex:photoIndex];
			[items addObject:pNode];
			photoIndex = [mPhotoView.mPhotoSelectionIndexes indexGreaterThanIndex:photoIndex];
		}
	}
	[self writeItems:items toPasteboard:pboard];
}
#pragma mark -

#pragma mark main thread methods
- (void) displaySearchStatus:(NSNumber*)searchCount
{
	[mLoadPhotosLabel setStringValue:[NSString stringWithFormat:@"Loading %d out of %d photos",[searchCount intValue],mTotalSearchCount]];
	if ([searchCount intValue] == mTotalSearchCount) {
		[mLoadPhotos setHidden:YES];
		[mLoadPhotos stopAnimation:self];
		[mLoadPhotosLabel setHidden:YES];
		[mDBObj endTransaction];
	}
}

- (void) refreshPhotoView :(NSNumber *)countValue
{
	if (mSearch) {
		if([mFilteredPhotos count]==1){
			[mPhotoCountField setStringValue:[NSString stringWithFormat:@"%d photo",[mFilteredPhotos count]]];	
		}
		else {
			[mPhotoCountField setStringValue:[NSString stringWithFormat:@"%d photos",[mFilteredPhotos count]]];		
		}
	}
	
	else {
		if([mPhotoDataSource count]==1){
			[mPhotoCountField setStringValue:[NSString stringWithFormat:@"%d photo",[mPhotoDataSource count]]];	
		}
		else {
			[mPhotoCountField setStringValue:[NSString stringWithFormat:@"%d photos",[mPhotoDataSource count]]];		
		}
	}
	[mPhotoView setNeedsDisplay:YES];
}

- (void) didEndWritingToDatabase:(NSNumber*)dirCount 
{
	[mFileCountField setStringValue:[NSString stringWithFormat:@"Writing %d record out of %d to database",[dirCount intValue],mTotalPhotosCount]];	
	if (mTotalPhotosCount == [dirCount intValue]) {

		[[NSNotificationCenter defaultCenter] postNotificationName:@"kEndMetaDataWindow" object:nil];
				
		[mDBObj endTransaction];
		
		mPhotoCount = 0;
		[mRetrieveMDButton setHidden:YES];
		
		[mPredicateEditorScroll setHidden:NO];
		[[mPredicateEditor enclosingScrollView] setHasVerticalScroller:NO];
		[mPredicateEditor addRow:self];
		[mSearchTextBar setHidden:NO];
	}
}
#pragma mark

#pragma mark database store and fetch methods
- (IBAction)retrieveMetaData:(id)sender
{	
	[mDBObj initDatabase];
	[mDBObj resetDatabase];
	[mDBObj startTransaction];
	
	[mWriteMetaData startAnimation:self];
	[mWriteMetaData incrementBy:100];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kStartMetaDataWindow" object:nil];
	[NSThread detachNewThreadSelector:@selector(getMetaDataInfo) toTarget:self withObject:nil];
}

- (void) getMetaDataInfo
{
	NSAutoreleasePool	*pool = [[NSAutoreleasePool alloc]init];
	NSString			*path = @"";
	NSDictionary		*dict = nil;
	
	for(int i=0; i<[mPhotoLibraryPaths count]; i++){
		dict = [mPhotoLibraryPaths objectAtIndex:i];
		path = [dict objectForKey:@"Filepath"];
		if ([[path lastPathComponent] isEqualToString:@"Pictures"]) {
			path = [NSString stringWithFormat:@"%@/Pictures",NSHomeDirectory()];
		}
		[self filesAtPath:path];
	}
	[pool release];
}

- (IBAction) cancelMetaData:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kEndMetaDataWindow" object:nil];
	[mDBObj endTransaction];
}

- (void) filesAtPath:(NSString *)path
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	NSFileManager	*folderManager = [NSFileManager defaultManager];
	NSArray			*folderContents = nil;
	NSString		*filePath = @"";
	NSString		*fileType = @"";
	NSArray			*keys = [NSArray arrayWithObjects:NSURLIsHiddenKey, NSURLContentAccessDateKey, nil];	
	NSDictionary	*fileValues = nil;
	NSURL			*urlPath = nil;
	NSMutableDictionary *photoDetails = [NSMutableDictionary dictionary];
	
	folderContents = [folderManager contentsOfDirectoryAtPath:path error:nil];
	
	for(int i=0; i<[folderContents count]; i++){
		filePath = [NSString stringWithFormat:@"%@/%@",path,[folderContents objectAtIndex:i]];
		BOOL isDir, valid = [folderManager fileExistsAtPath:filePath isDirectory:&isDir];
		[[NSWorkspace sharedWorkspace] getInfoForFile:filePath application:nil type:&fileType];
		
		urlPath = [NSURL fileURLWithPath:filePath];
		fileValues= [urlPath resourceValuesForKeys:keys error:nil];
		NSUInteger hiddenValue = [[fileValues objectForKey:NSURLIsHiddenKey]intValue];
		@synchronized(self){
			if(valid && !isDir && [mPhotoTypes containsObject:[fileType lowercaseString]] && !hiddenValue){
				MDItemRef mMetaDataInspector = MDItemCreate(kCFAllocatorDefault, (CFStringRef)filePath);
				if(mMetaDataInspector){
					CFArrayRef		mFileAttributeNames = MDItemCopyAttributeNames(mMetaDataInspector);
					CFDictionaryRef	mFileAttributeValues = MDItemCopyAttributes(mMetaDataInspector,mFileAttributeNames);
					
					NSString *fileName = [(NSDictionary*)mFileAttributeValues objectForKey:@"kMDItemFSName"];
					NSUInteger size = [[(NSDictionary*)mFileAttributeValues objectForKey:@"kMDItemFSSize"]intValue];
					NSDate *creationDate = [(NSDictionary*)mFileAttributeValues objectForKey:@"kMDItemFSCreationDate"];
					NSDate *modifiedDate = [(NSDictionary*)mFileAttributeValues objectForKey:@"kMDItemContentModificationDate"];
					NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
					[dateFormat setDateFormat:@"YYYY-MM-dd"];
					NSString *cDateString = [dateFormat stringFromDate:creationDate];
					NSString *mDateString = [dateFormat stringFromDate:modifiedDate];
					if ([mDateString length] == 0) {
						mDateString = cDateString;	
					}
					
					[photoDetails setObject:filePath forKey:@"Filepath"];
					[photoDetails setObject:[[fileName stringByDeletingPathExtension]lowercaseString] forKey:@"Filename"];
					[photoDetails setObject:[fileType lowercaseString] forKey:@"Filetype"];
					[photoDetails setObject:[NSNumber numberWithInt:size] forKey:@"Size"];
					[photoDetails setObject:cDateString forKey:@"CreationDate"];
					[photoDetails setObject:mDateString forKey:@"ModifiedDate"];
				
					[mDBObj insertPhotoInfoToDatabase:photoDetails];					
					mPhotoCount++;
					
					[self performSelectorOnMainThread:@selector(didEndWritingToDatabase:) withObject:[NSNumber numberWithInt:mPhotoCount] waitUntilDone:NO];		
					
					[dateFormat release];
					CFRelease(mFileAttributeNames);
					CFRelease(mFileAttributeValues);
					CFRelease(mMetaDataInspector);
				}
			}
		}
		if(isDir && !hiddenValue){
			[self filesAtPath:filePath];
		}
	}	
	[pool release];		
}
#pragma mark -

#pragma mark search methods
- (IBAction) predicateEditorChanged:(id)sender
{	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchPhotos) object:nil];
	[self performSelector:@selector(searchPhotos) withObject:nil afterDelay:0.2];
}

- (void) searchPhotos
{
	[mPhotoView.mPhotoSelectionIndexes removeAllIndexes];
	mTotalSearchCount = 0;
	
	NSPredicate *predicate = [mPredicateEditor objectValue];
	
	NSString *predString = [NSString stringWithFormat:@"%@",predicate];
	NSArray *predicateParts = [predString componentsSeparatedByString:@" "]; 	
	NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
	
	if (![[[predicateParts objectAtIndex:2]stringByTrimmingCharactersInSet:cSet] isEqualToString:@""]) {
		@synchronized(self){
			mSearchThread = YES;
			mPhotoThread = YES;
			mTempThread = YES;
		}

		predicateParts = [self formattedPartsFromPredicate:predicateParts];
		NSString *query = [self queryStringForSearch:predicateParts];
				
		[mDBObj openDatabase];
		
		NSMutableArray *queryResult = [[mDBObj executeSQLQuery:query]retain];
		mTotalSearchCount = [queryResult count];
		
		[self performSelector:@selector(displaySearchResult:) withObject:[queryResult autorelease] afterDelay:0.1];		
	}
	else {
		return;
	}
}

- (NSArray *)formattedPartsFromPredicate:(NSArray*)unFormattedParts
{
	NSMutableArray *formattedParts = [[NSMutableArray alloc]init];
	NSCharacterSet *aSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
	NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"CAST(,"];
	NSCharacterSet *wSet = [NSCharacterSet characterSetWithCharactersInString:@" "];	
		
	NSString *operand1 = @"";
	NSString *operand2 = @"";
	NSString *operator = @"";	
		
	operand1 = [unFormattedParts objectAtIndex:0];
	if ([operand1 isEqualToString:@"#Size"]){
		operand1 = @"Size";
	}
	
	operator = [unFormattedParts objectAtIndex:1];
	
	if ([unFormattedParts count]>3) {
		for(int i = 2; i < [unFormattedParts count]; i++){
			if ([operand1 isNotEqualTo:@"CreationDate"] || [operand1 isNotEqualTo:@"ModifiedDate"]) {
				operand2 = [NSString stringWithFormat:@"%@ %@",[operand2 stringByTrimmingCharactersInSet:wSet],[[unFormattedParts objectAtIndex:i]stringByTrimmingCharactersInSet:wSet]];	
			}
		}
	}
	else {
		operand2 = [unFormattedParts objectAtIndex:2];
	}
	
	if ([operand1 isEqualToString:@"CreationDate"] || [operand1 isEqualToString:@"ModifiedDate"]) {
		NSString *unixTimeStamp = [[unFormattedParts objectAtIndex:2]stringByTrimmingCharactersInSet:cSet];			
		mDate = CFDateCreate(kCFAllocatorDefault, [unixTimeStamp intValue]);
		mCurrentLocale = CFLocaleCopyCurrent();
		mDateFormatter = CFDateFormatterCreate(NULL,mCurrentLocale,kCFDateFormatterMediumStyle,0);
		
		CFDateFormatterSetFormat(mDateFormatter, CFSTR("YYYY-MM-dd"));
		
		mFormattedString = CFDateFormatterCreateStringWithDate(NULL, mDateFormatter, mDate);
		operand2 = (NSString*)mFormattedString;
	}
		
	operand2 = [[operand2 stringByTrimmingCharactersInSet:aSet]lowercaseString];
	[formattedParts addObject:operand1];
	[formattedParts addObject:operator];
	[formattedParts addObject:operand2]; 
		
	return [formattedParts autorelease];
}

- (NSString *)queryStringForSearch:(NSArray*)expParts
{	
	NSString *anyChar = @"%";
	NSString *operand1 = [expParts objectAtIndex:0];
	NSString *operator = [expParts objectAtIndex:1];
	NSString *operand2 = [expParts objectAtIndex:2];
	NSString *queryString = @"";
			
	if([operator isEqualToString:@"IN"]){
		queryString = [NSString stringWithFormat:@"select * from PHOTO_DETAILS where %@ LIKE '%@%@%@'",operand1, anyChar, operand2, anyChar];
	}
	if([operator isEqualToString:@"=="]){
		queryString = [NSString stringWithFormat:@"select * from PHOTO_DETAILS where %@ = '%@'",operand1, operand2];
	}
	if([operator isEqualToString:@"BEGINSWITH"]){
		queryString = [NSString stringWithFormat:@"select * from PHOTO_DETAILS where %@ LIKE '%@%@'",operand1, operand2, anyChar];
	}
	if([operator isEqualToString:@"ENDSWITH"]){
		queryString = [NSString stringWithFormat:@"select * from PHOTO_DETAILS where %@ LIKE '%@%@'",operand1, anyChar, operand2];
	}
	if([operator isEqualToString:@"<"]){
		queryString = [NSString stringWithFormat:@"select * from PHOTO_DETAILS where %@ < '%@'",operand1, operand2];
	}
	if([operator isEqualToString:@">"]){
		queryString = [NSString stringWithFormat:@"select * from PHOTO_DETAILS where %@ > '%@'",operand1, operand2];
	}
	
	return queryString;
}

- (void) displaySearchResult:(NSMutableArray *)queryResult
{	
	[NSThread detachNewThreadSelector:@selector(showSearchResult:) toTarget:self withObject:queryResult];					
}

- (void)showSearchResult:(NSMutableArray *)queryresult
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];	
	NSMutableArray *result = [queryresult retain];
	@synchronized(self){
		mSearchThread = NO;	
		mSearch = YES;
		[mFilteredPhotos removeAllObjects];
		[mPhotoDataSource removeAllObjects];		
	}
	[mLoadPhotos setHidden:NO];
	[mLoadPhotos startAnimation:self];
	[mLoadPhotosLabel setHidden:NO];
	[mLoadPhotosLabel setStringValue:@""];	
	
	for(int start = 0; start < [result count]; start++){
		if (mSearchThread) {
			break;
		}
		[self createThumbnailFromPhotoDetails:[result objectAtIndex:start]];	
	}
	
	if (!mTotalSearchCount) {
		[self refreshPhotoView:nil];
		[mLoadPhotos stopAnimation:self];
		[mLoadPhotos setHidden:YES];
	}
	[result release];
	[pool release];
}
#pragma mark -

#pragma mark dealloc
- (void) dealloc
{
	[mPhotoDataSource release];
	[mFilteredPhotos release];
	[mThumbPaths release];
		
	if (mPhotoLibraryPaths) {
		[mPhotoLibraryPaths release];
		mPhotoLibraryPaths = nil;
	}
	if (mTemporaryPath) {
		[mTemporaryPath release];
		mTemporaryPath = nil;
	}
	[mPhotoTypes release];
		if (mDraggedFolder!=nil) {
		mDraggedFolder = nil;	
	}	
	mDBObj = nil;
	
	CFRelease(mDate);
	CFRelease(mCurrentLocale);
	CFRelease(mDateFormatter);
	CFRelease(mFormattedString);		
	
	[super dealloc];
}
@end
