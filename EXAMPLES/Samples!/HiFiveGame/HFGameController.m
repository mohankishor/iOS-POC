//
//  HFGameController.m
//  HiFiveGame
//
//  Created by Devika on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HFGameController.h"
#import "PlayerInformation.h"
#import "NSString+FindIndex.h"


@implementation HFGameController
@synthesize mWindow;

NSString *kUserColor=@"UserColor";
NSString *kComputerColor=@"ComputerColor";
//@synthesize namePanel;
+(void)initialize
{
	if (self==[HFGameController class]) {
	
		NSMutableDictionary *dict=[NSMutableDictionary dictionary];
	NSColor *userColor=[NSColor redColor];
	NSData *userButtonColor=[NSArchiver archivedDataWithRootObject:userColor];
	//[[NSUserDefaults standardUserDefaults]setObject:userButtonColor forKey:kUserColor];
	NSColor *compColor=[NSColor blueColor];
	NSData *computerButtonColor=[NSArchiver archivedDataWithRootObject:compColor];
		[dict setObject:userButtonColor forKey:kUserColor];
		[dict setObject:computerButtonColor forKey:kComputerColor];
		[[NSUserDefaults standardUserDefaults]registerDefaults:dict];
	
	}
	
}


-(id)init
{
	if(self == [super init])
	{
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setName:) name:@"NameChangedNotification" object:nil];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationTerminates:) name:@"NSWindowWillCloseNotification" object:nil];

		mHFModelObj  =  [[HifiveModel alloc]init];
		[mFirstPlayer addItemWithObjectValue:@"User"];
		//mEndTime        = [[NSMutableString alloc]init];
		_Hour          =  0;
		_Min           =  0;
		_Second        =  0;
		_FirstClick     =  0;
		_WinFlag	     =  0;
		//mPanelFlag     =  1;
		_TimeFlag		 =	0;
		_GameLevel=0;
		
		_PlayerColorWell=[[NSColorWell alloc]init];
		[_PlayerColorWell setColor:[NSColor redColor]];
		_ComputerColorWell=[[NSColorWell alloc]init];
		[_ComputerColorWell setColor:[NSColor blueColor]];
		_Row=0;
		_column=0;
		
		
		for(int i=0;i<15;i++)
		{
			for(int j=0;j<15;j++)
			{
				ColorButton *button=[[ColorButton alloc]init];
				[button setMColor:[NSColor grayColor]];
				[mButtonCells putCell:button atRow:i column:j];
				[button release];
			}
		}
		_PlayerButtonColor=[[NSColor alloc]init];
		_ComputerButtonColor=[[NSColor alloc]init];
		//_ComputerButtonColor=[NSColor blueColor];
		//_PlayerButtonColor=[NSColor redColor];
	
		NSData *compColor=[[NSUserDefaults standardUserDefaults]objectForKey:kComputerColor];
		NSData *playerColor=[[NSUserDefaults standardUserDefaults]objectForKey:kUserColor];
		_ComputerButtonColor=(NSColor*)[NSUnarchiver unarchiveObjectWithData:compColor];
		_PlayerButtonColor=(NSColor*)[NSUnarchiver unarchiveObjectWithData:playerColor];
				
		_Patterns=[[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Patterns" ofType:@"plist"]];
		_Container=[[NSArray alloc]init];
		
	}
	
 	return self;
}


- (void) awakeFromNib
{
	[mButtonCells setEnabled:NO];
	[mUserCell setEnabled:NO];
	[mComputerCell setEnabled:NO];
	[mComputerCell setMColor:_ComputerButtonColor];
	[mUserCell setMColor:_PlayerButtonColor];
	[pWell setMColor:_PlayerButtonColor];
	[compWell setMColor:_ComputerButtonColor];
	[mgameLevel selectItemAtIndex:0];
	[mPlayer selectItemAtIndex:0];
}

-(void) dealloc
{
	
	[_ComputerColorWell release];
	[_PlayerColorWell release];
	[_PlayerButtonColor release];
	[_ComputerButtonColor release];
	
	[mHFModelObj release];
	[super dealloc];
}


