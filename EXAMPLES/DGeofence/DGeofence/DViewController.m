//
//  DViewController.m
//  DGeofence
//
//  Created by Darshan Sonde on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DViewController.h"
#import "Fence.h"

//#define URL @"http://larkydev.sourcebits.com"
#define URL @"http://192.168.31.2:3000"
@interface DViewController() {
    CLLocationManager *mLocationManager;
}

-(NSManagedObjectContext*) managedObjectContext;
- (void)zoomToFitMapAnnotations;
-(void) fetchAllFences;
-(void) removePin:(NSManagedObject*)obj;

-(void) addRegionForFence:(Fence*) obj;
-(void) updateRegionForFence:(Fence*) obj;
-(void) removeRegionForFence:(Fence*) obj;
-(Fence*) fenceForIdentifier:(NSString*)identifier;
@end


@implementation DViewController
@synthesize mapView;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        [self locationManager];
    }
    return self;
}
-(void) awakeFromNib
{
    [self locationManager];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fenceChanged:) name:@"FenceChanged" object:nil];
	[self fetchAllFences];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - push methods

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"addPin"]) {
        DAddViewController *vc = (DAddViewController*)[[segue destinationViewController] topViewController];
        vc.delegate = [segue sourceViewController];
    }
}

#pragma mark - custom methods

-(NSManagedObjectContext*) managedObjectContext{
    return [[DDataManager sharedInstance] managedObjectContext];
}

-(CLLocationManager*) locationManager
{
    if(!mLocationManager) {
        mLocationManager = [[CLLocationManager alloc] init];
        mLocationManager.delegate = self;
        [mLocationManager startMonitoringSignificantLocationChanges];//if this is not done. none of the regions get any updates. not sure why
    }
    return mLocationManager;
}

#pragma mark - alert delegates
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0) {
        for(NSManagedObject *obj in [self.mapView selectedAnnotations]) {
            if([alertView.title isEqualToString:[obj valueForKey:@"title"]]) {
                [self removePin:obj];
            }
        }
    }
}

#pragma mark - map methods
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [self zoomToFitMapAnnotations];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(annotation == self.mapView.userLocation) {
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pin.draggable = YES;
    pin.canShowCallout = YES;
    UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.rightCalloutAccessoryView = disclosure;
    return pin;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[view.annotation title] message:@"Are you sure you want to delete this?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK"   , nil];
    [alert show];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay 
{
    MKCircleView* circleView = [[MKCircleView alloc] initWithOverlay:overlay] ;
    circleView.fillColor = [UIColor colorWithRed:0.7 green:0.4 blue:0.2 alpha:0.5];
    return circleView;
}
- (void)zoomToFitMapAnnotations
{
    if([mapView.annotations count] == 0)
        return;
    
	if([mapView.annotations count] == 1){
		NSObject<MKAnnotation> *annotation = [mapView.annotations objectAtIndex:0];
		CLLocationCoordinate2D location;
		location.latitude = annotation.coordinate.latitude;
		location.longitude = annotation.coordinate.longitude;
		
		MKCoordinateSpan span;
		span.latitudeDelta = 0.05;
		span.longitudeDelta = 0.05;
		MKCoordinateRegion region = {location, span};
		[mapView setRegion:region animated:YES];
		return;
	}
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    for(NSObject<MKAnnotation> *annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
	
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; 
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; 
	
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

#pragma mark - fence methods

-(void) addRegionForFence:(Fence*) obj
{
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:obj.coordinate
                                                               radius:[obj.radius doubleValue]
                                                           identifier:obj.title];
    [[self locationManager] startMonitoringForRegion:region 
                                     desiredAccuracy:kCLLocationAccuracyBest];
}
-(void) updateRegionForFence:(Fence*) obj
{
    [self addRegionForFence:obj];
}
-(void) removeRegionForFence:(Fence*) obj
{
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:obj.coordinate
                                                               radius:[obj.radius doubleValue]
                                                           identifier:obj.title];
    [[self locationManager] stopMonitoringForRegion:region];
}

#pragma mark - delegate method

-(void) addPinWithIdentifier:(NSString *)identifier radius:(double)radius accuracy:(double)accuracy
{
    if([CLLocationManager regionMonitoringAvailable] && [CLLocationManager regionMonitoringEnabled]) {
        Fence *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Fence" inManagedObjectContext:[self managedObjectContext]];
        obj.title = identifier;
        obj.accuracy = [NSNumber numberWithDouble:accuracy];
        obj.radius = [NSNumber numberWithDouble:radius];
        obj.coordinate = self.mapView.centerCoordinate;
        [self.mapView addAnnotation:obj];
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:obj.coordinate radius:[obj.radius doubleValue]];
        obj.circle = circle;
        [self.mapView addOverlay:circle];
        
        [self addRegionForFence:obj];
        
        self.navigationItem.prompt = @"Drag and move the pins";
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Monitoring Disabled" message:@"Either Region monitoring is not available or is disabled!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
-(void) removePin:(NSManagedObject*) obj
{
    [self removeRegionForFence:(Fence*)obj];
    [self.mapView removeOverlay:((Fence*) obj).circle];
    [self.mapView removeAnnotation:(NSObject<MKAnnotation>*)obj];
    [[self managedObjectContext] deleteObject:obj];   
}

-(void) fenceChanged:(NSNotification*) notif
{
    Fence *obj = (Fence*)[[notif userInfo] objectForKey:@"fence"];
    [self updateRegionForFence:obj];
    [self.mapView removeOverlay:[obj circle]];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:obj.coordinate radius:[obj.radius doubleValue]];
    obj.circle = circle;
    [self.mapView addOverlay:circle];
    [[DDataManager sharedInstance] saveContext];
}

