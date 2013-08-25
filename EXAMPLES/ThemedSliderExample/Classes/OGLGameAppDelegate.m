//
//  Tutorial1AppDelegate.m
//  Tutorial1
//
//

#import "OGLGameAppDelegate.h"
#import "EAGLView.h"

@implementation OGLGameAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	// Not using any NIB files anymore, we are creating the window and the
    // EAGLView manually.
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	//[window setMultipleTouchEnabled:YES];
	
	glView = [[[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds] retain];
	//[glView setMultipleTouchEnabled:YES];
		
    // Add the glView to the window which has been defined
	[window addSubview:glView];
	[window makeKeyAndVisible];
    
	// Since OS 3.0, just calling [glView mainGameLoop] did not work, you just got a black screen.
    // It appears that others have had the same problem and to fix it you need to use the 
    // performSelectorOnMainThread call below.
    [glView performSelectorOnMainThread:@selector(mainGameLoop) withObject:nil waitUntilDone:NO]; 

}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
	
}


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