#pragma mark -
#pragma mark USer and Computer playing 
-(IBAction)userClicked:(id)sender
{
//	[mUserCell setMColor:[NSColor redColor]];
	if (_TimeFlag==0 && _TimeFlag!=2)
	{
		_TimeFlag=2;
		_timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(genrateTimer) userInfo:nil repeats:YES];
	}
	_FirstClick  =  1;
	[mPlayerName setStringValue:@"computer's turn"];
	
	int row     =  [sender selectedRow];
	NSLog(@"Selected row:%d",[sender selectedRow]);
	int column  =  [[sender selectedCell] tag];
	if (row==0 && column ==0) {
		_Row=7;
		_column=7;
	}
	else
	{
		_Row=_Row;
		_column=_column;
		
	}
	[[sender selectedCell]setMColor:_PlayerButtonColor];
	//[[sender selectedCell]setMColor:[NSColor redColor]];
	[[sender selectedCell]setEnabled:NO];
	[[sender selectedCell]setImageDimsWhenDisabled:NO];
	NSInteger n =  [mHFModelObj addToContainerAtColumn:column andRow:row setFlag:@"1"];
	if (n) {
		_WinFlag=1;
		NSArray *buttonArray  = [mButtonCells cells];
		ColorButton *bcell;
		[mButtonCells setEnabled:NO];
		for(bcell in buttonArray)
			
		{
			[bcell setEnabled:NO];
			[bcell setImageDimsWhenDisabled:NO];
			
			NSString *winner      = @"You Won the game";
			//int n=NSRunAlertPanel(@"WON", winner, @"OK", nil, nil);
			int n = NSRunAlertPanel(@"WON", winner, @"Continue", @"Quit",nil);
			NSLog(@"%d is panel value",n);
			
			[mPlayerName setStringValue:@""];
			[_timer invalidate];
			_timer=nil;
			if (n==1) {
				[self playNewGame];
			}
			if(n==0)
				//[NSApp endSheet:mWindow];
				[mWindow orderOut:self];
			   return;
		}
		
	}
	[mButtonCells setEnabled:NO];
	[NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(compPlay) userInfo:nil repeats:NO];
	
	
}


-(void)compPlay
{
	
	if (_TimeFlag==1 && _TimeFlag!=2) 
	{
		_timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(genrateTimer) userInfo:nil repeats:YES];
		_TimeFlag=2;
	}
	_FirstClick  =  1;
	[mPlayerName setStringValue:@"computer's turn"];
	
	NSDictionary *res   =  [self findRowAndColumn];
	NSString *sRow      =  [res objectForKey:@"Row"];
	NSString *sCol      =  [res objectForKey:@"Column"];
	int result          =  [[res objectForKey:@"Result"]intValue];
	int col             =  [sCol intValue];
	int row             =  [sRow intValue];
	
	NSLog(@"row %@ col %@",sRow,sCol);
		//
	ColorButton *bcell =  [mButtonCells cellAtRow:row column:col];
		[bcell setMColor:_ComputerButtonColor];
	[bcell setImageDimsWhenDisabled:NO];
	[mButtonCells putCell:bcell atRow:row column:col];
	[bcell setEnabled:NO];
	
	if(result==1)
	{
		_WinFlag=1;
		NSArray *buttonArray  = [mButtonCells cells];
		ColorButton *bcellToHide;
		
		for(bcellToHide in buttonArray)
		{
			[bcellToHide setEnabled:NO];
			[bcellToHide setImageDimsWhenDisabled:NO];
		}
		NSString *winner = @"You lost the game";
		//NSRunAlertPanel(@"WON", winner, @"OK", nil, nil);
		int n = NSRunAlertPanel(@"WON", winner, @"Continue", @"Quit",nil);
		NSLog(@"%d is panel value",n);

		[mPlayerName setStringValue:@""];
		[_timer invalidate];
		_timer=nil; 
		if (n==1) {
			[self playNewGame];
		}
		if(n==0)
						[mWindow orderOut:self];
					return;
	}
	
	for(int i=0;i<15;i++)
	{
		for(int j=0;j<15;j++)
			if ([self checkCellforRow:i andColumn:j] )
			{
				[[mButtonCells cellAtRow:i column:j]setEnabled:YES];
			}
	}
	NSString *palyer   =   [[NSString alloc]initWithFormat:@"%@'s Turn",_PlayerName];
	[mPlayerName setStringValue:palyer];
}

