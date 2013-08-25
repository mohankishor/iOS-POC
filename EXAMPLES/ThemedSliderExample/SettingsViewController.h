//
//  SettingsViewController.h
//  SplashExample
//
//  Created by Jeff Hodnett on 05/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Director.h"
#import "SoundManager.h"

@interface SettingsViewController : UIViewController {
	// The shared director
	Director *_sharedDirector;
	
	// The sound manager
	SoundManager *_sharedSoundManager;
	
	// The sliders
	IBOutlet UISlider *_fxVolumeSlider;
	IBOutlet UISlider *_musicVolumeSlider;
}

@property(retain, nonatomic) IBOutlet UISlider *_fxVolumeSlider;
@property(retain, nonatomic) IBOutlet UISlider *_musicVolumeSlider;

- (IBAction)wowButtonPressed:(id)sender; 

@end
