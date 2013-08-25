//
//  SplashScene.m
//  TouchShot
//
//  Created by Jeff on 10/02/2010.
//  Copyright 2010 Applausible . All rights reserved.
//

#import "SplashScene.h"

#define SPLASH_DISPLAY_TIME 4

@interface SplashScene (Private)
// Initialize the sound needed for this scene
- (void)initSound;
@end

@implementation SplashScene

- (id)init {
	
	if(self == [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
        
        _sceneFadeSpeed = 0.2f;
        
		// This scene is displayed immediately
		sceneAlpha = 1.0f;
		[_sharedDirector setGlobalAlpha:sceneAlpha];
		
		// Setup the splash image background
		_splashImage = [[Image alloc] initWithImage:@"splash.png"];
		
		// Setup splash time
		_splashTimerTick = 0.0f;
		_splashTime = 0;
		
		// Set that the FX hasnt been played
		_playedIntroFX = NO;
		
		// Init the sound
		[self initSound];
		
		// Set the next scene
		nextSceneKey = @"menu";
	}
	return self;
}

- (void)updateWithDelta:(GLfloat)theDelta {
	
	switch (sceneState) {
		case kSceneState_Running:

			// Check if should play the intro sound effect
			if(!_playedIntroFX) {
				[_sharedSoundManager playSoundWithKey:@"splash_cheer" gain:1.0f pitch:1.0f location:CGPointMake(160, 240) shouldLoop:NO sourceID:-1];
				_playedIntroFX = YES;
			}	
			
			// Check time
			_splashTimerTick += theDelta;
			if(_splashTimerTick > 1.0) {
				_splashTime++;
				
				// Check is the splash over
				if(_splashTime >= SPLASH_DISPLAY_TIME) {
					sceneState = kSceneState_TransitionOut;
				}
				
				// Reset
				_splashTimerTick = 0.0f;
			}
			
			break;
		case kSceneState_TransitionOut:
			// The fade out
			sceneAlpha -= _sceneFadeSpeed * theDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			
			if(sceneAlpha < 0)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey]) {
					
                    sceneState = kSceneState_TransitionIn;
				}
			break;
			
		case kSceneState_TransitionIn:
			
			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
            sceneAlpha += _sceneFadeSpeed * 0.02f;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
			
		default:
			break;
	}
}

- (void)setSceneState:(uint)theState {
	sceneState = theState;
	if(sceneState == kSceneState_TransitionOut)
		sceneAlpha = 1.0f;
	if(sceneState == kSceneState_TransitionIn)
		sceneAlpha = 0.0f;
}
- (void)transitionToSceneWithKey:(NSString*)theKey {
	sceneState = kSceneState_TransitionOut;
	sceneAlpha = 1.0f;
}

- (void)render {
	// Render the splash background
	[_splashImage renderAtPoint:CGPointMake(160, 240) centerOfImage:YES];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [_splashImage release];
    [super dealloc];
}

@end

#pragma mark -
#pragma mark Private implementation

@implementation SplashScene (Private)

#pragma mark -
#pragma mark Initialize sound

- (void)initSound {
	
    [_sharedSoundManager setListenerPosition:CGPointMake(160.0, 240.0)];
	
	// Set the master sound FX volume
	[_sharedSoundManager setFxVolume:0.5];
	[_sharedSoundManager loadSoundWithKey:@"splash_cheer" musicFile:@"cheering.caf"];	
}

@end
