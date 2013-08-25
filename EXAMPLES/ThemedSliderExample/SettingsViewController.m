//
//  SettingsViewController.m
//  SplashExample
//
//  Created by Jeff Hodnett on 05/04/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize _fxVolumeSlider;
@synthesize _musicVolumeSlider;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Setup the director
		_sharedDirector = [Director sharedDirector];
		
		// Setup the sound manager
		_sharedSoundManager = [SoundManager sharedSoundManager];
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[super viewDidLoad];
	
	// Setup custom slider images
	UIImage *minImage = [UIImage imageNamed:@"grey_track.png"];
	UIImage *maxImage = [UIImage imageNamed:@"white_track.png"];
	UIImage *tumbImage= [UIImage imageNamed:@"metal_screw.png"];
	
	minImage=[minImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	maxImage=[maxImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	
	// Setup the FX slider
	[_fxVolumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
	[_fxVolumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
	[_fxVolumeSlider setThumbImage:tumbImage forState:UIControlStateNormal];
	
	_fxVolumeSlider.minimumValue = 0.0;
	_fxVolumeSlider.maximumValue = 1.0;
	_fxVolumeSlider.continuous = YES;
	_fxVolumeSlider.value = [_sharedSoundManager fxVolume];
	
	// Attach an action to sliding
	[_fxVolumeSlider addTarget:self action:@selector(fxSliderAction:) forControlEvents:UIControlEventValueChanged];
	
	// Setup the Music slider
	[_musicVolumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
	[_musicVolumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
	[_musicVolumeSlider setThumbImage:tumbImage forState:UIControlStateNormal];
	
	_musicVolumeSlider.minimumValue = 0.0;
	_musicVolumeSlider.maximumValue = 1.0;
	_musicVolumeSlider.continuous = YES;
	_musicVolumeSlider.value = [_sharedSoundManager musicVolume];
	
	// Attach an action to sliding
	[_musicVolumeSlider addTarget:self action:@selector(musicSliderAction:) forControlEvents:UIControlEventValueChanged];	
	
	// Cleanup
	minImage = nil;
	maxImage = nil;
	tumbImage = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)wowButtonPressed:(id)sender {
	// Remove the settings view
	[_sharedDirector._parentView removeAllSubviews];
	// Set the current scene back to running
	[[_sharedDirector currentScene] setSceneState:kSceneState_Running];
}

#pragma mark Sliders Events

- (void) fxSliderAction:(id)sender {
	[_sharedSoundManager setFxVolume:_fxVolumeSlider.value];
}

- (void) musicSliderAction:(id)sender {
	[_sharedSoundManager setMusicVolume:_musicVolumeSlider.value];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
