//
//  MBOutlineView.h
//  Media Browser
//
//  Created by Sandeep GS on 28/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol OutlineViewObjectDelegate;

@interface MBOutlineView : NSOutlineView {
	NSObject <OutlineViewObjectDelegate> *mOutlineDelegate;
}
	//Property Declaration
@property (nonatomic, assign) NSObject <OutlineViewObjectDelegate>	*mOutlineDelegate;

@end
	//	Protocol delegate methods to implement
@protocol OutlineViewObjectDelegate <NSObject>
- (void) showItemInfoInFinder;
- (void) addCustomFolders;
- (void) removeCustomFolders;
- (void) reloadItem;
- (BOOL) isFolderEditable;
@end
