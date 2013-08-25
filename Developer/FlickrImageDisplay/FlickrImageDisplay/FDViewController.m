//
//  FDViewController.m
//  FlickrImageDisplay
//
//  Created by test on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FDViewController.h"

@implementation FDViewController

NSString *const FlickrAPIKey = @"aa621a9050ef8dfbd9621cc311da86aa";

-(void)searchFlickrPhotos:(NSString *)text
{
    // Build the string to call the Flickr API
    NSString *urlString = 
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=15&format=json&nojsoncallback=1", FlickrAPIKey, text];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    // Store incoming data into a string
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Create a dictionary from the JSON string
    NSDictionary *results = [jsonString JSONValue];
    
    // Build an array from the dictionary for easy access to each entry
    NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    
    // Loop through each entry in the dictionary...
    for (NSDictionary *photo in photos)
    {
        // Get title of the image
        NSString *title = [photo objectForKey:@"title"];
    
        // Save the title to the photo titles array
        [photoTitles addObject:(title.length > 0 ? title : @"Untitled")];
        
        // Build the URL to where the image is stored (see the Flickr API)
        // In the format http://farmX.static.flickr.com/server/id_secret.jpg
        // Notice the "_s" which requests a "small" image 75 x 75 pixels
        NSString *photoURLString = 
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", 
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"], 
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        NSLog(@"photoURLString: %@", photoURLString);
        
        // The performance (scrolling) of the table will be much better if we
        // build an array of the image data here, and then add this data as
        // the cell.image value (see cellForRowAtIndexPath:)
        [photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
        
        // Build and save the URL to the large image so we can zoom
        // in on the image if requested
        photoURLString = 
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", 
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"], 
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        [photoURLsLargeImage addObject:[NSURL URLWithString:photoURLString]];        
        
        NSLog(@"photoURLsLareImage: %@\n\n", photoURLString); 
    } 
    // Update the table with data
    [theTableView reloadData];
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
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    // Initialize our arrays
    photoTitles = [[NSMutableArray alloc] init];
    photoSmallImageData = [[NSMutableArray alloc] init];
    photoURLsLargeImage = [[NSMutableArray alloc] init];
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 240, 320, 220)];
    [theTableView setDelegate:self];
    [theTableView setDataSource:self];
    [theTableView setRowHeight:80];
    [theTableView setBackgroundColor:[UIColor grayColor]];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:theTableView];
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 100, 100, 40)];
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    searchTextField.placeholder = @"search";
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.delegate = (id)self;
    [self.view addSubview:searchTextField];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(220, 110, 15, 15)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                          UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleTopMargin |
                                          UIViewAutoresizingFlexibleBottomMargin);
    [activityIndicator sizeToFit];
    activityIndicator.hidesWhenStopped = YES; 
    [self.view addSubview:activityIndicator];
    // Notice that I am hard-coding the search tag at this point (@"iPhone")    
    [self searchFlickrPhotos:@"iPhone"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // Remove any content from a previous search
    [photoTitles removeAllObjects];
    [photoSmallImageData removeAllObjects];
    [photoURLsLargeImage removeAllObjects];
    
    // Begin the call to Flickr
    [self searchFlickrPhotos:searchTextField.text];
    
    // Start the busy indicator
    [activityIndicator startAnimating];
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section 
{
    return [photoTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:@"cachedCell"];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] 
                 initWithFrame:CGRectZero reuseIdentifier:@"cachedCell"];
    
#if __IPHONE_3_0
    cell.textLabel.text = [photoTitles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
#else
    cell.text = [photoTitles objectAtIndex:indexPath.row];
    cell.font = [UIFont systemFontOfSize:13.0];
#endif
    
    NSData *imageData = [photoSmallImageData objectAtIndex:indexPath.row];
    
#if __IPHONE_3_0
    cell.imageView.image = [UIImage imageWithData:imageData];
#else
    cell.image = [UIImage imageWithData:imageData];
#endif
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    searchTextField.hidden = YES;
    
    // If we've created this VC before...
    if (fullImageViewController != nil)
    {
        // Slide this view off screen
        CGRect frame = fullImageViewController.frame;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.45];
        
        // Off screen location
        frame.origin.x = -320;
        fullImageViewController.frame = frame;
        
        [UIView commitAnimations];
    }
    
    [self performSelector:@selector(showZoomedImage:) withObject:indexPath afterDelay:0.1];
}
- (void)showZoomedImage:(NSIndexPath *)indexPath
{
    // Remove from view (and release)
    if ([fullImageViewController superview])
        [fullImageViewController removeFromSuperview];
    
    fullImageViewController = [[ZoomedImageView alloc] initWithURL:[photoURLsLargeImage objectAtIndex:indexPath.row]];
    
    [self.view addSubview:fullImageViewController];
    
    // Slide this view off screen
    CGRect frame = fullImageViewController.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.45];
    
    // Slide the image to its new location (onscreen)
    frame.origin.x = 0;
    fullImageViewController.frame = frame;
    
    [UIView commitAnimations];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

@end
