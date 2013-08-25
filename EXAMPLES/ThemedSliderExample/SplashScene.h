//
//  SplashScene.h
//  TouchShot
//
//  Created by Jeff on 10/02/2010.
//  Copyright 2010 Applausible . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"

@interface SplashScene : AbstractScene {
	
	Image *_splashImage;
	
	GLfloat _splashTimerTick;
	int _splashTime;
	
	BOOL _playedIntroFX;
}

@end
