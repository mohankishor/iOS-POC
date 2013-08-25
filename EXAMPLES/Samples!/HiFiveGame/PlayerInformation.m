//
//  PlayerInformation.m
//  HiFiveGame
//
//  Created by Devika on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerInformation.h"


@implementation PlayerInformation
@synthesize mName;
@synthesize mPlayerWindow;
-(id)init
{
	if (self==[super init]) {
	//	[[NSNotificationCenter defaultCenter]postNotificationName:@"NameChangedNotification" object:self];
		//[NSBundle loadNibNamed:@"PlayerInformation" owner:self];
		
	}
	return self;
}
-(void)awakeFromNib{
	[mPlayerWindow setLevel:7];
	[mPlayerWindow makeKeyAndOrderFront:self];
	
}
-(IBAction)setPlayerName:(id)sender
{
	if ([[mNameField stringValue]isEqualToString:@""]) {
		mName=@"Player";
	}
	else
	mName=[mNameField stringValue];
	[[NSNotificationCenter defaultCenter]postNotificationName:@"NameChangedNotification" object:self];

	[mPlayerWindow orderOut:self];
	}
@end