-(void) fetchAllFences {
    //fetch all current geo reminders and add
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fence" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fences = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if(error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Fetching" message:@"Not able to get fences stored" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.mapView addAnnotations:fences];
        for(Fence *f in fences) {
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:f.coordinate radius:[f.radius doubleValue]];
            [self.mapView addOverlay:circle];
            f.circle = circle;
        }
    }
}
-(Fence*) fenceForIdentifier:(NSString*)identifier
{
    Fence *ret=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fence" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_string = %@",identifier];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fences = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if(error || [fences count]<1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No stored fence found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        ret = [fences objectAtIndex:0];
    }
    return ret;
}
#pragma mark - Location Manager Delegates

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.alertBody = [NSString stringWithFormat:@"Elvis has entered the %@!!",region.identifier];
    localNotification.alertAction = @"OK";
    localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:region.identifier,@"fence",
                                  [NSNumber numberWithBool:YES],@"isEntering",nil];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.alertBody = [NSString stringWithFormat:@"Elvis has left the %@",region.identifier];
    localNotification.alertAction = @"OK";
    localNotification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:region.identifier,@"fence",
                                  [NSNumber numberWithBool:NO],@"isEntering",nil];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.alertBody = [NSString stringWithFormat:@"NOOOOOOO!!! Pirates stole your discount! Not able to monitor the region got error %@ description-%@",[error localizedFailureReason],[error localizedDescription]];
    localNotification.alertAction = @"OK";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];

}

#pragma mark - perk methods

- (IBAction)fetchPerks:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Current Location",@"Map Center", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CLLocationCoordinate2D point;
    if(buttonIndex==0) {
        //current location
        point = self.mapView.userLocation.coordinate;
    } else if(buttonIndex==1) {
        //map center
        point = self.mapView.centerCoordinate;
    }
    
    if(buttonIndex!=2) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^(void) {
            NSError *error=nil;
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"]==nil) {
                NSURL *url = [NSURL URLWithString:URL @"/users/sign_in.json"];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"darshan+geo@sourcebits.com",@"email",@"larky123",@"password", nil];
                NSDictionary *postDataDict = [NSDictionary dictionaryWithObjectsAndKeys:dict, @"user",nil];
                
                NSURLRequest *request = [self requestWithURL:url
                                                      params:postDataDict];
                
            
                NSURLResponse *response;
                NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
                if(error == nil) {
                    if ([response respondsToSelector:@selector(allHeaderFields)]) {
                        NSDictionary *dictionary = [(NSHTTPURLResponse*)response allHeaderFields];
                        [[NSUserDefaults standardUserDefaults] setValue:[dictionary objectForKey:@"Set-Cookie"] forKey:@"cookie"];
                    }
                } else {
                    NSLog(@"got error %@",[error localizedDescription]);
                }
            } 
            
            NSString *urlString = [NSString stringWithFormat:URL @"/perks/search_merchant.json?notification=true&current=true&location[latitude]=%f&location[longitude]=%f",point.latitude,point.longitude];
            NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"] forHTTPHeaderField:@"Cookie"];
            
            NSHTTPURLResponse *response;
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
            if(error == nil) {
                NSDictionary *loginResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSLog(@"got result of merchants!! %@ status = %d",loginResponse,[response statusCode]);
                
                [[loginResponse objectForKey:@"merchants"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

                    NSString *urlString = [NSString stringWithFormat:URL @"/perks/search_perk.json?location[latitude]=%f&location[longitude]=%f&merchant_id=%@current=true&notification=true",point.latitude,point.longitude,[[obj objectForKey:@"merchant"] objectForKey:@"id"]];
                    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"] forHTTPHeaderField:@"Cookie"];
                    
                    NSError *error;
                    
                    NSHTTPURLResponse *response;
                    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                         returningResponse:&response
                                                                     error:&error];
                    
                    NSLog(@"got response code %d data %@",[response statusCode],[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    
                    NSDictionary *perkData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    if(error == nil) {
                        NSString *identifier = [NSString stringWithFormat:@"%@ - %@",[perkData objectForKey:@"merchant_id"],[perkData objectForKey:@"name"]];
                        NSArray *perkLocations = [perkData objectForKey:@"locations"];
                        [perkLocations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            NSString *unique_identifier = [NSString stringWithFormat:@"%@ - %d",identifier,idx];
                            
                            dispatch_queue_t main_queue = dispatch_get_main_queue();
                            
                            dispatch_async(main_queue, ^{
                                Fence *f = [NSEntityDescription insertNewObjectForEntityForName:@"Fence" inManagedObjectContext:[self managedObjectContext]];
                                f.title = unique_identifier;
                                f.accuracy = [NSNumber numberWithDouble:kCLLocationAccuracyBest];
                                f.radius = [NSNumber numberWithDouble:20.0];
                                CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([[obj objectForKey:@"latitude"] doubleValue], [[obj objectForKey:@"longitude"] doubleValue]);
                                f.coordinate = loc;
                                [self.mapView addAnnotation:f];
                                MKCircle *circle = [MKCircle circleWithCenterCoordinate:f.coordinate radius:[f.radius doubleValue]];
                                f.circle = circle;
                                [self.mapView addOverlay:circle];
                                
                                [self addRegionForFence:f];

                            });
                        }];
                    } 

                }];
            } else {
                NSLog(@"got error %@",[error localizedDescription]);
            }
            
        });
    }
}

-(NSURLRequest*) requestWithURL:(NSURL*)url params:(NSDictionary*) dictionary
{
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if(error) {
        return nil;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    
    return request;
}
@end
