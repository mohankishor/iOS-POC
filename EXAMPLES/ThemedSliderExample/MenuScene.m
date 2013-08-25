//
//  MenuState.m
//  OGLGame
//
//

#import "MenuScene.h"

@interface MenuScene (Private)
// Initialize the sound needed for this scene
- (void)initSound;
// Reset the game on entry
- (void) resetScene;
@end

@implementation MenuScene

- (id)init {
	
	if(self == [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
        
        _sceneFadeSpeed = 1.2f;
        sceneAlpha = 0.0f;
		sceneAudioLevel = 0.0f;
		
        [_sharedDirector setGlobalAlpha:sceneAlpha];
		
		// Grab the bounds of the screen
		_screenBounds = [[UIScreen mainScreen] bounds];
				
		menuBackground = [[Image alloc] initWithImage:@"wallpaper-clown-fish.jpg"];
		
		[self setSceneState:kSceneState_TransitionIn];
		nextSceneKey = nil;
		
		// Setup the sounds
		[self initSound];
		
		// Play a background sound
		[_sharedSoundManager playMusicWithKey:@"menu_music" timesToRepeat:-1];

	}
	return self;
}

#pragma mark -
#pragma mark Initialize sound

- (void)initSound {
	[_sharedSoundManager setMusicVolume:0.5f];
	[_sharedSoundManager loadBackgroundMusicWithKey:@"menu_music" musicFile:@"phone_loop.wav"];	
}

- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
    UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
	
	// Set the settings view visible
	[_sharedDirector setSettingsViewVisible];
	sceneState = kSceneState_Paused;
}

- (void)updateWithDelta:(GLfloat)aDelta {
	
	switch (sceneState) {
		case kSceneState_Running:
			
			break;
			
		case kSceneState_TransitionOut:
			// The fade out
			sceneAlpha -= _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];

			if(sceneAlpha < 0) {
				// Reset the scene
				[self resetScene];
				
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey]) {
					
                    sceneState = kSceneState_TransitionIn;
				}
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


- (void) resetScene {
	
}

- (void)render {
	// Render the background
	[menuBackground renderAtPoint:CGPointMake(160, 240) centerOfImage:YES];

}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[menuBackground release];
    [super dealloc];
}


@end
