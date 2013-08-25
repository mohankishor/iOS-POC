//
//  HifiveModel.m
//  HiFiveGame
//
//  Created by Devika on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HifiveModel.h"


@implementation HifiveModel
@synthesize mContainer;

int winFlag=1;
-(id)init
{
	if (self==[super init]) 
	{
		
		_containerArray       =  [[NSMutableArray alloc]init];
		_lDiagonalArrayPart1       =  [[NSMutableArray alloc]init];
		_rDiagonalArrayPart1       =  [[NSMutableArray alloc]init];
		_lDiagonalArrayPart2       =  [[NSMutableArray alloc]init];
		_rDiagonalArrayPart2       =  [[NSMutableArray alloc]init];
		NSMutableString *temp  =  [[NSMutableString alloc]initWithString:@"333333333333333"]; 
		_leftdiagonalArray      =  [[NSMutableArray alloc]init];
		_rightdiagonalArray     =  [[NSMutableArray alloc]init];
		_columnArray            =  [[NSMutableArray alloc]init];
		for(int i=0;i<15;i++)
		{
			[_containerArray addObject:temp];
			[_leftdiagonalArray addObject:@"3"];
			[_rightdiagonalArray addObject:@"3"];
			[_columnArray addObject:temp];
			[_lDiagonalArrayPart1 addObject:temp];
			[_rDiagonalArrayPart1 addObject:temp];
			[_lDiagonalArrayPart2 addObject:temp];
			[_rDiagonalArrayPart2 addObject:temp];
		}
		[temp release];
		mContainer       =  [[NSMutableDictionary alloc]initWithObjectsAndKeys:_containerArray,@"Row",_lDiagonalArrayPart1,@"LeftDiagonal1",_lDiagonalArrayPart2,@"LeftDiagonal2",
							 _rDiagonalArrayPart1,@"Right1",_rDiagonalArrayPart2,@"Right2",_leftdiagonalArray,@"Left",
							 _rightdiagonalArray,@"Right",_columnArray,@"Column",nil];
		
	}
	return self;
}
-(NSInteger)addToContainerAtColumn:(int)aColumn andRow:(int)aRow setFlag:(NSString*)aFlag
{

	NSLog(@"Insert at row:%d column:%d",aRow,aColumn);
	NSMutableString *temp             =   [_containerArray objectAtIndex:aRow];
	NSString *part1                   =   [temp substringToIndex:aColumn];
	
	NSString *part2                   =   [temp substringFromIndex:aColumn+1];
	NSMutableString *completeString   =   [[NSMutableString alloc]initWithFormat:@"%@%@%@",part1,aFlag,part2];
	NSMutableString *temp2            =   [_columnArray objectAtIndex:aColumn];
	NSString *part1forCol             =   [temp2 substringToIndex:aRow];
	NSString *part2forCol             =   [temp2 substringFromIndex:aRow+1];
	NSMutableString *completeStringforCol = [[NSMutableString alloc]initWithFormat:@"%@%@%@",part1forCol,aFlag,part2forCol];
	
	NSLog(@"Part1 for Column=%@ npart for column=%@",part1forCol,part2forCol);
	NSLog(@"Changed String %@",completeString);
	NSLog(@"Changed String (column)%@",completeStringforCol);
	[_columnArray replaceObjectAtIndex:aColumn withObject:completeStringforCol];
	[completeStringforCol release];
	
	[_containerArray replaceObjectAtIndex:aRow withObject:completeString];
	
	[completeString release];
	[self createStringForRow:aRow ForColumn:aColumn withFlag:aFlag];
	[self createStringForRightSubDiagonalForRow:aRow ForColumn:aColumn withFlag:aFlag];
	int m  =  0;
	NSMutableString *str  =  [_containerArray objectAtIndex:aRow];
	m    =    [self checkForWinForRow:aRow setFlag:aFlag ForString:str];
	NSMutableString *str1    =    [[NSMutableString alloc]init];
	
	
	if (aRow==aColumn)
	{
		[_leftdiagonalArray replaceObjectAtIndex:aRow withObject:aFlag];
		
		for(int j=0;j<15;j++)
			[str1 appendFormat:@"%@",[_leftdiagonalArray objectAtIndex:j]];
		
		if (m==0) 
			m=[self checkForWinForRow:aRow setFlag:aFlag ForString:str1];
		
		NSLog(@"Diagonal:%@",str1);
		//[str1 release];
		
	}
	[str1 release];
	int lcol  =  0;		
	for(int lrow=14;lrow>=0;lrow--)
	{
		if (lcol==aColumn &&lrow ==aRow) 
		{
			[_rightdiagonalArray replaceObjectAtIndex:aColumn withObject:aFlag];
			
			break;
		}
		lcol++;
	}
	NSMutableString *str2=[[NSMutableString alloc]init];
	
	for(int j=0;j<15;j++)
		[str2 appendFormat:@"%@",[_rightdiagonalArray objectAtIndex:j]];
	
	NSLog(@"Right Diagonal :%@",str2);
	
	if(m==0)
		m=[self checkForWinForRow:aRow setFlag:aFlag ForString:str2];
	
	[str2 release];
	
	if (m==0) {
		//NSMutableString *strcol=[_columnArray objectAtIndex:aColumn];
       // m=[self checkForWinForRow:aColumn setFlag:aFlag ForString:strcol];
		 m=[self checkForWinForRow:aColumn setFlag:aFlag ForString:[_columnArray objectAtIndex:aColumn]];
		
	}
	
	if (m==0) {
		//	NSMutableString *strcol2=[[NSMutableString alloc]initWithString:[_lDiagonalArrayPart1 objectAtIndex:aRow]];
		if (aRow+aColumn <15) {
			m=[self checkForWinForRow:aRow+1 setFlag:aFlag ForString:[_lDiagonalArrayPart1 objectAtIndex:aRow+aColumn]];
		}
		
		
	}
	if (m==0) {
		int row1=aColumn+aRow-15;
		if(row1>0 && row1<15)
		{
			//NSMutableString *columnStr=[[NSMutableString alloc]initWithString:[_lDiagonalArrayPart2 objectAtIndex:row1]];
			//m=[self checkForWinForRow:aRow+1 setFlag:aFlag ForString:columnStr];
			m=[self checkForWinForRow:aRow+1 setFlag:aFlag ForString:[_lDiagonalArrayPart2 objectAtIndex:row1]];
			
		}
	}
	
	if (m==0) {
		int row1=14-aColumn;
		row1=row1+aRow;
		if(row1>0 && row1<15)
		{
		//NSMutableString *columnStr=[[NSMutableString alloc]initWithString:[_rDiagonalArrayPart1 objectAtIndex:row1]];
		//	m=[self checkForWinForRow:aRow+1 setFlag:aFlag ForString:columnStr];
			m=[self checkForWinForRow:aRow+1 setFlag:aFlag ForString:[_rDiagonalArrayPart1 objectAtIndex:row1]];
			
		}
	}
	if (m==0) {
		int row1=aRow-aColumn;
		//		row1=row1+aRow;
		if(row1>0 && row1<15)
		{
			//NSMutableString *columnStr=[[NSMutableString alloc]initWithString:[_rDiagonalArrayPart2 objectAtIndex:row1]];
			//m=[self checkForWinForRow:aRow+1 setFlag:aFlag ForString:columnStr];
			m=[self checkForWinForRow:aRow+1 setFlag:aFlag ForString:[_rDiagonalArrayPart2 objectAtIndex:row1]];
			
		}
	}
	[mContainer setObject:_columnArray forKey:@"Column"];
	[mContainer setObject:_containerArray forKey:@"Row"];
	[mContainer setObject:_lDiagonalArrayPart1 forKey:@"LeftDiagonal1"];
	[mContainer setObject:_lDiagonalArrayPart2 forKey:@"LeftDiagonal2"];
	
	[mContainer setObject:_rDiagonalArrayPart1 forKey:@"Right1"];
	[mContainer setObject:_rDiagonalArrayPart2 forKey:@"Right2"];
	[mContainer setObject:_leftdiagonalArray forKey:@"Left"];
	[mContainer setObject:_rightdiagonalArray forKey:@"Right"];

	
	return m;	
	
}


