//
//  AbstractState.m
//  OGLGame
//
//

#import "AbstractScene.h"

@implementation AbstractScene

@synthesize sceneState;
@synthesize sceneAlpha;

- (id) init {
	
	if(self == [super init]) {
		
	}
	return self;
}

- (void)updateWithDelta:(GLfloat)aDelta {
}


- (void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
}

- (void)transitionToSceneWithKey:(NSString*)aKey {
}

- (void)render {
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

@end