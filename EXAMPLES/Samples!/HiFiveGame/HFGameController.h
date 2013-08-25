//
//  HFGameController.h
//  HiFiveGame
//
//  Created by Devika on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HifiveModel.h"
#import "ColorButton.h"
#import "BoredredButton.h"

@interface HFGameController : NSObject {
	
	IBOutlet NSTextField *mPlayerName;
	IBOutlet NSComboBox *mFirstPlayer;
	IBOutlet NSTextField *mTimerValue;
	HifiveModel *mHFModelObj;
	IBOutlet NSMatrix *mButtonCells;
	IBOutlet NSComboBox *mgameLevel;
	IBOutlet NSComboBox *mPlayer;
	IBOutlet NSWindow *mWindow;
	IBOutlet NSPanel *mpreferencePanel;
	
	IBOutlet NSPanel *mComplexityPanel;
	IBOutlet BoredredButton *pWell;
	IBOutlet BoredredButton *compWell;
	IBOutlet BoredredButton *mComputerCell;
	IBOutlet BoredredButton *mUserCell;
	NSColorWell *_PlayerColorWell;
	NSColorWell *_ComputerColorWell;
	
	
	
@private
	int _Hour   ;       
	int _Min     ;      
	int _Second   ;     
	int _FirstClick ;    
	int _WinFlag	;   
	int _PanelFlag   ;  
	int _TimeFlag	;
	int _Row;
	int _column;
	int _GameLevel;
	NSTimer *_timer;
	NSColor *_PlayerButtonColor;
	NSColor *_ComputerButtonColor;
	NSString *_Name;
	NSMutableString *_Time;
	NSArray *_Patterns;
	NSArray *_Container;
	NSString *_PlayerName;
}
@property (nonatomic ,retain)IBOutlet NSWindow *mWindow;
-(IBAction)userClicked:(id)sender;
-(void)compPlay;
-(void)playNewGame;
-(IBAction)setPrefference:(id)sender;
-(IBAction)setFirstPlayer:(id)sender;
-(IBAction)newGame:(id)sender;
-(void) genrateTimer;
-(void)endGame;
-(IBAction)setComplexity:(id)sender;
-(IBAction)setLevel:(id)sender;
-(int)checkPatternForString:(NSString*)aPatternString;
-(NSDictionary*)findRowAndColumn;
-(int)checkCellforRow:(int)aRow andColumn:(int)aColumn;
-(void)setName:(NSNotification *)aNotification;
@end