-(NSInteger)checkForWinForRow:(int)aRow setFlag:(NSString*)aFlag ForString:(NSString*)aString
{
		
	NSString *winString=[[NSString alloc]initWithFormat:@"%@%@%@%@%@",aFlag,aFlag,aFlag,aFlag,aFlag];
	NSRange range;
	range=[aString rangeOfString:winString];
	
	NSLog(@"starting char is %f-----------------",range.location);
	
	if (range.length)
	{
		winFlag=1;
		
		[winString release];
		return winFlag;
		
	}
	[winString release];
	return 0;
	
}
-(void)createStringForRow:(int)aRow ForColumn:(int)aColumn withFlag:(NSString *)aFlag
{
	
	//to create the diagonals.
	if((aRow+aColumn)<15)
	{
		NSMutableString *tempString=[_lDiagonalArrayPart1 objectAtIndex:aColumn+aRow];
		NSString *part1                   =   [tempString substringToIndex:aColumn];
		NSString *part2                   =   [tempString substringFromIndex:aColumn+1];
		NSMutableString *completeString2   =   [[NSMutableString alloc]initWithFormat:@"%@%@%@",part1,aFlag,part2];
		[_lDiagonalArrayPart1 replaceObjectAtIndex:aRow+aColumn withObject:completeString2];
		[completeString2 autorelease];
		//	NSLog(@"ColumnString===========%@",completeString2);
	}
	else 
	{
		NSMutableString *tempString=[_lDiagonalArrayPart2 objectAtIndex:aRow+aColumn-15];
		NSString *part11                   =   [tempString substringToIndex:14-aRow];
		NSString *part12                   =   [tempString substringFromIndex:14-aRow+1];
		NSMutableString *completeString2   =   [[NSMutableString alloc]initWithFormat:@"%@%@%@",part11,aFlag,part12];
		[_lDiagonalArrayPart2 replaceObjectAtIndex:aRow+aColumn-15 withObject:completeString2];
		//	NSLog(@"-----------------%d",aRow+aColumn-15);
			[completeString2 autorelease];
		//NSLog(@"ColumnString===========%@",completeString2);
	}
	
	
	
	//[completeString2 autorelease];
	
}

