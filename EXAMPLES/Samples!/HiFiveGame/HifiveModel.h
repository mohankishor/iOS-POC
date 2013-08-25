//
//  HifiveModel.h
//  HiFiveGame
//
//  Created by Devika on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HifiveModel : NSObject {
	NSMutableDictionary *mContainer;
	NSMutableArray *mPatternArray;
	
	@private
	NSMutableArray *_containerArray;
	
	NSMutableArray *_leftdiagonalArray;
	NSMutableArray *_rightdiagonalArray;
	NSMutableArray *_columnArray;
	NSMutableArray *_lDiagonalArrayPart1;
	NSMutableArray *_lDiagonalArrayPart2;
	NSMutableArray *_rDiagonalArrayPart1;
	NSMutableArray *_rDiagonalArrayPart2;
}
@property(nonatomic,retain)NSDictionary *mContainer;
-(NSInteger)checkForWinForRow:(int)aRow setFlag:(NSString*)aFlag ForString:(NSString*)aString;
-(NSInteger)addToContainerAtColumn:(int)aColumn andRow:(int)aRow setFlag:(NSString*)aFlag;
-(void)createStringForRightSubDiagonalForRow:(int)aRow ForColumn:(int)aColumn withFlag:(NSString *)aFlag;

-(void)createStringForRow:(int)aRow ForColumn:(int)aColumn withFlag:(NSString *)aFlag;
-(NSDictionary*)getDictionary;

@end
