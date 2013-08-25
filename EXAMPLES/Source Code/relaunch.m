//
//  relaunch.m
//  Media Browser
//
//  Created by Sandeep GS on 21/06/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//


#pragma mark Main method
int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	pid_t parentPID = atoi(argv[2]);
	ProcessSerialNumber psn;
	while (GetProcessForPID(parentPID, &psn) != procNotFound)
		sleep(1);
	
	NSString *appPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
	BOOL success = [[NSWorkspace sharedWorkspace] openFile:[appPath stringByExpandingTildeInPath]];
	
	if (!success){
//		NSLog(@"Error: could not relaunch application at %@", appPath);	
	}
	else {
//		NSLog(@"application relaunched at %@", appPath);
	}

	
	[pool release];
	return (success) ? 0 : 1;
}
#pragma -