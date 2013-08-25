//
//  PlayerInformation.h
//  HiFiveGame
//
//  Created by Devika on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PlayerInformation : NSObject {
	IBOutlet NSTextField *mNameField;
	NSString *mName;
	IBOutlet NSWindow *mPlayerWindow;

}
@property(nonatomic,retain)NSString *mName;
@property(nonatomic,retain)NSWindow *mPlayerWindow;
-(IBAction)setPlayerName:(id)sender;
@end
