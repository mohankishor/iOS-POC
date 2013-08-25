//
//  Director.h
//  OGLGame
//
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "SynthesizeSingleton.h"
#import "Common.h"

@class AbstractScene;

@interface Director : NSObject {
	
	// Currently bound texture name
	GLuint currentlyBoundTexture;
	// Current game state
	GLuint currentGameState;
	// Current scene
	AbstractScene *currentScene;
	// Dictionary of scenes
	NSMutableDictionary *_scenes;
	// Global alpha
	GLfloat globalAlpha;
    // Frames Per Second
    float framesPerSecond;
	
	// The parent uiview
	UIView *_parentView;
}

@property (nonatomic, assign) GLuint currentlyBoundTexture;
@property (nonatomic, assign) GLuint currentGameState;
@property (nonatomic, retain) AbstractScene *currentScene;
@property (nonatomic, assign) GLfloat globalAlpha;
@property (nonatomic, assign) float framesPerSecond;
@property (nonatomic, retain) UIView *_parentView;

+ (Director*)sharedDirector;
- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene;
- (BOOL)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey;
- (BOOL)transitionToSceneWithKey:(NSString*)aSceneKey;

- (void)setParentView:(UIView*)theView;
- (void)setSettingsViewVisible;

@end