#pragma mark new game
-(IBAction)newGame:(id)sender
{ 
	if (mWindow==nil) {
		NSLog(@"Window is closed");
		
	}
	[mWindow orderOut:self];
	[NSApp beginSheet:mWindow modalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[self playNewGame];
	[NSApp endSheet:mWindow];
	//[name release];
}
-(void)playNewGame
{
	//[self genrateTimer];
	NSArray *buttonArray  = [mButtonCells cells];
	ColorButton *bcell;
	//[mButtonCells setEnabled:YES];
	for(bcell in buttonArray)
		
	{
		
		[bcell setMColor:[NSColor grayColor]];
		[bcell setEnabled:YES];
	}
	
	_TimeFlag		 =	0;
	[mButtonCells setEnabled:YES];
	_WinFlag=0;
	_Second=0;
	_Min=0;
	_Hour=0;
	_FirstClick=0;
	
	[mTimerValue setStringValue:@""];
	[mHFModelObj release];
	mHFModelObj=[[HifiveModel alloc]init]; 
	//[self genrateTimer];
	
}
#pragma mark -
#pragma mark set the preference
-(IBAction)setPrefference:(id)sender
{
	if (_FirstClick) {
		NSRunAlertPanel(@"", @"you have to set the preference before playing" , @"OK", nil, nil);
		return ;
	}
	[NSApp beginSheet:mpreferencePanel modalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
	
	
}

-(IBAction)setFirstPlayer:(id)sender
{
		_PlayerButtonColor=pWell.mColor;
      _ComputerButtonColor=compWell.mColor;
	[mComputerCell setMColor:_ComputerButtonColor];
	[mUserCell setMColor:_PlayerButtonColor];
	if([mPlayer indexOfSelectedItem]==1)
	{
		[mPlayerName setStringValue:@"Computer's turn"];
		//[self compPlay];
		_TimeFlag=1;
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(compPlay) userInfo:nil repeats:NO];
	}
	else
		[mPlayerName setStringValue:@"player's turn"];
	
	[mpreferencePanel orderOut:self];
	[NSApp endSheet:mpreferencePanel];
}



#pragma mark Time 
-(void) genrateTimer
{
	_Time  =  [[NSMutableString alloc]init];
	
	_Second++;
	if (_Second==59) 
	{
		_Min++;
		_Second=0;
		if (_Min==59) 
		{
			_Hour++;
			_Min=0;
			if (_Hour>24) 
			{
				_Hour=0;
				
			}
		}
	}
	NSString *minString;
	if (_Min<10)
	{
		minString     =  [[NSString alloc]initWithFormat:@"0%d",_Min];
	}
	else
	{
		minString     =  [[NSString alloc]initWithFormat:@"%d",_Min];
	}
	NSString *secondString;
	if (_Second<10) 
	{
		secondString  =  [[NSString alloc]initWithFormat:@"0%d",_Second];
	}
	else
	{
		secondString  =  [[NSString alloc]initWithFormat:@"%d",_Second];
	}
	NSString *hourString;
	if (_Hour<10)
	{
		hourString    =  [[NSString alloc]initWithFormat:@"0%d",_Hour];
	}
	else
	{
		hourString    =  [[NSString alloc]initWithFormat:@"%d",_Hour];
	}
	[_Time appendFormat:@"Total time: %@:%@:%@",hourString,minString,secondString];
	[mTimerValue setStringValue:_Time];
	[secondString release];
	[hourString release];
	[minString release];
}


-(void)endGame
{
	if (_WinFlag==0) {
		NSRunAlertPanel(@"Game Over",@"Game is over" , @"OK",nil,nil);
	}
}

#pragma mark -
#pragma mark Complexity
-(IBAction)setComplexity:(id)sender
{  
	[NSApp beginSheet:mComplexityPanel modalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
	
	}




-(IBAction)setLevel:(id)sender
{
	if ([mgameLevel indexOfSelectedItem]==1) {
		//[mHFModelObj setGameLevel :1];
		_GameLevel=1;
	}
	[mComplexityPanel orderOut:self];
	[NSApp endSheet:mComplexityPanel];
}



#pragma mark -
#pragma mark Finding the location
-(NSDictionary*)findRowAndColumn
{
	NSDictionary *resultDict;
	int res=0;
	int n=random()%15;
	NSLog(@"############Random no is %d",n);
	
	if (_GameLevel==1) 
	{
		
		for(int i=0;i<[_Patterns count];i++)
		{
			
			res=[self checkPatternForString:[_Patterns objectAtIndex:i]];
			if (res==1)
				break;
		}
		
	}
	else
	{
		int randomNo1=random()%15;
		int randomNo2=random()%15;
		int randomNo3=random()%15;
		for(int i=0;i<[_Patterns count];i++)
		{
			
			if(randomNo1!=i && randomNo2!=i && randomNo3!=i)
			{
				res=[self checkPatternForString:[_Patterns objectAtIndex:i]];
				if (res==1)
					break;
			}
			
		}
	}
	
	int winres=[mHFModelObj addToContainerAtColumn:_column andRow:_Row setFlag:@"2"];
	NSString *rowString=[[NSString alloc]initWithFormat:@"%d",_Row];
	NSString *columnString=[[NSString alloc]initWithFormat:@"%d",_column];
	NSString *winString=[[NSString alloc]initWithFormat:@"%d",winres];
	resultDict=[[NSDictionary alloc]initWithObjectsAndKeys:rowString,@"Row",columnString,@"Column",winString,@"Result",nil];
	[rowString release];
	[columnString release];
	[winString release];
	return [resultDict autorelease];
}
-(int)checkPatternForString:(NSString*)aPatternString
{
	
	int ret=0;
	int retVal=0;
	NSDictionary *Container                  =		[mHFModelObj getDictionary];	
	NSMutableArray *rowArray                 =		[Container objectForKey:@"Row"];
	NSMutableArray *_columnArray              =		[Container objectForKey:@"Column"];
	NSMutableArray *_leftdiagonalArray        =		[Container objectForKey:@"Left"];
	NSMutableArray *_rightdiagonalArray       =		[Container objectForKey:@"Right"];
	NSMutableArray *leftArray1               =		[Container objectForKey:@"LeftDiagonal1"];
	NSMutableArray *rightArray1              =		[Container objectForKey:@"Right1"];
	NSMutableArray *leftArray2               =		[Container objectForKey:@"LeftDiagonal2"];
	NSMutableArray *rightArray2              =		[Container objectForKey:@"Right2"];
	_Container=[Container objectForKey:@"Row"];
	NSMutableString *rightString             =[[NSMutableString alloc]init];
	for(int j=0;j<15;j++)
		[rightString appendFormat:@"%@",[_rightdiagonalArray objectAtIndex:j]];
	
	NSMutableString *leftString=[[NSMutableString alloc]init];
	for(int j=0;j<15;j++)
		[leftString appendFormat:@"%@",[_leftdiagonalArray objectAtIndex:j]];
	
	for(int i=0;i<15;i++)
	{
		NSString *checkString=[rowArray objectAtIndex:i];
		//retVal=[checkString findIndexOfString:aPatternString InString:checkString];
		retVal=[NSString findIndexOfString:aPatternString InString:checkString];
		if (retVal!=200 ) 
		{
			_Row=i;
			
			_column=retVal;
			ret=1;
			break;
			//return retVal;
			
		}
		
		

		
		else {
			
			NSString *checkString2=[_columnArray objectAtIndex:i];
		//	retVal=[checkString2 findIndexOfString:aPatternString InString:checkString2];
			retVal=[NSString findIndexOfString:aPatternString InString:checkString2];
			if (retVal!=200 ) 
			{
				//retVal=[self indexOfString:aPatternString InSourceString:checkString2];
				_Row=retVal;
				_column=i;
				ret=1;
				break;
				
			}
			
			
			NSString *checkStringforCol=[leftArray2 objectAtIndex:i];
			//retVal=[checkStringforCol findIndexOfString:aPatternString InString:checkStringforCol];
			retVal=[NSString findIndexOfString:aPatternString InString:checkStringforCol];
			if (retVal!=200 ) 
			{
				_Row=14-retVal;
				_column=retVal+i+1;
				NSLog(@"In leftArray2");
				if(_Row>=15 || _column >=15)
					continue;

				ret=1;
				break;
			}
				
			
			
			
			NSString *checkStringforCol1=[rightArray1 objectAtIndex:i];
				//	retVal=[checkStringforCol1 findIndexOfString:aPatternString InString:checkStringforCol1];
			retVal=[NSString findIndexOfString:aPatternString InString:checkStringforCol1];
			if (retVal!=200 ) 
			{
				if(i>retVal) 
					_Row=i-retVal;
				else
					_Row=retVal-i;	
				_column=14-retVal;
				NSLog(@"In rightArray1");
				if(_Row>=15 || _column >=15)
					continue;

				ret=1;
				break;
				
			}
			
			NSString *checkStringforCol2=[rightArray2 objectAtIndex:i];
			///retVal=[checkStringforCol2 findIndexOfString:aPatternString InString:checkStringforCol2];
			retVal=[NSString findIndexOfString:aPatternString InString:checkStringforCol2];

			if (retVal!=200 ) 
			{
				_Row=i+retVal;
				_column=retVal;
				NSLog(@"In rightArray2");
				if(_Row>=15 || _column >=15)
					continue;

				ret=1;
				break;
				
			}
			
			NSString *colPattern=[leftArray1 objectAtIndex:i];
			
			//retVal=[colPattern findIndexOfString:aPatternString InString:colPattern];
			retVal=[NSString findIndexOfString:aPatternString InString:colPattern];
			if (retVal!=200 ) 
			{
				if(i>retVal) 
					_Row=i-retVal;
				else 
					_Row=retVal-i;
				_column=retVal;
				NSLog(@"In rightArray2");
				if(_Row>=15 || _column >=15)
					continue;

				ret=1;
				break;
				
			}
			//retVal=[rightString findIndexOfString:aPatternString InString:rightString];
			retVal=[NSString findIndexOfString:aPatternString InString:rightString];
			
				if (retVal!=200) {
				_Row=14-retVal;
				_column=retVal;
					if(_Row>=15 || _column >=15)
						continue;

				ret=1;
					break;
			}
			
		
			//retVal=[leftString findIndexOfString:aPatternString InString:leftString];
			retVal=[NSString findIndexOfString:aPatternString InString:leftString];
			if (retVal!=200) {
				_Row=retVal;
				_column=retVal;
				if(_Row>=15 || _column >=15)
					continue;
				ret=1;
				break;
			}
		}
		
	}
	
	return ret;
}
-(int)checkCellforRow:(int)aRow andColumn:(int)aColumn
{
	NSDictionary *Container                  =		[mHFModelObj getDictionary];
	//NSDictionary *Container                  =		[mHFModelObj.mContainer];
	_Container=[Container objectForKey:@"Row"];
	NSMutableString *rowString=[_Container objectAtIndex:aRow];
	NSString *char1=[[NSString alloc]initWithFormat:@"%C",[rowString characterAtIndex:aColumn]];
	if ([char1 isEqualToString:@"3"]) {
		[char1 release];
		return 1;
	}
	[char1 release];
	return 0;
}

-(void)setName:(NSNotification *)aNotification
{
PlayerInformation *player=[aNotification object];
	
	if(player && player.mName)
	{
		_PlayerName=[[NSString alloc]initWithString:player.mName];
			[mButtonCells setEnabled:YES];
		NSString *playername=[[NSString alloc]initWithFormat:@"%@'sTurn",_PlayerName];
		[mPlayerName setStringValue:playername];
		[mComputerCell setMColor:_ComputerButtonColor];
		[mUserCell setMColor:_PlayerButtonColor];
		[pWell setMColor:_PlayerButtonColor];
		[compWell setMColor:_ComputerButtonColor];
	}
}
	
-(void)applicationTerminates:(NSNotification*)aNotification
{
	NSUserDefaults *defUser=[NSUserDefaults standardUserDefaults];
	NSData *userButtonColor=[NSArchiver archivedDataWithRootObject:_PlayerButtonColor];
	NSData *computerButtonColor=[NSArchiver archivedDataWithRootObject:_ComputerButtonColor];
	[defUser setObject:userButtonColor forKey:kUserColor];
	[defUser setObject:computerButtonColor forKey:kComputerColor];
	
 }

@end