-(void)createStringForRightSubDiagonalForRow:(int)aRow ForColumn:(int)aColumn withFlag:(NSString *)aFlag
{
	
	//to create the diagonals.
	if((14-aColumn+aRow)<15)
	{
		int row=14-aColumn;
		row=row+aRow;
		int col=14-aColumn;
		NSLog(@"Diagonal Row +++++++++ %d   n column %d",row,col);
		NSMutableString *tempString=[_rDiagonalArrayPart1 objectAtIndex:row];
		NSString *part1                   =   [tempString substringToIndex:col];
		NSString *part2                   =   [tempString substringFromIndex:col+1];
		NSMutableString *completeString2   =   [[NSMutableString alloc]initWithFormat:@"%@%@%@",part1,aFlag,part2];
		[_rDiagonalArrayPart1 replaceObjectAtIndex:row withObject:completeString2];
			[completeString2 autorelease];
	}	
	else {
		
		int row=aRow-aColumn;
		int col=aColumn;
		NSLog(@"Diagonal Row +++++++++ %d   n column %d",row,col);
		NSMutableString *tempString=[_rDiagonalArrayPart2 objectAtIndex:row];
		NSString *part1                   =   [tempString substringToIndex:col];
		NSString *part2                   =   [tempString substringFromIndex:col+1];
		NSMutableString *completeString2   =   [[NSMutableString alloc]initWithFormat:@"%@%@%@",part1,aFlag,part2];
		[_rDiagonalArrayPart2 replaceObjectAtIndex:row withObject:completeString2];
		[completeString2 autorelease];
	}
	
	
}
-(NSDictionary*)getDictionary;
{
	return(mContainer);
}
-(void)dealloc
{
	
	[_containerArray dealloc];
	[_rDiagonalArrayPart2 dealloc];
	[_rDiagonalArrayPart1 dealloc];
	[_lDiagonalArrayPart2 dealloc];
	[_lDiagonalArrayPart1 dealloc];
	[_columnArray dealloc];
	[_leftdiagonalArray dealloc];
	[_rightdiagonalArray dealloc];
	
	[mContainer dealloc];
	[super dealloc];
	
}
@end
